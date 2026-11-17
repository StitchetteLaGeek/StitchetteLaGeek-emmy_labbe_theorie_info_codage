%% Question 13 - Bruit uniforme apres integration

clear;
clc;
close all;

%% Parametres

P = parametres_perso('LABBE Emmy');

a = P.a_unif;
L = P.L;

% Nombre de bits simules
Nbits = 1e5;

%% Generation du bruit uniforme

% L echantillons de bruit par bit
bruit = -a + 2*a*rand(L, Nbits);

%% Integration

% L'integrateur normalise fait la moyenne des L echantillons
bruit_integre = mean(bruit, 1);

%% Comparaison des distributions

figure;

histogram(bruit(:), 100, 'Normalization', 'pdf');
hold on;

histogram(bruit_integre, 100, 'Normalization', 'pdf');

grid on;

xlabel('Amplitude du bruit');
ylabel('Densite de probabilite');
title('Bruit uniforme avant et apres integration');

legend('Bruit par echantillon', ...
       'Bruit apres integration', ...
       'Location', 'best');

%% Variances

variance_avant = var(bruit(:));

variance_apres = var(bruit_integre);

% Variance theorique dune loi uniforme sur [-a,a]
variance_uniforme_theorique = a^2 / 3;


% Variance apres moyenne de L variables independantes
variance_apres_theorique = variance_uniforme_theorique / L;

fprintf('Variance avant integration = %.4f\n', variance_avant);
fprintf('Variance theorique avant = %.4f\n', ...
    variance_uniforme_theorique);

fprintf('Variance apres integration = %.4f\n', variance_apres);
fprintf('Variance theorique apres = %.4f\n', ...
    variance_apres_theorique);