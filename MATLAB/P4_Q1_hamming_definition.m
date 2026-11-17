%% Partie 4 - Question 1
% Code de Hamming (7,4)

clear;
clc;

%% Matrice P obtenue avec les restes de x^3*m(x) modulo g(x)

P = [
    1 1 0;
    0 1 1;
    1 1 1;
    1 0 1
];

%% matrice generatrice systematique
I4 = eye(4);

G = [I4 P];

fprintf('Matrice generatrice G :\n');
disp(G);


%% Matrice de controle

I3 = eye(3);

H = [P' I3];

fprintf('Matrice de controle H :\n');
disp(H);


%% Verification G*H^T = 0 modulo 2

verification = mod(G * H', 2);

fprintf('Verification G*H^T modulo 2 :\n');
disp(verification);