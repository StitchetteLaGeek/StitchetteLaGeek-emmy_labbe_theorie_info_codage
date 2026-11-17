%% Partie 6 - Question 6
% Sensibilite au decalage d'echantillonnage de T/4

clear;
clc;
close all;

%% Parametres

P = parametres_perso('LABBE Emmy');
rng(P.graine);
L = P.L;
span = 10;
Nbits = 2e5;
EbN0_dB = 5;

% Valeurs de roll-off a comparer
alphas = [0.22 1];

%% source binaire

bits = randi([0 1], 1, Nbits);

%% Modulation QPSK Gray

symboles = qpsk_mod(bits);

%% Surechantillonnage

x = zeros(1, length(symboles)*L);

x(1:L:end) = symboles;

%% Parametres du bruit
% QPSK normalisee :
% Es = 1 donc Eb = Es/2 = 0.5

Eb = 0.5;
EbN0 = 10^(EbN0_dB/10);
N0 = Eb / EbN0;

% Ecart-type du bruit sur chaque voie I et Q
sigma = sqrt(N0/2);

%% Decalage de T/4
decalage = round(L/4);

fprintf('L = %d\n', L);
fprintf('Decalage T/4 = %d echantillons\n\n', decalage);

%% Boucle sur les deux valeurs de alpha

for a = 1:length(alphas)

    alpha = alphas(a);
    %% Filtre RRC

    h = rcosdesign(alpha, span, L, 'sqrt');

    %% mise en forme a lemission
    signal_emis = conv(x, h);

    %% ajou du bruit complexe

    bruit = sigma * ...
        (randn(size(signal_emis)) + ...
         1j*randn(size(signal_emis)));

    signal_recu = signal_emis + bruit;

    %% Filtre adapte

    signal_filtre = conv(signal_recu, h);

    %% Retard total des deux filtres

    retard = span * L;

    %% =========================================================
    %  ECHANTILLONNAGE OPTIMAL
    % ==========================================================

    indices_opt = retard + 1 : L : ...
        retard + 1 + (length(symboles)-1)*L;
    % important:
    % qpsk_demod attend ici un vecteur colonne
    symboles_opt = signal_filtre(indices_opt).';

    %%demodulation

    bits_opt = qpsk_demod(symboles_opt);

    %% TEB optimal

    TEB_opt = mean(bits_opt ~= bits);

    %% =========================================================
    %  ECHANTILLONNAGE DECALE DE T/4
    % ==========================================================

    indices_decales = indices_opt + decalage;

    % Suppression des indices qui depassent le signal
    indices_decales = indices_decales( ...
        indices_decales <= length(signal_filtre));

    % nombre de symboles conserves
    Nsym = length(indices_decales);

    % Passage en vecteur colonne
    symboles_decales = signal_filtre(indices_decales).';

    %% Bits de reference correspondants

    bits_reference = bits(1:2*Nsym);

    %% Demodulation
    bits_decales = qpsk_demod(symboles_decales);

    %% TEB avec decalage

    TEB_decale = mean(bits_decales ~= bits_reference);

    %% Affichage des resultats

    fprintf('alpha = %.2f\n', alpha);
    fprintf('TEB echantillonnage optimal = %.6f\n', TEB_opt);
    fprintf('TEB avec decalage T/4 = %.6f\n\n', TEB_decale);

    %% =========================================================
    %  CONSTELLATION OPTIMALE
    % ==========================================================

    figure;

    % On limite le nombre de points pour rendre le graphe lisible
    Naff = min(10000, length(symboles_opt));

    plot(real(symboles_opt(1:Naff)), ...
         imag(symboles_opt(1:Naff)), '.');

    grid on;
    axis equal;

    xlabel('I');
    ylabel('Q');

    title(sprintf( ...
        'Constellation optimale - alpha = %.2f', alpha));

    xlim([-1.5 1.5]);
    ylim([-1.5 1.5]);

    %% =========================================================
    %  CONSTELLATION AVEC DECALAGE T/4
    % ==========================================================

    figure;

    Naff = min(10000, length(symboles_decales));

    plot(real(symboles_decales(1:Naff)), ...
         imag(symboles_decales(1:Naff)), '.');

    grid on;
    axis equal;

    xlabel('I');
    ylabel('Q');

    title(sprintf( ...
        'Constellation avec decalage T/4 - alpha = %.2f', ...
        alpha));

    xlim([-1.5 1.5]);
    ylim([-1.5 1.5]);

end