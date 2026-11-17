%% Question 11 - Performances de LZ78

clear;
clc;
close all;

%% ================================
% TEXTE COMPLET
% ================================

texte = fileread('le_temps_spiral.txt');

% Codage LZ78
couples = lz78_encode(texte);

% taille de l'alphabet du texte
alphabet = unique(texte);
taille_alphabet = length(alphabet);

% Cout total du codage LZ78
nb_bits_total = 0;

for i = 1:size(couples,1)

    % cout de l'indice
    nb_bits_indice = ceil(log2(max(i,1)));

    % cout du symbole ajoute
    nb_bits_symbole = ceil(log2(taille_alphabet));

    nb_bits_total = nb_bits_total + nb_bits_indice + nb_bits_symbole;

end

% Nombre de bits par caractere
bits_par_caractere = nb_bits_total / length(texte);

fprintf('Texte complet : %.4f bits/caractere\n', bits_par_caractere);


%% ================================
% 5000 PREMIERS CARACTERES
% ================================

N5000 = min(5000,length(texte));
texte_5000 = texte(1:N5000);

couples_5000 = lz78_encode(texte_5000);

alphabet_5000 = unique(texte_5000);
taille_alphabet_5000 = length(alphabet_5000);

nb_bits_total_5000 = 0;

for i = 1:size(couples_5000,1)

    nb_bits_indice = ceil(log2(max(i,1)));
    nb_bits_symbole = ceil(log2(taille_alphabet_5000));

    nb_bits_total_5000 = nb_bits_total_5000 + ...
                         nb_bits_indice + nb_bits_symbole;

end

bits_par_caractere_5000 = nb_bits_total_5000 / N5000;

fprintf('5000 premiers caracteres : %.4f bits/caractere\n', ...
    bits_par_caractere_5000);


%% ================================
% SOURCE BINAIRE
% ================================

P = parametres_perso('LABBE Emmy');

p1 = P.p1_ext;
p0 = 1 - p1;

% Entropie theorique de la source binaire
H = -p1*log2(p1) - p0*log2(p0);

fprintf('\nEntropie theorique = %.4f bits/bit\n', H);

%% Tailles testees

tailles = [1e3 1e4 1e5 1e6];

L_LZ78 = zeros(size(tailles));

for t = 1:length(tailles)

    N = tailles(t);

    % Generation de la source binaire
    bits = source(N,p1);

    % Conversion en chaine de caracteres
    message = char(bits + '0');

    % codage LZ78
    couples_bits = lz78_encode(message);

    % Alphabet binaire -> 2 symboles
    taille_alphabet_bits = 2;

    nb_bits = 0;

    for i = 1:size(couples_bits,1)

        nb_bits_indice = ceil(log2(max(i,1)));
        nb_bits_symbole = ceil(log2(taille_alphabet_bits));

        nb_bits = nb_bits + nb_bits_indice + nb_bits_symbole;

    end

    % Nombre de bits produit par bit source
    L_LZ78(t) = nb_bits / N;

end


%% Affichage

fprintf('\nTaille source      LZ78 bits/bit\n');

for i = 1:length(tailles)
    fprintf('%10d          %.4f\n', tailles(i), L_LZ78(i));
end


%% Graphique

figure;

semilogx(tailles, L_LZ78, '-o', 'LineWidth', 1.5);
hold on;

yline(H, '--', 'Entropie H');

grid on;

xlabel('Nombre de bits de la source');
ylabel('Bits produits par bit source');

title('Convergence de LZ78 vers l''entropie');

legend('LZ78', 'Entropie de la source', ...
       'Location', 'best');