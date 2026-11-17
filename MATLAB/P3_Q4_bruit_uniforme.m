%% Question 4 - Canal a bruit uniforme

clear;
clc;
close all;

%% Parametres

P = parametres_perso('LABBE Emmy');

A = P.A;
a = P.a_unif;

fprintf('A = %.2f\n', A);
fprintf('a = %.2f\n', a);

%% Axe des valeurs recues

r = linspace(-A-a-0.5, A+a+0.5, 2000);

%% densite conditionnelle si le bit emis vaut 0

% Le bit 0 est represente par -A
f0 = zeros(size(r));

indices0 = (r >= -A-a) & (r <= -A+a);

f0(indices0) = 1/(2*a);

%% densite conditionnelle si le bit emis vaut 1

% Le bit 1 est represente par +A
f1 = zeros(size(r));

indices1 = (r >= A-a) & (r <= A+a);

f1(indices1) = 1/(2*a);

%% Trace

figure;

plot(r, f0, 'LineWidth', 1.5);
hold on;

plot(r, f1, 'LineWidth', 1.5);

grid on;

xlabel('Valeur recue r');
ylabel('Densite de probabilite');

title('Densites conditionnelles du canal a bruit uniforme');

legend('f(r|0)', 'f(r|1)', 'Location', 'best');

%% Zone de recouvremment

borne_gauche = A - a;
borne_droite = a - A;

fprintf('Zone de recouvrement : [%.2f ; %.2f]\n', ...
    borne_gauche, borne_droite);

%% Seuil optimal

p1 = P.p1;
p0 = 1 - p1;

fprintf('p0 = %.2f\n', p0);
fprintf('p1 = %.2f\n', p1);

if p1 < p0
    fprintf('Dans la zone de recouvrement, on choisit le bit 0.\n');
    fprintf('Un seuil optimal peut etre choisi en s = %.2f\n', borne_droite);

elseif p1 > p0
    fprintf('Dans la zone de recouvrement, on choisit le bit 1.\n');
    fprintf('Un seuil optimal peut etre choisi en s = %.2f\n', borne_gauche);

else
    fprintf('Les bits sont equiprobables.\n');
    fprintf('Tout seuil dans [%.2f ; %.2f] est optimal.\n', ...
        borne_gauche, borne_droite);
end