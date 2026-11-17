%% Partie 6 - Question 5
% Chaine QPSK avec filtres RRC

clear;
clc;
close all;

%% Parametres

P = parametres_perso('LABBE Emmy');

L = P.L;
alpha = P.alpha;
span = 10;
Nbits = 2e4;
EbN0_dB = 5;

%% source

bits = randi([0 1], 1, Nbits);

%% Modulation QPSK Gray

symboles = qpsk_mod(bits);

%% Surechantillonnage

x = zeros(1, length(symboles)*L);

x(1:L:end) = symboles;

%% Filtre RRC emissionn

h = rcosdesign(alpha, span, L, 'sqrt');

signal_emis = conv(x, h);

%% Bruit

% Pour QPSK normaliser:
% Es = 1
% Eb = 1/2

Eb = 0.5;

EbN0 = 10^(EbN0_dB/10);

N0 = Eb / EbN0;

sigma = sqrt(N0/2);

bruit = sigma * ...
    (randn(size(signal_emis)) + ...
     1j*randn(size(signal_emis)));

signal_recu = signal_emis + bruit;

%% Filtre adapter

signal_filtre = conv(signal_recu, h);

%% retard total des deux filtres

retard = span * L;

%% Echantillonnage

indices = retard + 1 : L : ...
    retard + 1 + (length(symboles)-1)*L;

symboles_recus = signal_filtre(indices);

%% Constellation

figure;

plot(real(symboles_recus), ...
     imag(symboles_recus), '.');

grid on;
axis equal;

xlabel('I');
ylabel('Q');

title(sprintf( ...
    'Constellation QPSK apres filtrage RRC - Eb/N0 = %d dB', ...
    EbN0_dB));

xlim([-1.5 1.5]);
ylim([-1.5 1.5]);

%% Demodulation

bits_recus = qpsk_demod(symboles_recus(:));
TEB = mean(bits_recus ~= bits);

fprintf('TEB apres filtrage RRC = %.6f\n', TEB);

%%Diagramme de l'oeil corrige

% Partie reelle du signal apres filtre adapte
signal_oeil = real(signal_filtre);

% suppression du retard total des deux filtres
signal_oeil = signal_oeil(retard+1:end-retard);

% une trace contient 2 symboles
N_oeil = 2*L;

figure;
hold on;

% On commence chaque nouvelle trace un symbole plus loin
nb_traces = floor((length(signal_oeil)-N_oeil)/L);

for k = 1:min(nb_traces,40)
    debut = (k-1)*L + 1;
    fin = debut + N_oeil - 1;

    plot((0:N_oeil-1)/L, ...
         signal_oeil(debut:fin));

end

grid on;

xlabel('Temps / T');
ylabel('Amplitude');

title('Diagramme de l''oeil apres filtre adapte');

xlim([0 2]);