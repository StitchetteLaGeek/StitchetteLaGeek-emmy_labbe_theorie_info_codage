%% Question 11 - Variance du bruit apres integration

clear;
clc;
close all;

%% Parametres

P = parametres_perso('LABBE Emmy');

A = P.A;
L = P.L;

Tb = 1;
Te = Tb / L;

%% Rapport Eb/N0 choisi pour la verification

EbN0_dB = 5;
% Passage en valeur lineaire
EbN0 = 10^(EbN0_dB/10);

%% Energie par bit

Eb = A^2 * Tb;

%% Calcul de N0

N0 = Eb / EbN0;

%% Variance du bruit par echantillon

sigma2 = N0 * L / (2*Tb);

%% Variance apres integration

% Lintegrateur fait la moyenne de L echantillons independants
sigma2_sortie = sigma2 / L;

% Valeur theorique equivalente
sigma2_theorique = N0 / (2*Tb);

%% Affichage

fprintf('Eb/N0 = %.2f dB\n', EbN0_dB);
fprintf('Variance du bruit par echantillon = %.4f\n', sigma2);
fprintf('Variance apres integration = %.4f\n', sigma2_sortie);
fprintf('N0/(2Tb) = %.4f\n', sigma2_theorique);


%% TEB theorique

% Fonction Q
Q = @(x) 0.5 * erfc(x/sqrt(2));

TEB_theorique = Q(sqrt(2*EbN0));

fprintf('TEB theorique = %.6f\n', TEB_theorique);