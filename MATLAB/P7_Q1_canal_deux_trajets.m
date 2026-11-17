%% Partie 7 - Question 1
% Canal a deux trajets

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

Nbits = 2e5;
EbN0_dB = 5;
fprintf('L = %d\n', L);
fprintf('alpha = %.2f\n', alpha);
fprintf('beta = %.2f\n', beta);
fprintf('Retard echo = %d symbole(s)\n', tau_symboles);

%% Source

bits = randi([0 1], 1, Nbits);

%% Modulation QPSK Gray
symboles = qpsk_mod(bits);

%% Surechantillonnage

x = zeros(1, length(symboles)*L);
x(1:L:end) = symboles;

%% Filtre RRC emission
h = rcosdesign(alpha, span, L, 'sqrt');
signal_emis = conv(x, h);

%% canal a deux trajets

tau_ech = tau_symboles * L;
hc = zeros(1, tau_ech + 1);

hc(1) = 1;
hc(end) = beta;
signal_canal = conv(signal_emis, hc);

%% Ajout du bruit

Eb = 0.5;
EbN0 = 10^(EbN0_dB/10);
N0 = Eb / EbN0;
sigma = sqrt(N0/2);

bruit = sigma * ...
    (randn(size(signal_canal)) + ...
     1j*randn(size(signal_canal)));

signal_recu = signal_canal + bruit;

%% Filtre adaptee

signal_filtre = conv(signal_recu, h);

%% Retard total principal

retard = span * L;

%% Echantillonnage

indices = retard + 1 : L : ...
    retard + 1 + (length(symboles)-1)*L;

indices = indices(indices <= length(signal_filtre));

Nsym = length(indices);

symboles_recus = signal_filtre(indices).';

%% Bits de reference

bits_reference = bits(1:2*Nsym);

%% Demodulation

bits_recus = qpsk_demod(symboles_recus);

%% TEB

TEB = mean(bits_recus ~= bits_reference);

fprintf('TEB avec canal a deux trajets = %.6f\n', TEB);

%% Constellation

figure;

Naff = min(10000, length(symboles_recus));

plot(real(symboles_recus(1:Naff)), ...
     imag(symboles_recus(1:Naff)), '.');

grid on;
axis equal;

xlabel('I');
ylabel('Q');

title(sprintf( ...
    'Constellation avec echo - beta=%.2f, retard=%dT', ...
    beta, tau_symboles));

xlim([-2 2]);
ylim([-2 2]);

%%Diagramme de l'oeil

signal_oeil = real(signal_filtre);

signal_oeil = signal_oeil(retard+1:end);

N_oeil = 2*L;

nb_traces = floor((length(signal_oeil)-N_oeil)/L);

figure;
hold on;

for k = 1:min(nb_traces,40)

    debut = (k-1)*L + 1;
    fin = debut + N_oeil - 1;

    plot((0:N_oeil-1)/L, ...
         signal_oeil(debut:fin));

end

grid on;

xlabel('Temps / T');
ylabel('Amplitude');

title('Diagramme de l''oeil avec canal a deux trajets');

xlim([0 2]);