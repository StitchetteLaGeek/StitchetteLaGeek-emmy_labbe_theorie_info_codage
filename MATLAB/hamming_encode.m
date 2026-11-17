function c = hamming_encode(m)

% Matrice de parite du code de Hamming (7,4)
P = [
    1 1 0;
    0 1 1;
    1 1 1;
    1 0 1
];
% Matrice generatrice G = [I4 P]
G = [eye(4) P];

% Calcul du mot code modulo 2
c = mod(m * G, 2);

end