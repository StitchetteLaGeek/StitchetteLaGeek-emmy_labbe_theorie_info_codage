%% Question 9 - Comparaison des trois canaux

clear;
clc;

%% Parametres

P = parametres_perso('LABBE Emmy');

A = P.A;
a = P.a_unif;
sigma = P.sigma;

p1 = P.p1;
p0 = 1 - p1;

pe_cbs = P.pe_cbs;

%% Canal binaire symetrique

Pe_CBS = pe_cbs;

%% canal uniforme

% Pour nos parametres p0 > p1, le seuil optimal est s = a - A
s_uniforme = a - A;

borne0_min = -A - a;
borne1_min = A - a;

F0 = (s_uniforme - borne0_min) / (2*a);
F0 = min(max(F0,0),1);

erreur0 = 1 - F0;

F1 = (s_uniforme - borne1_min) / (2*a);
F1 = min(max(F1,0),1);

erreur1 = F1;
% Probabilite d'erreur totale
Pe_uniforme = p0*erreur0 + p1*erreur1;

%% Canal gaussien

s_gaussien = (sigma^2/(2*A))*log(p0/p1);

Q = @(x) 0.5*erfc(x/sqrt(2));% Fonction Q
% Probabilite d'erreur totale
Pe_gaussien = ...
    p0*Q((s_gaussien + A)/sigma) + ...
    p1*Q((A - s_gaussien)/sigma);

%% Affichage

fprintf('--- Comparaison des canaux ---\n');

fprintf('CBS : Pe = %.4f\n', Pe_CBS);
fprintf('Uniforme : Pe min = %.4f, seuil optimal = %.4f\n', ...
    Pe_uniforme, s_uniforme);
fprintf('Gaussien : Pe min = %.4f, seuil optimal = %.4f\n', ...
    Pe_gaussien, s_gaussien);