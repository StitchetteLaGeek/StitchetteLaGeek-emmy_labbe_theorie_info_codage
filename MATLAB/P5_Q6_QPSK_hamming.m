%% Partie 5 - Question 6
% QPSK + codage Hamming (7,4)

clear;
clc;
close all;

%% Parametres

R = 4/7;

% Multiple de 8:
% -> multiple de 4 pour Hamming
% -> nombre pair de mots codes pour QPSK
Nbits = 2e5;

EbN0_dB = 0:9;

Q = @(x) 0.5 * erfc(x/sqrt(2));

%%source binaire

bits = randi([0 1], 1, Nbits);

%% Matrices Hamming

P = [
    1 1 0;
    0 1 1;
    1 1 1;
    1 0 1
];

G = [eye(4) P];
H = [P' eye(3)];

%%codage Hamming

% Blocs de 4 bits
messages = reshape(bits, 4, []).';

% Codage des blocs
codes = mod(messages * G, 2);

% Mise sous forme d'un flux continu
bits_codes = reshape(codes.', 1, []);

fprintf('Nombre de bits utiles = %d\n', length(bits));
fprintf('Nombre de bits codes = %d\n', length(bits_codes));
fprintf('Nombre pair de bits codes : %d\n', ...
    mod(length(bits_codes),2) == 0);

%% Regroupement des bits codes par paires
paires = reshape(bits_codes, 2, []).';

% Mapping Gray QPSK
I = 1 - 2*paires(:,2);
Qvoie = 1 - 2*paires(:,1);
% QPSK normalisee Es = 1
symboles_norm = (I + 1j*Qvoie) / sqrt(2);

%% Simulation

TEB_simule = zeros(size(EbN0_dB));
TEB_theorique = zeros(size(EbN0_dB));

% Energie par bit d'information fixee
Eb = 1;

for n = 1:length(EbN0_dB)
    EbN0 = 10^(EbN0_dB(n)/10);
    % N0 defini par rapport au bit d'information
    N0 = Eb / EbN0;

    % energie dun bit code
    Ec = R * Eb;

    % un symbole QPSK transporte 2 bits codes
    Es = 2 * Ec;

    % Adaptation de l'amplitude QPSK
    symboles = sqrt(Es) * symboles_norm;

    %% Bruit complexe

    sigma = sqrt(N0/2);

    bruit = sigma * ...
        (randn(size(symboles)) + ...
         1j*randn(size(symboles)));

    recus = symboles + bruit;

    %% Demodulation QPSK Gray

    b1 = imag(recus) < 0;
    b2 = real(recus) < 0;

    bits_codes_recus = reshape([b1 b2].', 1, []);

    %% Regroupement des mots Hamming de 7 bits

    mots_recus = reshape(bits_codes_recus, 7, []).';
    nb_mots = size(mots_recus,1);
    messages_decodes = zeros(nb_mots,4);

    %% Decodage et correction Hamming

    for k = 1:nb_mots
        r = mots_recus(k,:);
        syndrome = mod(r * H', 2);
        r_corrige = r;

        % Recherche d'une erreur simple
        for pos = 1:7

            if isequal(syndrome, H(:,pos)')
                r_corrige(pos) = 1 - r_corrige(pos);
                break;
            end

        end

        % code systematique
        messages_decodes(k,:) = r_corrige(1:4);

    end

    %%retour en flux de bits

    bits_decodes = reshape(messages_decodes.', 1, []);

    %% TEB

    TEB_simule(n) = mean(bits_decodes ~= bits);

    %% Courbe theorique Hamming

    % Erreur sur un bit code QPSK
    p = Q(sqrt(2*R*EbN0));

    Pb = 0;

    for j = 2:7

        Pb = Pb + ...
            (j/7) * nchoosek(7,j) * ...
            p^j * (1-p)^(7-j);

    end

    TEB_theorique(n) = Pb;

end

%% Affichage

fprintf('\nEb/N0(dB)   Simulation      Theorie\n');

for n = 1:length(EbN0_dB)

    fprintf('%3d         %.6e     %.6e\n', ...
        EbN0_dB(n), ...
        TEB_simule(n), ...
        TEB_theorique(n));

end

%% Trace

figure;

semilogy(EbN0_dB, TEB_simule, '-o', ...
    'LineWidth', 1.5);

hold on;

semilogy(EbN0_dB, TEB_theorique, '-s', ...
    'LineWidth', 1.5);

grid on;

xlabel('E_b/N_0 (dB)');
ylabel('TEB');

title('QPSK avec codage Hamming (7,4)');

legend('Simulation QPSK + Hamming', ...
       'Theorie Hamming', ...
       'Location', 'southwest');