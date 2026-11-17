%% Partie 7 - Question 3
% Transmission d'un texte avec Hamming
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
% On limite a 1000 caracteres
texte = texte(1:min(1000,length(texte)));

fprintf('Nombre de caracteres transmis = %d\n', length(texte));

%% texte -> octets

octets = unicode2native(texte,'UTF-8');

%% Octets -> bits

bits = reshape(dec2bin(octets,8).'-'0',1,[]);

%% completer pour avoir un multiple de 4

nb_bits_originaux = length(bits);
reste = mod(length(bits),4);
if reste ~= 0
    bits = [bits zeros(1,4-reste)];
end

%% Matrices Hamming
Pmat = [
    1 1 0;
    0 1 1;
    1 1 1;
    1 0 1
];

G = [eye(4) Pmat];
H = [Pmat' eye(3)];

%% Codage Hamming

messages = reshape(bits,4,[]).';
codes = mod(messages*G,2);

bits_codes = reshape(codes.',1,[]);

%%nombre pair pour QPSK

if mod(length(bits_codes),2) ~= 0
    bits_codes(end+1) = 0;
end

%% Modulation QPSK

symboles = qpsk_mod(bits_codes);

%% Surechantillonnage

x = zeros(1,length(symboles)*L);
x(1:L:end) = symboles;

%% Filtre RRC emission

h = rcosdesign(alpha,span,L,'sqrt');

signal_emis = conv(x,h);

%% canal a deux trajets

tau_ech = tau_symboles*L;

hc = zeros(1,tau_ech+1);

hc(1) = 1;
hc(end) = beta;

signal_canal = conv(signal_emis,hc);

%% Boucle Eb/N0

for n = 1:length(EbN0_dB_valeurs)
    EbN0_dB = EbN0_dB_valeurs(n);
    % energie par bit d'information
    Eb = 1;

    EbN0 = 10^(EbN0_dB/10);

    N0 = Eb/EbN0;

    % Rendement Hamming
    R = 4/7;

    % Energie d'un bit code
    Ec = R*Eb;

    % energie symbole QPSK = 2 bits codes
    Es = 2*Ec;

    % Adaptation de l'amplitude du signal
    signal_canal_scaled = sqrt(Es) * signal_canal;

    %% Bruit

    sigma = sqrt(N0/2);
    bruit = sigma * ...
        (randn(size(signal_canal_scaled)) + ...
         1j*randn(size(signal_canal_scaled)));

    signal_recu = signal_canal_scaled + bruit;

    %% Filtre adapte

    signal_filtre = conv(signal_recu,h);

    %% Echantillonnage

    retard = span*L;
    indices = retard+1:L: ...
        retard+1+(length(symboles)-1)*L;

    indices = indices(indices <= length(signal_filtre));
    symboles_recus = signal_filtre(indices).';

    %% Demodulation QPSK

    bits_codes_recus = qpsk_demod(symboles_recus);

    %% Suppression eventuel du bit de bourrage QPSK
    bits_codes_recus = ...
        bits_codes_recus(1:min(length(bits_codes_recus), ...
                               size(codes,1)*7));

    %% Regroupement en mots de 7 bits

    N7 = floor(length(bits_codes_recus)/7)*7;

    bits_codes_recus = bits_codes_recus(1:N7);

    mots_recus = reshape(bits_codes_recus,7,[]).';

    %% Decodage Hamming

    messages_decodes = zeros(size(mots_recus,1),4);

    for k = 1:size(mots_recus,1)

        r = mots_recus(k,:);
        syndrome = mod(r*H',2);
        r_corrige = r;

        for pos = 1:7
            if isequal(syndrome,H(:,pos)')
                r_corrige(pos) = 1-r_corrige(pos);
                break;
            end
        end

        messages_decodes(k,:) = r_corrige(1:4);

    end

    %% Retour en bits utiles

    bits_decodes = reshape(messages_decodes.',1,[]);

    bits_decodes = bits_decodes( ...
        1:min(nb_bits_originaux,length(bits_decodes)));

    bits_reference = bits(1:length(bits_decodes));

    %% TEB
    TEB = mean(bits_decodes ~= bits_reference);

    %% Bits -> octets
    Nbits_octets = floor(length(bits_decodes)/8)*8;
    bits_octets = bits_decodes(1:Nbits_octets);
    matrice_bits = reshape(bits_octets,8,[]).';
    octets_recus = uint8(bin2dec(char(matrice_bits+'0')));

    %% Octets -> texte

    texte_recu = native2unicode(octets_recus','UTF-8');

    %% Affichage

    fprintf('\n==============================\n');
    fprintf('Avec Hamming - Eb/N0 = %d dB\n',EbN0_dB);
    fprintf('TEB apres decodage = %.4f\n',TEB);

    fprintf('\nTexte recu :\n');
    fprintf('%s\n', ...
        texte_recu(1:min(500,length(texte_recu))));

end