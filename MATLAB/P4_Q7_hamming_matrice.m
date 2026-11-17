%% Partie 4 - Question 7
% Probabilite d'avoir un bloc correct

clear;
clc;

%% Probabilite derreur sur un bit
p = 0.05;

%% Sans codage

% Un bloc d'information contient 4 bits
% pour quil soit correct, aucun des 4 bits ne doit etre faux

P_bloc_sans_codage = (1-p)^4;

%% Avec codage Hamming (7,4)

% Le decodeur corrige:
% - aucune erreur
% -une seule erreur dans le mot de 7 bits

P_aucune_erreur = (1-p)^7;
P_une_erreur = 7 * p * (1-p)^6;
P_bloc_avec_codage = P_aucune_erreur + P_une_erreur;

%% Affichage

fprintf('Probabilite d''erreur bit p = %.4f\n', p);

fprintf('Bloc correct sans codage = %.6f\n', ...
    P_bloc_sans_codage);

fprintf('Bloc correct avec Hamming = %.6f\n', ...
    P_bloc_avec_codage);