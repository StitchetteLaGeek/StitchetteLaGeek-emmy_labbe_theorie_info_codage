%% Partie 5 - Question 5
% Comparaison mapping Gray / mapping naturel

clear;
clc;
close all;

%% Parametres

Nbits = 2e5;

EbN0_dB = 0:9;

% nombre pair de bits
bits = randi([0 1], 1, Nbits);

% Regroupement par paires
paires = reshape(bits, 2, []).';

%% Symboles QPSK - mapping Gray

I_gray = 1 - 2*paires(:,2);
Q_gray = 1 - 2*paires(:,1);

s_gray = (I_gray + 1j*Q_gray)/sqrt(2);

%% Symboles QPSK - mapping naturel
% 00 -> k=1
% 01 -> k=3
% 10 -> k=5
% 11 -> k=7

indice = 2*paires(:,1) + paires(:,2);
k = 2*indice + 1;
s_nat = exp(1j*k*pi/4);

%% Energie par bit
Eb = 0.5;

TEB_gray = zeros(size(EbN0_dB));
TEB_nat = zeros(size(EbN0_dB));

%% Simulation

for n = 1:length(EbN0_dB)

    EbN0 = 10^(EbN0_dB(n)/10);

    N0 = Eb / EbN0;

    sigma = sqrt(N0/2);

    %% bruit

    bruit_gray = sigma * ...
        (randn(size(s_gray)) + 1j*randn(size(s_gray)));

    bruit_nat = sigma * ...
        (randn(size(s_nat)) + 1j*randn(size(s_nat)));

    r_gray = s_gray + bruit_gray;
    r_nat = s_nat + bruit_nat;

    %% Demodulation Gray

    b1_gray = imag(r_gray) < 0;
    b2_gray = real(r_gray) < 0;

    bits_gray = reshape([b1_gray b2_gray].', 1, []);

    TEB_gray(n) = mean(bits_gray ~= bits);

    %%Demodulation mapping naturel

    angles = angle(r_nat);

    % angles dans [0,2*pi[
    angles(angles < 0) = angles(angles < 0) + 2*pi;

    % Decision sur le symbole le plus proche
    indice_recu = mod(round((angles - pi/4)/(pi/2)),4);

    % Conversion indice -> bits naturels
    b1_nat = floor(indice_recu/2);
    b2_nat = mod(indice_recu,2);

    bits_nat = reshape([b1_nat b2_nat].', 1, []);

    TEB_nat(n) = mean(bits_nat ~= bits);

end

%% Affichage

fprintf('Eb/N0(dB)   Gray           Naturel\n');

for n = 1:length(EbN0_dB)

    fprintf('%3d         %.6e    %.6e\n', ...
        EbN0_dB(n), ...
        TEB_gray(n), ...
        TEB_nat(n));

end

%% Trace

figure;

semilogy(EbN0_dB, TEB_gray, '-o', 'LineWidth', 1.5);
hold on;

semilogy(EbN0_dB, TEB_nat, '-s', 'LineWidth', 1.5);

grid on;

xlabel('E_b/N_0 (dB)');
ylabel('TEB');

title('QPSK : mapping Gray / mapping naturel');

legend('Mapping Gray', ...
       'Mapping naturel', ...
       'Location', 'southwest');