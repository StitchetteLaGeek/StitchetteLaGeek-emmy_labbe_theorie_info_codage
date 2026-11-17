%% Question 8 - Source avec memoire

clear;
clc;
close all;

%% lecture du texte

texte = fileread('texte_fr.txt');
N = length(texte);

fprintf('Nombre de caracteres = %d\n', N);


%% Entropie d ordre 0

H0 = entropie_empirique(texte);

fprintf('Entropie ordre 0 = %.4f bits/caractere\n', H0);


%% Code a longueur fixe

alphabet = unique(texte);
taille_alphabet = length(alphabet);

L_fixe = ceil(log2(taille_alphabet));

fprintf('Code fixe = %.4f bits/caractere\n', L_fixe);


%% Code de Huffman

frequences = zeros(1,length(alphabet));

for i = 1:length(alphabet)
    frequences(i) = sum(texte == alphabet(i)) / N;
end

codes = huffman_perso(frequences);

longueurs = zeros(1,length(codes));

for i = 1:length(codes)
    longueurs(i) = length(codes{i});
end

L_huffman = sum(frequences .* longueurs);

fprintf('Huffman = %.4f bits/caractere\n', L_huffman);


%% Entropie des paires de caracteres

% Creation des paires consecutives
paires = cell(N-1,1);

for i = 1:N-1
    paires{i} = texte(i:i+1);
end

% recherche des paires differentes
[paires_uniques, ~, indices] = unique(paires);

% Nombre d'apparitions de chaque paire
effectifs_paires = accumarray(indices,1);

% Probabilites des paires
proba_paires = effectifs_paires / sum(effectifs_paires);

% Entropie d'une paire
H_paires = -sum(proba_paires .* log2(proba_paires));

% Entropie ramenee a un caractere
H2 = H_paires / 2;

fprintf('H(X1X2)/2 = %.4f bits/caractere\n', H2);


%% Comparaison

fprintf('\n--- Comparaison ---\n');
fprintf('Code fixe        : %.4f bits/caractere\n', L_fixe);
fprintf('Entropie ordre 0 : %.4f bits/caractere\n', H0);
fprintf('Huffman          : %.4f bits/caractere\n', L_huffman);
fprintf('Entropie paires  : %.4f bits/caractere\n', H2);

%% Comparaison texte complet / 5000 premiers caracteres

% texte complet
texte_complet = texte;

% 5000 premiers caracteres
N5000 = min(5000, length(texte));
texte_5000 = texte(1:N5000);

%% Fonction de calcul pour le texte complet

alphabet_complet = unique(texte_complet);
N_complet = length(texte_complet);

% Code fixe
L_fixe_complet = ceil(log2(length(alphabet_complet)));

% Entropie ordre 0
H0_complet = entropie_empirique(texte_complet);

% Huffman
freq_complet = zeros(1,length(alphabet_complet));

for i = 1:length(alphabet_complet)
    freq_complet(i) = sum(texte_complet == alphabet_complet(i)) / N_complet;
end

codes_complet = huffman_perso(freq_complet);

longueurs_complet = zeros(1,length(codes_complet));

for i = 1:length(codes_complet)
    longueurs_complet(i) = length(codes_complet{i});
end

L_huffman_complet = sum(freq_complet .* longueurs_complet);

% Entropie des paires
paires = cell(N_complet-1,1);

for i = 1:N_complet-1
    paires{i} = texte_complet(i:i+1);
end

[~,~,indices] = unique(paires);

effectifs = accumarray(indices,1);
proba = effectifs / sum(effectifs);

H2_complet = -sum(proba .* log2(proba)) / 2;


%% Calcul sur les 5000 premiers caracteres

alphabet_5000 = unique(texte_5000);
N_5000 = length(texte_5000);

% code fixe
L_fixe_5000 = ceil(log2(length(alphabet_5000)));

% Entropie ordre 0
H0_5000 = entropie_empirique(texte_5000);

% Huffman
freq_5000 = zeros(1,length(alphabet_5000));

for i = 1:length(alphabet_5000)
    freq_5000(i) = sum(texte_5000 == alphabet_5000(i)) / N_5000;
end

codes_5000 = huffman_perso(freq_5000);

longueurs_5000 = zeros(1,length(codes_5000));

for i = 1:length(codes_5000)
    longueurs_5000(i) = length(codes_5000{i});
end

L_huffman_5000 = sum(freq_5000 .* longueurs_5000);

% Entropie des paires
paires_5000 = cell(N_5000-1,1);

for i = 1:N_5000-1
    paires_5000{i} = texte_5000(i:i+1);
end

[~,~,indices_5000] = unique(paires_5000);

effectifs_5000 = accumarray(indices_5000,1);
proba_5000 = effectifs_5000 / sum(effectifs_5000);

H2_5000 = -sum(proba_5000 .* log2(proba_5000)) / 2;


%% Graphique comparatif

valeurs = [
    L_fixe_complet    L_fixe_5000;
    H0_complet        H0_5000;
    L_huffman_complet L_huffman_5000;
    H2_complet        H2_5000
];

figure;
bar(valeurs);

grid on;

ylabel('Bits par caractere');
title('Comparaison texte complet / 5000 premiers caracteres');

xticks(1:4);
xticklabels({'Code fixe', ...
             'Entropie ordre 0', ...
             'Huffman', ...
             'Entropie des paires'});

xtickangle(15);

legend('Texte complet', '5000 premiers caracteres', ...
       'Location', 'best');