%% Partie 2 - Codage de source
clear;
clc;
close all;

%% Parametres personnels
% Recuperation de mes parametres personnels
P = parametres_perso('LABBE Emmy');
Tb = 1; % duree d'un bit
% Graine fixee pour obtenir les memes tirages aleatoires
rng(P.graine);

%% Question 1 - Generation dune source binaire

N = 1e5;% Nombre de bits generes

% Generation de N bits avec une probabilite p1 davoir un 1
bits = source(N, P.p1);

% La moyenne permet d'obtenir la proportion de 1
frequence_1 = mean(bits);


% Affichage des resultats pour comparer la valeur theorique et la valeur mesuree
fprintf('Probabilite theorique p1 = %.4f\n', P.p1);
fprintf('Frequence empirique des 1 = %.4f\n', frequence_1);

%% Question 2 - Entropie de la source

p0 = 1 - P.p1;% Probabilite d'avoir un 0

% calcul de lentropie de la source binaire
H = -P.p1*log2(P.p1) - p0*log2(p0);

fprintf('Entropie de la source = %.4f bits/symbole\n', H);

%% Debit d'information
debit_symbole = 1; % symbole/s
debit_information = H * debit_symbole;% calcul du debit d'information

fprintf('Debit information = %.4f bit/s\n', debit_information);

%% Tracé de H(p)

% Valeurs de p entre 0 et 1
% On evite exactement 0 et 1 car log2(0) nest pas defini
p = 0.001:0.001:0.999;

% Calcul de lentropie pour chaque valeur de p
% Les .* permettent de faire le calcul valeur par valeur
H_p = -p.*log2(p) - (1-p).*log2(1-p);

% Trace de la courbe
figure;
plot(p, H_p, 'LineWidth', 1.5);
grid on;
xlabel('p = P(1)');
ylabel('H(p) (bits/symbole)');
title('Entropie d''une source binaire');
