%% Partie 6 - Question 4
% Comparaison spectrale filtre porte / filtre RRC

clear;
clc;
close all;

%% Parametres

P = parametres_perso('LABBE Emmy');
L = P.L;
alpha = P.alpha;
T = 1;
span = 10;
Nbits = 2e4;

fprintf('L = %d\n', L);
fprintf('alpha = %.2f\n', alpha);

%% Source binaire

bits = randi([0 1], 1, Nbits);

% Conversion en niveaux antipodaux
symboles = 2*bits - 1;

%% Surechantillonnage
x = zeros(1, Nbits*L);
x(1:L:end) = symboles;

%% Filtre porte

h_porte = ones(1,L) / sqrt(L);
signal_porte = conv(x, h_porte, 'same');

%% Filtre RRC
h_rrc = rcosdesign(alpha, span, L, 'sqrt');

signal_rrc = conv(x, h_rrc, 'same');

%% Frequence d'echantillonnage
Fe = L/T;

%% estimation des DSP avec Welch

nfft = 4096;

[PSD_porte, f_porte] = pwelch( ...
    signal_porte, ...
    hamming(1024), ...
    512, ...
    nfft, ...
    Fe, ...
    'centered');

[PSD_rrc, f_rrc] = pwelch( ...
    signal_rrc, ...
    hamming(1024), ...
    512, ...
    nfft, ...
    Fe, ...
    'centered');

%% Normalisation

PSD_porte = PSD_porte / max(PSD_porte);
PSD_rrc = PSD_rrc / max(PSD_rrc);

%% Passage en dB

PSD_porte_dB = 10*log10(PSD_porte + eps);
PSD_rrc_dB = 10*log10(PSD_rrc + eps);

%% Bande theorique RRC

B_theorique = (1 + alpha) / (2*T);

fprintf('Bande theorique RRC = %.4f\n', B_theorique);

%% Trace

figure;

plot(f_porte, PSD_porte_dB, ...
    'LineWidth', 1.5);

hold on;

plot(f_rrc, PSD_rrc_dB, ...
    'LineWidth', 1.5);

% Limites de la bande theorique RRC
xline(B_theorique, '--', ...
    'B RRC');

xline(-B_theorique, '--');

grid on;

xlabel('Frequence normalisee');
ylabel('DSP normalisee (dB)');

title('DSP : filtre porte / filtre RRC');

legend('Porte', ...
       'RRC', ...
       'Bande theorique RRC', ...
       'Location', 'best');

xlim([-2 2]);
ylim([-80 5]);