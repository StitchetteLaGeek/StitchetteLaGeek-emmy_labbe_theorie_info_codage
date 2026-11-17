%% Question 9 - Analyse des bits en sortie du codeur de Huffman

clear;
clc;

%% Lecture du texte

texte = fileread('le_temps_spiral.txt');
N = length(texte);

%% Alphabet et frequences

alphabet = unique(texte);

frequences = zeros(1,length(alphabet));

for i = 1:length(alphabet)
    frequences(i) = sum(texte == alphabet(i)) / N;
end

%% Construction du code de Huffman

codes = huffman_perso(frequences);

%% Codage du texte

texte_code = '';

for i = 1:N

    indice = find(alphabet == texte(i), 1);

    texte_code = [texte_code codes{indice}];

end

%% proportion de 1

nb_1 = sum(texte_code == '1');

proportion_1 = nb_1 / length(texte_code);

fprintf('Proportion de 1 = %.4f\n', proportion_1);


%% Entropie des bits

p1 = proportion_1;
p0 = 1 - p1;

H_bits = -p0*log2(p0) - p1*log2(p1);

fprintf('Entropie des bits = %.4f bits/bit\n', H_bits);


%% entropie des paires de bits

Nbits = length(texte_code);

paires_bits = cell(Nbits-1,1);

for i = 1:Nbits-1
    paires_bits{i} = texte_code(i:i+1);
end

[~,~,indices] = unique(paires_bits);

effectifs = accumarray(indices,1);

proba_paires = effectifs / sum(effectifs);

H_paires_bits = -sum(proba_paires .* log2(proba_paires));

% Entropie ramenee a un bit
H2_bits = H_paires_bits / 2;

fprintf('Entropie des paires de bits = %.4f bits/bit\n', H2_bits);