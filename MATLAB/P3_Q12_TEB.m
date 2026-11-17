%% Question 12 - TEB en fonction de Eb/N0

clear;
clc;
close all;

%% Parametres

P = parametres_perso('LABBE Emmy');

A = P.A;
L = P.L;

Tb = 1;
Te = Tb / L;

% nombre de bits simules
Nbits = 1e6;

% Valeurs de Eb/N0 testees
EbN0_dB = 0:9;

% tableaux de resultats
TEB_integration = zeros(size(EbN0_dB));
TEB_sans_integration = zeros(size(EbN0_dB));
TEB_theorique = zeros(size(EbN0_dB));

% Fonction Q
Q = @(x) 0.5 * erfc(x/sqrt(2));

%% Generation de la source equiprobable

bits = source(Nbits, 0.5);

% Conversion en niveaux antipodaux
% 0 -> -A
% 1 -> +A
x_bits = A * (2*bits - 1);

% chaque bit est repete L fois
x = repelem(x_bits, L);

%% Simulation

for i = 1:length(EbN0_dB)

    % Passage de dB en lineaire
    EbN0 = 10^(EbN0_dB(i)/10);

    % Energie par bit
    Eb = A^2 * Tb;

    % Calcul de N0
    N0 = Eb / EbN0;

    % Variance du bruit par echantillon
    sigma2 = N0 * L / (2*Tb);

    sigma = sqrt(sigma2);

    % Bruit gaussien
    bruit = sigma * randn(size(x));

    % Signal recu
    r = x + bruit;


    %% Detection avec integration

    % Mise sous forme de matrice :
    % une colonne correspond a un bit
    r_blocs = reshape(r, L, Nbits);

    % Moyenne des L echantillons de chaque bit
    z = mean(r_blocs, 1);

    % Decision avec seuil nul
    bits_recus = z > 0;

    % TEB
    TEB_integration(i) = mean(bits_recus ~= bits);


    %% detection sans integration

    % Echantillon pris au milieu de chaque bit
    indice_milieu = ceil(L/2);

    echantillons_milieu = r_blocs(indice_milieu, :);

    bits_recus_sans = echantillons_milieu > 0;

    TEB_sans_integration(i) = mean(bits_recus_sans ~= bits);


    %% TEB theorique avec detection optimale

    TEB_theorique(i) = Q(sqrt(2*EbN0));

end


%% Affichage des resultats

fprintf('\nEb/N0(dB)   Theorie      Integration    Sans integration\n');

for i = 1:length(EbN0_dB)

    fprintf('%3d         %.6f     %.6f       %.6f\n', ...
        EbN0_dB(i), ...
        TEB_theorique(i), ...
        TEB_integration(i), ...
        TEB_sans_integration(i));

end


%% Trace
figure;

semilogy(EbN0_dB, TEB_theorique, '-o', 'LineWidth', 1.5);
hold on;

semilogy(EbN0_dB, TEB_integration, '-x', 'LineWidth', 1.5);

semilogy(EbN0_dB, TEB_sans_integration, '-s', 'LineWidth', 1.5);

grid on;

xlabel('E_b/N_0 (dB)');
ylabel('TEB');

title('TEB en fonction de E_b/N_0');

legend('Theorie', ...
       'Avec integration', ...
       'Sans integration', ...
       'Location', 'southwest');