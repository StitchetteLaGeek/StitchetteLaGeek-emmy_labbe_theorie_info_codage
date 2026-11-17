%% Question 10 - Parametres pour la chaine surechantillonnee

clear;
clc;
close all;

%% Parametres personnels

P = parametres_perso('LABBE Emmy');

A = P.A;
L = P.L;

% Dans la suite les bits sont equiprobables
p1 = 0.5;
p0 = 0.5;

% Duree d'un bit
Tb = 1;

% Periode d'echantillonnage
Te = Tb / L;

fprintf('A = %.2f\n', A);
fprintf('L = %d echantillons/bit\n', L);
fprintf('Tb = %.2f\n', Tb);
fprintf('Te = %.4f\n', Te);

%% rapport Eb/N0 de test

EbN0_dB = 5;

% Passage en valeur lineaire
EbN0 = 10^(EbN0_dB/10);

% energie par bit
Eb = A^2 * Tb;

% Calcul de N0
N0 = Eb / EbN0;

% Variance du bruit par echantillon
sigma2_bruit = N0 * L / (2*Tb);

% Ecart-type correspondant
sigma_bruit = sqrt(sigma2_bruit);

fprintf('Eb/N0 = %.2f dB\n', EbN0_dB);
fprintf('Variance du bruit = %.4f\n', sigma2_bruit);
fprintf('Ecart-type du bruit = %.4f\n', sigma_bruit);

%% generation d'une sequence binaire equiprobable

Nbits = 20;

% Bits equiprobables
bits = source(Nbits, 0.5);

% Conversion en niveaux antipodaux
% 0 -> -A
% 1 -> +A
x_bits = A * (2*bits - 1);

%% Surechantillonnage

% Chaque bit est repete L fois
x = repelem(x_bits, L);

fprintf('Nombre de bits = %d\n', Nbits);
fprintf('Nombre total d''echantillons = %d\n', length(x));

%% Trace du signal emis

t = (0:length(x)-1) * Te;

figure;
stairs(t, x, 'LineWidth', 1.5);

grid on;
xlabel('Temps');
ylabel('Amplitude');
title('Signal binaire surechantillonne');

%% Ajout du bruit gaussien

bruit = sigma_bruit * randn(size(x));

% Signal recu
r = x + bruit;

%% trace du signal recu

figure;
plot(t, r);

grid on;
xlabel('Temps');
ylabel('Amplitude');
title('Signal recu apres ajout du bruit gaussien');

%% Integration  sur chaque bits

z = zeros(1, Nbits);

for k = 1:Nbits

    debut = (k-1)*L + 1;
    fin = k*L;

    % Integrateur normalise : moyenne des L echantillons
    z(k) = mean(r(debut:fin));

end

%% Decision

seuil = 0;

bits_recus = z > seuil;

%% Comparaison avec les bits emis

nb_erreurs = sum(bits_recus ~= bits);

TEB = nb_erreurs / Nbits;

fprintf('Nombre d''erreurs apres integration = %d\n', nb_erreurs);
fprintf('TEB = %.4f\n', TEB);

%% Valeurs en sortie de l'integrateur

figure;
stem(1:Nbits, z);

hold on;
yline(0, '--');

grid on;
xlabel('Numero du bit');
ylabel('Sortie de l''integrateur');
title('Sortie de l''integrateur avant decision');
