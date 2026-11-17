%% Question 3 - Entropie d'un texte

clear;
clc;
close all;

% Lecture du fichier texte
texte = fileread('texte_fr.txt');

% Nombre total de caracteres
N = length(texte);

fprintf('Nombre de caracteres = %d\n', N);

%% Alphabet du texte

% recherche des caracteres differents presents dans le texte
alphabet = unique(texte);

% taille de l alphabet
taille_alphabet = length(alphabet);

fprintf('Taille de l''alphabet = %d caracteres\n', taille_alphabet);


%% Frequences des caracteres

% Comptage du nombre d apparitions de chaque caractere
effectifs = zeros(size(alphabet));

for i = 1:length(alphabet)
    effectifs(i) = sum(texte == alphabet(i));
end

% calcul des frequences
frequences = effectifs / N;

%% Entropie empirique du texte

H_texte = entropie_empirique(texte);


%% Code a longueur fixe

% Nombre de bits necessaires pour coder tous les symboles de lalphabet
nb_bits_fixe = ceil(log2(taille_alphabet));

% taille totale du texte avec un code a longueur fixe
taille_fixe = N * nb_bits_fixe;

% taille du texte si chaque caractere est code sur 8 bits
taille_8bits = N * 8;

% Redondance par rapport a un codage sur 8 bits
redondance = 1 - nb_bits_fixe / 8;

fprintf('Code fixe = %d bits/caractere\n', nb_bits_fixe);
fprintf('Taille avec code fixe = %d bits\n', taille_fixe);
fprintf('Taille avec codage 8 bits = %d bits\n', taille_8bits);
fprintf('Redondance par rapport a 8 bits = %.2f %%\n', redondance*100);


%% Caracteres les plus frequents

% Tri des frequences dans l'ordre decroissant
[frequences_triees, indices] = sort(frequences, 'descend');

% Recuperation des caracteres dans le meme ordre
alphabet_trie = alphabet(indices);

% Nombre de caracteres affiches
nb_affiches = 15;

% Affichage des 15 caracteres les plus frequents
figure;
bar(frequences_triees(1:nb_affiches));

grid on;
xlabel('Caracteres');
ylabel('Frequence');
title('Caracteres les plus frequents du texte');

% Affichage des caracteres sur laxe horizontal
xticks(1:nb_affiches);
xticklabels(cellstr(alphabet_trie(1:nb_affiches)'));
