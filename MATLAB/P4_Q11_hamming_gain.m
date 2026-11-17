%% Partie 4 - Question 11
% Point de croisement et gain de codage

clear;
clc;
close all;

%% Parametres

R = 4/7;

% axe fin en Eb/N0
EbN0_dB = 0:0.01:12;
EbN0 = 10.^(EbN0_dB/10);

% Fonction Q
Q = @(x) 0.5 * erfc(x/sqrt(2));

%% TEB sans codage

TEB_sans = Q(sqrt(2*EbN0));

%% TEB avec Hamming

p = Q(sqrt(2*R*EbN0));

TEB_hamming = zeros(size(p));

for i = 1:length(p)

    Pb = 0;

    for j = 2:7

        Pb = Pb + ...
            (j/7) * nchoosek(7,j) * ...
            p(i)^j * (1-p(i))^(7-j);

    end

    TEB_hamming(i) = Pb;

end

%% point ou Hamming devient avantageux

difference = TEB_hamming - TEB_sans;

indice = find(difference < 0, 1, 'first');

EbN0_croisement = EbN0_dB(indice);

fprintf('Le codage devient avantageux vers Eb/N0 = %.2f dB\n', ...
    EbN0_croisement);

%% Gain pour un TEB = 1e-4

TEB_cible = 1e-4;

% Recherche du Eb/N0 necessaire sans codage
[~, indice_sans] = min(abs(TEB_sans - TEB_cible));
EbN0_sans = EbN0_dB(indice_sans);

% Recherche du Eb/N0 necessaire avec Hamming
[~, indice_hamming] = min(abs(TEB_hamming - TEB_cible));
EbN0_hamming = EbN0_dB(indice_hamming);

% Gain de codage
gain_codage = EbN0_sans - EbN0_hamming;

fprintf('Pour TEB = 1e-4 :\n');
fprintf('Eb/N0 sans codage = %.2f dB\n', EbN0_sans);
fprintf('Eb/N0 avec Hamming = %.2f dB\n', EbN0_hamming);
fprintf('Gain de codage = %.2f dB\n', gain_codage);

%% Limites de Shannon donnes dans le sujet

limite_R = 0.24;
limite_absolue = -1.59;
fprintf('Limite de Shannon pour R = 4/7 : %.2f dB\n', limite_R);
fprintf('Limite absolue : %.2f dB\n', limite_absolue);

%% Trace

figure;
semilogy(EbN0_dB, TEB_sans, 'LineWidth', 1.5);
hold on;

semilogy(EbN0_dB, TEB_hamming, 'LineWidth', 1.5);

yline(TEB_cible, '--');

xline(EbN0_sans, '--');
xline(EbN0_hamming, '--');

grid on;

xlabel('E_b/N_0 (dB)');
ylabel('TEB');

title('Gain de codage du Hamming (7,4)');

legend('Sans codage', ...
       'Avec Hamming', ...
       'TEB = 10^{-4}', ...
       'Location', 'southwest');