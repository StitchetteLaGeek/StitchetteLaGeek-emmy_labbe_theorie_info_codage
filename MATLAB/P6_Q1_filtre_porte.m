%% Partie 6 - Question 1
% Filtre porte et filtre adapte

clear;
clc;
close all;

%% Parametres

P = parametres_perso('LABBE Emmy');
L = P.L;

% nombre de bits
Nbits = 20;

%% Source binaire equiprobable

bits = randi([0 1], 1, Nbits);

% Conversion antipodale
% 0 -> -1
% 1 -> +1
symboles = 2*bits - 1;

%% Surechantillonnage par insertion de zeros

x = zeros(1, Nbits*L);

x(1:L:end) = symboles;

%% Filtre porte

% Normalisation a energie unite
h = ones(1,L) / sqrt(L);

%%mise en forme

signal_emis = conv(x, h);

%% Filtre adapte

% Pour une porte reelle et symetrique :
% h(-t) = h(t)

signal_filtre = conv(signal_emis, h);

%% Trace

figure;

plot(signal_emis);

grid on;
xlabel('Echantillons');
ylabel('Amplitude');
title('Signal apres filtre de mise en forme porte');

figure;

plot(signal_filtre);

grid on;
xlabel('Echantillons');
ylabel('Amplitude');
title('Signal apres filtre adapte');

%% Reponse globale des deux filtres

h_global = conv(h,h);

figure;

stem(h_global);

grid on;
xlabel('Echantillons');
ylabel('Amplitude');
title('Reponse globale porte + filtre adapte');

%% Verification du TEB avec filtre porte

Nbits = 1e5;

EbN0_dB = 0:9;
EbN0 = 10.^(EbN0_dB/10);

Qfun = @(x) 0.5 * erfc(x/sqrt(2));

TEB_simule = zeros(size(EbN0_dB));
TEB_theorique = Qfun(sqrt(2*EbN0));

%% Nouvelle source longue

bits = randi([0 1], 1, Nbits);

symboles = 2*bits - 1;

%% Surechantillonnage

x = zeros(1, Nbits*L);
x(1:L:end) = symboles;

%% Filtre porte normalise
h = ones(1,L)/sqrt(L);

%% Signal emis

signal_emis = conv(x,h);

%% Simulation pour chaque Eb/N0

for k = 1:length(EbN0_dB)

    % Eb = 1 avec le filtre normalise
    Eb = 1;
    N0 = Eb / EbN0(k);

    % Bruit par echantillon
    sigma = sqrt(N0/2);
    bruit = sigma * randn(size(signal_emis));
    signal_recu = signal_emis + bruit;

    %% Filtre adaptee
    sortie = conv(signal_recu, h);

    %%echantillonnage au maximum du filtre global

    retard = L;

    indices = retard:L:retard + (Nbits-1)*L;

    z = sortie(indices);

    %% decision

    bits_recus = z > 0;

    %% TEB

    TEB_simule(k) = mean(bits_recus ~= bits);

end

%% Affichage

fprintf('\nEb/N0(dB)   Theorie       Simulation\n');

for k = 1:length(EbN0_dB)

    fprintf('%3d         %.6e    %.6e\n', ...
        EbN0_dB(k), ...
        TEB_theorique(k), ...
        TEB_simule(k));

end

%% Trace

figure;

semilogy(EbN0_dB, TEB_theorique, '-o', 'LineWidth', 1.5);
hold on;

semilogy(EbN0_dB, TEB_simule, '-x', 'LineWidth', 1.5);

grid on;

xlabel('E_b/N_0 (dB)');
ylabel('TEB');

title('TEB avec filtre porte et filtre adapte');

legend('Theorie', ...
       'Simulation', ...
       'Location', 'southwest');