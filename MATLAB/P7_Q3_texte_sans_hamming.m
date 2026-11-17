%% Partie 7 - Question 3
% Transmission d'un texte sans Hamming
% Canal a deux trajets + QPSK + RRC

clear;
clc;
close all;

%% Parametres

P = parametres_perso('LABBE Emmy');
rng(P.graine);

L = P.L;
alpha = P.alpha;
beta = P.beta;
tau_symboles = P.retard_trajet;

span = 10;

EbN0_dB_valeurs = [3 6];

%% Lecture du texte
texte = fileread('le_temps_spiral.txt');
% On limite la taille pour commencer
texte = texte(1:min(1000,length(texte)));
fprintf('Nombre de caracteres transmis = %d\n', length(texte));

%% Texte -> octets

octets = unicode2native(texte, 'UTF-8');

%% Octets -> bits

bits = reshape(dec2bin(octets,8).'-'0',1,[]);

% Nombre pair pour QPSK
if mod(length(bits),2) ~= 0
    bits(end+1) = 0;
end

%% Modulation QPSK

symboles = qpsk_mod(bits);

%% Surechantillonnage
x = zeros(1,length(symboles)*L);
x(1:L:end) = symboles;

%% Filtre RRC emission

h = rcosdesign(alpha,span,L,'sqrt');

signal_emis = conv(x,h);

%% canal a deux trajets

tau_ech = tau_symboles * L;

hc = zeros(1,tau_ech+1);

hc(1) = 1;
hc(end) = beta;

signal_canal = conv(signal_emis,hc);

%% Boucle Eb/N0

for n = 1:length(EbN0_dB_valeurs)
    EbN0_dB = EbN0_dB_valeurs(n);
    Eb = 0.5;
    EbN0 = 10^(EbN0_dB/10);
    N0 = Eb/EbN0;
    sigma = sqrt(N0/2);

    %% Bruit

    bruit = sigma * ...
        (randn(size(signal_canal)) + ...
         1j*randn(size(signal_canal)));

    signal_recu = signal_canal + bruit;

    %% Filtre adaptee

    signal_filtre = conv(signal_recu,h);

    %% Echantillonnage

    retard = span*L;

    indices = retard+1:L: ...
        retard+1+(length(symboles)-1)*L;

    indices = indices(indices <= length(signal_filtre));

    symboles_recus = signal_filtre(indices).';

    %% Demodulation

    bits_recus = qpsk_demod(symboles_recus);

    %% ajustement longueur
    Nbits = min(length(bits_recus),length(bits));
    bits_recus = bits_recus(1:Nbits);
    bits_ref = bits(1:Nbits);

    %% TEB

    TEB = mean(bits_recus ~= bits_ref);

    %% Bits -> octets

    Nbits_octets = floor(length(bits_recus)/8)*8;
    bits_octets = bits_recus(1:Nbits_octets);
    matrice_bits = reshape(bits_octets,8,[]).';
    octets_recus = uint8(bin2dec(char(matrice_bits+'0')));

    %% Octets -> texte

    texte_recu = native2unicode(octets_recus','UTF-8');

    %% Affichage

    fprintf('\n==============================\n');
    fprintf('Eb/N0 = %d dB\n',EbN0_dB);
    fprintf('TEB = %.4f\n',TEB);

    fprintf('\nTexte recu :\n');
    fprintf('%s\n',texte_recu(1:min(500,length(texte_recu))));

end