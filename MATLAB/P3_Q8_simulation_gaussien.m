%% Question 8 - Simulation du canal gaussien

clear;
clc;
close all;

%% Parametres

P = parametres_perso('LABBE Emmy');

A = P.A;
sigma = P.sigma;

p1 = P.p1;
p0 = 1 - p1;

N = 1e5;

%% Generation de la source

bits = source(N, p1);

% conversion en niveaux antipodaux
% 0 -> -A
% 1 -> +A
x = A * (2*bits - 1);

%% ajout du bruit gaussien

bruit = sigma * randn(1,N);

r = x + bruit;

%% Seuil optimal theorique

s_opt = (sigma^2 / (2*A)) * log(p0/p1);

%% Valeurs de seuil testees

seuils = linspace(-1, 1, 81);

TEB_simule = zeros(size(seuils));
Pe_theorique = zeros(size(seuils));

% Fonction Q
Q = @(x) 0.5 * erfc(x / sqrt(2));

%% calcul pour chaque  seuil

for i = 1:length(seuils)

    s = seuils(i);

    % Decision
    bits_recus = r > s;

    % TEB simuler
    TEB_simule(i) = mean(bits_recus ~= bits);

    % Probabilite theorique
    Pe_theorique(i) = ...
        p0 * Q((s + A) / sigma) + ...
        p1 * Q((A - s) / sigma);

end

%% Minimum simuler

[TEB_min, indice_min] = min(TEB_simule);
s_opt_simule = seuils(indice_min);

%% TEB pour s = 0

[~, indice_zero] = min(abs(seuils));

TEB_zero = TEB_simule(indice_zero);

%% Gain apporte par le seuil optimal

gain_absolu = TEB_zero - TEB_min;

gain_relatif = gain_absolu / TEB_zero * 100;

%% Affichage

fprintf('Seuil optimal theorique = %.4f\n', s_opt);
fprintf('Seuil optimal simule = %.4f\n', s_opt_simule);

fprintf('TEB avec seuil optimal = %.4f\n', TEB_min);
fprintf('TEB avec seuil s = 0 = %.4f\n', TEB_zero);

fprintf('Gain absolu = %.4f\n', gain_absolu);
fprintf('Gain relatif = %.2f %%\n', gain_relatif);

%% Trace

figure;

plot(seuils, Pe_theorique, '-o', 'LineWidth', 1.5);
hold on;

plot(seuils, TEB_simule, '-x', 'LineWidth', 1.5);

xline(s_opt, '--');

grid on;

xlabel('Seuil s');
ylabel('Probabilite d''erreur / TEB');

title('Canal gaussien : theorie et simulation');

legend('Theorie', 'Simulation', 'Seuil optimal', ...
       'Location', 'best');