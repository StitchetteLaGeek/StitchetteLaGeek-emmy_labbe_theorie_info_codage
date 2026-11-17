%% Question 7 - Canal gaussien

clear;
clc;
close all;

%% Parametres

P = parametres_perso('LABBE Emmy');

A = P.A;
sigma = P.sigma;

p1 = P.p1;
p0 = 1 - p1;

%% Seuil optimal theorique

s_opt = (sigma^2 / (2*A)) * log(p0/p1);

fprintf('A = %.2f\n', A);
fprintf('sigma = %.2f\n', sigma);
fprintf('p0 = %.2f\n', p0);
fprintf('p1 = %.2f\n', p1);
fprintf('Seuil optimal theorique s* = %.4f\n', s_opt);

%% Probabilite d'erreur theorique

% Fonction Q
Q = @(x) 0.5 * erfc(x / sqrt(2));

% Valeurs du seuil
s = linspace(-1.5, 1.5, 1000);

% Calcul de Pe(s)
Pe = p0 .* Q((s + A) ./ sigma) ...
   + p1 .* Q((A - s) ./ sigma);

% recherche du minimum
[Pe_min, indice] = min(Pe);

s_min = s(indice);

fprintf('Seuil donnant le minimum = %.4f\n', s_min);
fprintf('Probabilite minimale d''erreur = %.4f\n', Pe_min);

%% Trace

figure;

plot(s, Pe, 'LineWidth', 1.5);
hold on;

plot(s_min, Pe_min, 'o', 'MarkerSize', 8);

grid on;

xlabel('Seuil s');
ylabel('Probabilite d''erreur P_e');

title('Probabilite d''erreur du canal gaussien');

legend('P_e(s)', 'Minimum', 'Location', 'best');