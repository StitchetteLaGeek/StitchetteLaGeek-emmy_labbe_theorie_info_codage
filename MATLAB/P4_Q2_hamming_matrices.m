%% Partie 4 - Question 2
% Proprietes du code de Hamming (7,4)

clear;
clc;

%% Matrice P

P = [
    1 1 0;
    0 1 1;
    1 1 1;
    1 0 1
];

%% matrice de controle H

H = [P' eye(3)];

fprintf('Matrice H :\n');
disp(H);

%% Verification des colonnes
fprintf('Colonnes de H :\n');

for i = 1:size(H,2)
    fprintf('Colonne %d : ', i);
    disp(H(:,i)');
end

%% Verification qu'elles sont toutes non nulles

colonnes_non_nulles = all(any(H ~= 0,1));
fprintf('Toutes les colonnes sont non nulles : %d\n', ...
    colonnes_non_nulles);

%% Verification qu'elles sont toutes differentes

nb_colonnes_uniques = size(unique(H','rows'),1);

fprintf('Nombre de colonnes differentes : %d\n', ...
    nb_colonnes_uniques);

%% distance minimale

dmin = 3;

fprintf('Distance minimale du code = %d\n', dmin);

%% Capacite du code

nb_erreurs_detectables = dmin - 1;

nb_erreurs_corrigeables = floor((dmin - 1)/2);

fprintf('Nombre maximal d''erreurs detectables = %d\n', ...
    nb_erreurs_detectables);

fprintf('Nombre maximal d''erreurs corrigeables = %d\n', ...
    nb_erreurs_corrigeables);