%% Question 5 - Probabilite d'erreur en fonction du seuil

clear;
clc;
close all;

%% Parametres

P = parametres_perso('LABBE Emmy');

A = P.A;
a = P.a_unif;

p1 = P.p1;
p0 = 1 - p1;

%% Valeurs du seuil

s = linspace(-A-a, A+a, 1000);

%% Bornes des deux lois uniformes

borne0_min = -A - a;
borne0_max = -A + a;

borne1_min = A - a;
borne1_max = A + a;

%% calcul de la probabilite d'erreur

Pe = zeros(size(s));

for i = 1:length(s)

    seuil = s(i);

    % Erreur lorsque 0 est emis :
    % on decide 1 si r > seuil
    F0 = (seuil - borne0_min) / (2*a);
    F0 = min(max(F0,0),1);

    erreur0 = 1 - F0;

    % Erreur lorsque 1 est emis :
    % on decide 0 si r <= seuil
    F1 = (seuil - borne1_min) / (2*a);
    F1 = min(max(F1,0),1);

    erreur1 = F1;

    % Probabilite totale d'erreur
    Pe(i) = p0*erreur0 + p1*erreur1;

end

%% Recherche du minimum

[Pe_min, indice_min] = min(Pe);

s_opt = s(indice_min);

fprintf('Seuil optimal numerique = %.3f\n', s_opt);
fprintf('Probabilite minimale d''erreur = %.4f\n', Pe_min);

%% Trace

figure;

plot(s, Pe, 'LineWidth', 1.5);

grid on;

xlabel('Seuil s');
ylabel('Probabilite d''erreur P_e');

title('Probabilite d''erreur du canal a bruit uniforme');

hold on;

plot(s_opt, Pe_min, 'o', 'MarkerSize', 8);

legend('P_e(s)', 'Minimum', 'Location', 'best');