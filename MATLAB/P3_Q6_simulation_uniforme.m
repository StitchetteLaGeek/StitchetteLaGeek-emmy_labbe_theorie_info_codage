%% Question 6 - Simulation du canal a bruit uniforme

clear;
clc;
close all;

%% Parametres

P = parametres_perso('LABBE Emmy');

A = P.A;
a = P.a_unif;

p1 = P.p1;
p0 = 1 - p1;

N = 1e5;

%% Generation des bits

bits = source(N, p1);

% Conversion des bits en niveaux antipodaux
% 0 -> -A
% 1 -> +A
x = A * (2*bits - 1);

%% Ajout du bruit uniforme

bruit = -a + 2*a*rand(1,N);

r = x + bruit;

%% Seuils testes

seuils = linspace(-1.5, 1.5, 31);

TEB_simule = zeros(size(seuils));
Pe_theorique = zeros(size(seuils));

%% Simulation pour chaque seuil

for i = 1:length(seuils)

    s = seuils(i);

    % Decision
    bits_recus = r > s;

    % TEB simule
    TEB_simule(i) = mean(bits_recus ~= bits);

    %% Calcul theorique

    borne0_min = -A - a;
    borne1_min = A - a;

    % P(erreur | 0)
    F0 = (s - borne0_min) / (2*a);
    F0 = min(max(F0,0),1);
    erreur0 = 1 - F0;

    % P(erreur | 1)
    F1 = (s - borne1_min) / (2*a);
    F1 = min(max(F1,0),1);
    erreur1 = F1;

    % Probabilite totale
    Pe_theorique(i) = p0*erreur0 + p1*erreur1;

end

%% Minimum simulee

[TEB_min, indice] = min(TEB_simule);
s_opt_simule = seuils(indice);

fprintf('Seuil optimal simule = %.2f\n', s_opt_simule);
fprintf('TEB minimal simule = %.4f\n', TEB_min);

%% trace

figure;

plot(seuils, Pe_theorique, '-o', 'LineWidth', 1.5);
hold on;

plot(seuils, TEB_simule, '-x', 'LineWidth', 1.5);

grid on;

xlabel('Seuil s');
ylabel('Probabilite d''erreur / TEB');

title('Comparaison theorie / simulation - bruit uniforme');

legend('Theorie', 'Simulation', 'Location', 'best');