%% Question 3 - Capacite du canal binaire symetrique

clear;
clc;
close all;

%% Parametres

P = parametres_perso('LABBE Emmy');

pe = P.pe_cbs;

%% Capacite pour notre canal

H_pe = -pe*log2(pe) - (1-pe)*log2(1-pe);

C = 1 - H_pe;

fprintf('Probabilite d''erreur pe = %.4f\n', pe);
fprintf('Entropie H(pe) = %.4f bits\n', H_pe);
fprintf('Capacite du canal C = %.4f bit/bit transmis\n', C);


%% trace de C(pe)

pe_vect = 0.001:0.001:0.5;

H_vect = -pe_vect.*log2(pe_vect) ...
         -(1-pe_vect).*log2(1-pe_vect);

C_vect = 1 - H_vect;

figure;

plot(pe_vect, C_vect, 'LineWidth', 1.5);

grid on;

xlabel('Probabilite d''erreur p_e');
ylabel('Capacite C');
title('Capacite du canal binaire symetrique');

%% Comparaison avec le rendement du code de Hamming

R = 4/7;

fprintf('Rendement du code de Hamming R = %.4f\n', R);

if C > R
    fprintf('Transmission fiable theorquement possible car C > R.\n');
else
    fprintf('Transmission fiable non garantie car C <= R.\n');
end

%% Cas particulier pe = 0.5

pe_05 = 0.5;

H_05 = -pe_05*log2(pe_05) - (1-pe_05)*log2(1-pe_05);

C_05 = 1 - H_05;

fprintf('Pour pe = 0.5, la capacite vaut C = %.4f\n', C_05);