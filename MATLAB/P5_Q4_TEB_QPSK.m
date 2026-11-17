%% Partie 5 - Question 4
% Comparaison TEB binaire / QPSK Gray

clear;
clc;
close all;

%% Parametres

EbN0_dB = 0:9;
EbN0 = 10.^(EbN0_dB/10);

% FonctionQ
Q = @(x) 0.5 * erfc(x/sqrt(2));

%% TEB theorique binaire antipodal

TEB_binaire = Q(sqrt(2*EbN0));

%% TEB theorique QPSK Gray
TEB_qpsk = Q(sqrt(2*EbN0));

%% Affichage

fprintf('Eb/N0(dB)   Binaire        QPSK Gray\n');

for i = 1:length(EbN0_dB)

    fprintf('%3d         %.6e    %.6e\n', ...
        EbN0_dB(i), ...
        TEB_binaire(i), ...
        TEB_qpsk(i));

end

%% Trace

figure;

semilogy(EbN0_dB, TEB_binaire, '-o', 'LineWidth', 1.5);
hold on;

semilogy(EbN0_dB, TEB_qpsk, '--s', 'LineWidth', 1.5);

grid on;

xlabel('E_b/N_0 (dB)');
ylabel('TEB');

title('Comparaison TEB binaire / QPSK Gray');

legend('Binaire antipodal', ...
       'QPSK Gray', ...
       'Location', 'southwest');