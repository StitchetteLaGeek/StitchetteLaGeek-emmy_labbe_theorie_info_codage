%% Partie 4 - Question 8
% Approximation de la probabilite d'erreur apres correction

clear;
clc;

%% Probabilite derreur sur un bit code
p = 0.05;

%%Calcul de Pb

Pb = 0;

for j = 2:7

    terme = (j/7) * nchoosek(7,j) * p^j * (1-p)^(7-j);

    Pb = Pb + terme;

end

%% Affichage

fprintf('Probabilite d''erreur bit avant correction = %.6f\n', p);
fprintf('Probabilite d''erreur bit apres correction ≈ %.6f\n', Pb);