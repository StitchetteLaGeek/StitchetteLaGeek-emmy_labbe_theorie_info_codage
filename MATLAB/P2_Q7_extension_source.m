%% Question 7 - Extension de la source

clear;
clc;
close all;

%% Parametres

P = parametres_perso('LABBE Emmy');
rng(P.graine);

% Probabilite d'avoir un 1 pour la source tres desequilibree
p1 = P.p1_ext;
p0 = 1 - p1;

fprintf('p1_ext = %.2f\n', p1);


%% Entropie de la source binaire

H = -p1*log2(p1) - p0*log2(p0);

fprintf('Entropie de la source = %.4f bits/bit\n', H);


%% Huffman sur des blocs de k bits

k_valeurs = 1:10;

% Tableau pour stocker la longueur moyenne par bit
L_par_bit = zeros(size(k_valeurs));

for k = k_valeurs

    % Nombre de blocs differents possibles
    nb_blocs = 2^k;

    % Probabilite de chaque bloc
    proba_blocs = zeros(1, nb_blocs);

    for i = 0:nb_blocs-1

        % Ecriture du bloc sous forme binaire
        bloc = dec2bin(i, k);

        % Nombre de bits a 1 dans le bloc
        w = sum(bloc == '1');

        % Probabilite du bloc
        proba_blocs(i+1) = p1^w * p0^(k-w);

    end

    % Construction du code de Huffman
    codes = huffman_perso(proba_blocs);

    % Longueur de chaque mot de code
    longueurs = zeros(1, nb_blocs);

    for i = 1:nb_blocs
        longueurs(i) = length(codes{i});
    end

    % Longueur moyenne pour un bloc de k bits
    L_bloc = sum(proba_blocs .* longueurs);

    % Longueur moyenne ramenee a un bit de source
    L_par_bit(k) = L_bloc / k;

end


%% Borne de Shannon

% H + 1/k
borne = H + 1./k_valeurs;


%% Affichage des resultats

fprintf('\n k    Lk/k\n');

for k = k_valeurs
    fprintf('%2d   %.4f\n', k, L_par_bit(k));
end


%% Trace

figure;

plot(k_valeurs, L_par_bit, '-o', 'LineWidth', 1.5);
hold on;

yline(H, '--', 'Entropie H');

plot(k_valeurs, borne, '-s', 'LineWidth', 1.5);

grid on;

xlabel('Taille des blocs k');
ylabel('Nombre moyen de bits par bit source');

title('Codage de Huffman des extensions de la source');

legend('L_k/k', 'H', 'H + 1/k', ...
    'Location', 'best');

%% Verification sur 10^5 bits

Nbits = 1e5;

% Generation d'une source de 10^5 bits
bits_source = source(Nbits, p1);

% Tableau pour stocker les resultats simules
L_simule = zeros(size(k_valeurs));

for k = k_valeurs

    % Nombre de bits utilisables, multiple de k
    Nutil = floor(Nbits/k) * k;
    bits_utiles = bits_source(1:Nutil);

    % Nombre de blocs du message
    nb_blocs_message = Nutil / k;

    % Calcul des probabilites des 2^k blocs
    nb_blocs = 2^k;
    proba_blocs = zeros(1, nb_blocs);

    for i = 0:nb_blocs-1

        bloc = dec2bin(i, k);
        w = sum(bloc == '1');

        proba_blocs(i+1) = p1^w * p0^(k-w);

    end

    % Construction du code de Huffman
    codes = huffman_perso(proba_blocs);

    % Nombre total de bits apres codage
    nb_bits_codes = 0;

    for b = 1:nb_blocs_message

        debut = (b-1)*k + 1;
        fin = b*k;

        bloc = bits_utiles(debut:fin);

        % Conversion du bloc binaire en indice
        indice = bin2dec(char(bloc + '0')) + 1;

        nb_bits_codes = nb_bits_codes + length(codes{indice});

    end

    % Longueur moyenne mesuree par bit source
    L_simule(k) = nb_bits_codes / Nutil;

end


%% Comparaison theorie / simulation

fprintf('\n k    Theorie    Simulation\n');

for k = k_valeurs
    fprintf('%2d   %.4f      %.4f\n', ...
        k, L_par_bit(k), L_simule(k));
end


%% Trace de la comparaison

figure;

plot(k_valeurs, L_par_bit, '-o', 'LineWidth', 1.5);
hold on;

plot(k_valeurs, L_simule, '-x', 'LineWidth', 1.5);

yline(H, '--', 'Entropie H');

grid on;

xlabel('Taille des blocs k');
ylabel('Nombre moyen de bits par bit source');
title('Verification du codage de Huffman sur 10^5 bits');

legend('Valeur theorique', 'Valeur simulee', 'Entropie H', ...
    'Location', 'best');