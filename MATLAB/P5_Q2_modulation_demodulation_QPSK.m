%% Partie 5 - Question 2
% Validation modulation / demodulation QPSK

clear;
clc;

%% Message test

bits = [0 0 0 1 1 1 1 0];

fprintf('Bits emis :\n');
disp(bits);

%% Modulation

symboles = qpsk_mod(bits);

fprintf('Symboles QPSK :\n');
disp(symboles.');

%% demodulation

bits_recus = qpsk_demod(symboles);

fprintf('Bits demodules :\n');
disp(bits_recus);

%% Verification

if isequal(bits, bits_recus)
    fprintf('Modulation / demodulation correcte.\n');
else
    fprintf('Erreur de demodulation.\n');
end