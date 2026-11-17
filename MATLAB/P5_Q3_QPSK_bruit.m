%% Partie 5 - Question 3
% Constellations recues pour plusieurs valeurs de Eb/N0

clear;
clc;
close all;

%% Parametres
Nbits = 1e4;

% Nombre pair de bits
bits = randi([0 1], 1, Nbits);

%% Modulation QPSK

symboles = qpsk_mod(bits);
%energie par bit
Eb = 0.5;

%% Valeurs de Eb/N0

EbN0_dB = [0 5 10];

for k = 1:length(EbN0_dB)
    EbN0 = 10^(EbN0_dB(k)/10);
    % Calcul de N0
    N0 = Eb / EbN0;
    % Bruit complexe:
    % variance N0/2 sur chaque voie I et Q
    sigma = sqrt(N0/2);

    bruit = sigma * ...
        (randn(size(symboles)) + ...
         1j*randn(size(symboles)));

    % Signal recu
    recus = symboles + bruit;

    %% Trace de la constellation

    figure;

    plot(real(recus), imag(recus), '.');

    grid on;
    axis equal;

    xlabel('I');
    ylabel('Q');

    title(sprintf('Constellation recue - E_b/N_0 = %d dB', ...
        EbN0_dB(k)));

    xlim([-2 2]);
    ylim([-2 2]);

end