%% Partie 4 - Question 10
% Comparaison theorique sans codage / avec Hamming

clear;
clc;
close all;

%% Parametres

R = 4/7;
EbN0_dB = 0:9;
EbN0 = 10.^(EbN0_dB/10);
Q = @(x) 0.5 * erfc(x/sqrt(2));

%% TEB sans codage

TEB_sans = Q(sqrt(2*EbN0));

%% Probabilite d'erreur sur un bit code

p = Q(sqrt(2*R*EbN0));

%%Approximation du TEB apres correction Hamming

TEB_hamming = zeros(size(p));

for i = 1:length(p)
    Pb = 0;

    for j = 2:7

        Pb = Pb + ...
            (j/7) * nchoosek(7,j) * ...
            p(i)^j * (1-p(i))^(7-j);
    end

    TEB_hamming(i) = Pb;

end

%% Affichage

fprintf('\nEb/N0(dB)   Sans codage    Hamming corrige\n');

for i = 1:length(EbN0_dB)

    fprintf('%3d         %.6e     %.6e\n', ...
        EbN0_dB(i), ...
        TEB_sans(i), ...
        TEB_hamming(i));

end

%% courbes

figure;

semilogy(EbN0_dB, TEB_sans, '-o', 'LineWidth', 1.5);
hold on;

semilogy(EbN0_dB, TEB_hamming, '-s', 'LineWidth', 1.5);

grid on;
xlabel('E_b/N_0 (dB)');
ylabel('TEB');

title('Comparaison sans codage / Hamming (7,4)');

legend('Sans codage', ...
       'Avec Hamming', ...
       'Location', 'southwest');