%% Partie 4 - Questions 4 et 5
% Simulation du registre de codage Hamming (7,4)

clear;
clc;

%% Message test
m = [1 0 1 1];

% Le sujet indique que les bits entrent poids fort dabord :
% m3, m2, m1, m0
entree = fliplr(m);

%% etat initial du registre

s0 = 0;
s1 = 0;
s2 = 0;

fprintf('Etat initial : s0=%d s1=%d s2=%d\n', s0, s1, s2);

%% Passage des 4 bits du message

for k = 1:4

    bit = entree(k);

    % Retroaction
    f = xor(bit, s2);

    % Nouvel etat du registre
    nouveau_s2 = s1;
    nouveau_s1 = xor(s0, f);
    nouveau_s0 = f;

    s0 = nouveau_s0;
    s1 = nouveau_s1;
    s2 = nouveau_s2;

    fprintf('Apres bit %d : s0=%d s1=%d s2=%d\n', ...
        bit, s0, s1, s2);

end

%% Redondance
r = [s0 s1 s2];

fprintf('\nBits de redondance : ');
disp(r);

%% Mot code final

c_registre = [m r];
fprintf('Mot code par registre : ');
disp(c_registre);

%% Comparaison avec le codeur matriciel

c_matrice = hamming_encode(m);

fprintf('Mot code matriciel : ');
disp(c_matrice);
if isequal(c_registre, c_matrice)
    fprintf('Les deux codeurs donnent le meme resultat.\n');
else
    fprintf('Attention : resultats differents.\n');
end

%% Verification sur les 16 messages possibles

fprintf('\nVerification des 16 messages :\n');

tous_ok = true;

for valeur = 0:15

    % message sur 4 bits
    m = dec2bin(valeur,4) - '0';

    % Entree du registre : m3, m2, m1, m0
    entree = fliplr(m);

    % Etat initial
    s0 = 0;
    s1 = 0;
    s2 = 0;

    % Passage des 4 bits dans le registre
    for k = 1:4

        bit = entree(k);

        f = xor(bit, s2);

        nouveau_s2 = s1;
        nouveau_s1 = xor(s0, f);
        nouveau_s0 = f;

        s0 = nouveau_s0;
        s1 = nouveau_s1;
        s2 = nouveau_s2;

    end

    % mot code obtenu avec le registre
    r = [s0 s1 s2];
    c_registre = [m r];
    % mot code obtenu avec la matrice
    c_matrice = hamming_encode(m);

    % Verification
    ok = isequal(c_registre, c_matrice);

    fprintf('%s -> ', num2str(m));

    if ok
        fprintf('OK\n');
    else
        fprintf('ERREUR\n');
        tous_ok = false;
    end

end

%% Resultat final
if tous_ok
    fprintf('\nLes 16 messages donnent le meme resultat avec les deux codeurs.\n');
else
    fprintf('\nIl existe une difference entre les deux methodes.\n');
end