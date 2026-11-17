%% Question 4 - Code de Huffman

clear;
clc;

% Probabilites donnees dans l'enonce
proba = [0.4 0.2 0.2 0.1 0.1];

% Construction du code de Huffman
codes = huffman_perso(proba);

% Affichage des codes
for i = 1:length(proba)
    fprintf('Symbole %d : p = %.1f -> %s\n', ...
        i, proba(i), codes{i});
end


%% Verification du code de Huffman

% longueur de chaque mot de code
longueurs = zeros(1,length(codes));

for i = 1:length(codes)
    longueurs(i) = length(codes{i});
end

% lngueur moyenne
L_moyenne = sum(proba .* longueurs);

fprintf('Longueur moyenne = %.2f bits\n', L_moyenne);


%% Somme de Kraft

kraft = sum(2.^(-longueurs));

fprintf('Somme de Kraft = %.2f\n', kraft);


%% Verification du caractere prefixe

est_prefixe = true;

for i = 1:length(codes)
    for j = 1:length(codes)

        if i ~= j

            % On verifie si le code i est le debut du code j
            if length(codes{i}) <= length(codes{j})
                if strcmp(codes{i}, codes{j}(1:length(codes{i})))
                    est_prefixe = false;
                end
            end

        end
    end
end

if est_prefixe
    fprintf('Le code est prefixe.\n');
else
    fprintf('Le code n''est pas prefixe.\n');
end