%% Parametres partie 3

P = parametres_perso('LABBE Emmy');

A = P.A;
L = P.L;

Tb = 1;
Te = Tb/L;

% Dans la suite de la partie 3 :
% les bits sont equiprobables
p1 = 0.5;

% Exemple de rapport Eb/N0
EbN0_dB = 5;
EbN0 = 10^(EbN0_dB/10);

% Energie par bit
Eb = A^2 * Tb;

% Calcul de N0
N0 = Eb / EbN0;

% variance du bruit par echantillon
sigma2_bruit = N0 * L / (2*Tb);

% Ecart-type du bruit
sigma_bruit = sqrt(sigma2_bruit);