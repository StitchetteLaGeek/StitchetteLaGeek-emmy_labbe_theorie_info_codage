%% Question 6 - Cout de transmission de la table Huffman

% Cout estime de la table :
% 8 bits pour identifier chaque caractere
% + la longueur de son code Huffman
cout_table = sum(8 + longueurs);

fprintf('Cout estime de la table Huffman = %d bits\n', cout_table);

% Nombre de bits economises par caractere par rapport au codage 8 bits
gain_par_caractere = 8 - L_moyenne;

% longueur minimale du texte pour compenser le cout de la table
N_limite = cout_table / gain_par_caractere;

fprintf('Longueur minimale pour compenser la table = %.0f caracteres\n', ...
    ceil(N_limite));

%% Cout negligeable de la table

% On considere ici que le cout devient negligeable
% lorsquil represente moins de 1 % des donnees codees
N_negligeable = cout_table / (0.01 * L_moyenne);

fprintf('Table inferieure a 1 %% pour environ %.0f caracteres\n', ...
    ceil(N_negligeable));