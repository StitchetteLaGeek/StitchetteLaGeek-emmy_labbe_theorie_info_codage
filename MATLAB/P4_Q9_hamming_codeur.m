%% Partie 4 - Question 9
% Probabilite d'erreur sur un bit code

clear;
clc;
close all;

%% Rendement du code Hamming

R = 4/7;
fprintf('Rendement R = %.4f\n', R);

%% Valeurs de Eb/N0

EbN0_dB = 0:9;

EbN0 = 10.^(EbN0_dB/10);

%% FonctionQ

Q = @(x) 0.5 * erfc(x/sqrt(2));

%% Probabilite d'erreur sans codage

p_sans = Q(sqrt(2*EbN0));

%%Probabilite d'erreur sur un bit code

p_code = Q(sqrt(2*R*EbN0));

%% Affichage

fprintf('\nEb/N0(dB)   Sans codage    Bit code\n');

for i = 1:length(EbN0_dB)

    fprintf('%3d         %.6f      %.6f\n', ...
        EbN0_dB(i), ...
        p_sans(i), ...
        p_code(i));

end

%% Trace

figure;
semilogy(EbN0_dB, p_sans, '-o', 'LineWidth', 1.5);
hold on;

semilogy(EbN0_dB, p_code, '-s', 'LineWidth', 1.5);

grid on;

xlabel('E_b/N_0 (dB)');
ylabel('Probabilite d''erreur');

title('Probabilite d''erreur avant correction');

legend('Sans codage', ...
       'Bit code avant correction', ...
       'Location', 'southwest');