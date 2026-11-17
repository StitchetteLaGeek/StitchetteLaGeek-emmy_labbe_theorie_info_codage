%% Question 5 - Huffman applique au texte

clear;
clc;

%% Lecture du texte

texte = fileread('texte_fr.txt');

N = length(texte); 

%% Alphabet et frequences

% Caracteres differents du texte
alphabet = unique(texte);

% calcul des frequences
frequences = zeros(1,length(alphabet));

for i = 1:length(alphabet)
    frequences(i) = sum(texte == alphabet(i)) / N;
end

%% Construction du code de Huffman

% Creation dun code pour chaque caractere
codes = huffman_perso(frequences);

%% longueur des mots de code

longueurs = zeros(1,length(codes));

for i = 1:length(codes)
    longueurs(i) = length(codes{i});
end

% Longueur moyenne du code de Huffman
L_moyenne = sum(frequences .* longueurs);

%% Entropie du texte

H = entropie_empirique(texte);

%% Efficacite du code

efficacite = H / L_moyenne;

%% Affichage des resultats

fprintf('Entropie H = %.4f bits/caractere\n', H);
fprintf('Longueur moyenne Huffman = %.4f bits/caractere\n', L_moyenne);
fprintf('Efficacite = %.2f %%\n', efficacite*100);

%% Verification de la borne de Shannon

fprintf('H = %.4f\n', H);
fprintf('L moyenne = %.4f\n', L_moyenne);
fprintf('H + 1 = %.4f\n', H+1);

if H <= L_moyenne && L_moyenne < H+1
    fprintf('La relation H <= L < H+1 est verifiee.\n');
else
    fprintf('La relation H <= L < H+1 n''est pas verifiee.\n');
end


%% Codage du texte

texte_code = '';

% pour chaque caractere du texte, on ajoute son mot de Huffman
for i = 1:N

    % recherche du caractere dans lalphabet
    indice = find(alphabet == texte(i), 1);

    % ajout du code correspondant
    texte_code = [texte_code codes{indice}];

end

fprintf('Nombre de bits apres Huffman = %d bits\n', length(texte_code));


%% decodage du texte

texte_decode = '';
mot = '';

for i = 1:length(texte_code)

    % On construit progressivement un mot binaire
    mot = [mot texte_code(i)];

    % On cherche si ce mot correspond a un code Huffman
    indice = find(strcmp(codes, mot), 1);

    if ~isempty(indice)

        % Le symbole correspondant est ajoute au texte decode
        texte_decode = [texte_decode alphabet(indice)];

        % On recommence avec un nouveau mot
        mot = '';

    end

end


%% Verification du decodage

if strcmp(texte, texte_decode)
    fprintf('Decodage correct : le texte est restitue sans erreur.\n');
else
    fprintf('Erreur lors du decodage.\n');
end


%% Taux de compression

% taille originale avec 8 bits par caractere
taille_originale = N * 8;

% taille apres codage Huffman
taille_huffman = length(texte_code);

% Rapport entre la taille compressee et la taille initiale
rapport_compression = taille_huffman / taille_originale;

% Pourcentage de reduction de taille
gain_compression = 1 - rapport_compression;

fprintf('Taille originale = %d bits\n', taille_originale);
fprintf('Taille Huffman = %d bits\n', taille_huffman);
fprintf('Taille finale = %.2f %% de la taille originale\n', ...
    rapport_compression*100);
fprintf('Reduction de taille = %.2f %%\n', ...
    gain_compression*100);