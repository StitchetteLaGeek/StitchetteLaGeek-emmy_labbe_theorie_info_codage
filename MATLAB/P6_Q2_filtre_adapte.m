%% Partie 6 - Question 2
% Filtre RRC

clear;
clc;
close all;

%% Parametres

P = parametres_perso('LABBE Emmy');

L = P.L;
alpha = P.alpha;

span = 10;

fprintf('L = %d\n', L);
fprintf('alpha = %.2f\n', alpha);
fprintf('span = %d symboles\n', span);

%% Filtre RRC

h_rrc = rcosdesign(alpha, span, L, 'sqrt');

%% Verification de l'energie

energie = sum(h_rrc.^2);

fprintf('Energie du filtre = %.6f\n', energie);

%%axe temporel en symboles

N = length(h_rrc);

t = (-(N-1)/2:(N-1)/2) / L;

%% Trace

figure;

plot(t, h_rrc, 'LineWidth', 1.5);
grid on;

xlabel('Temps / T');
ylabel('Amplitude');
title(sprintf('Filtre RRC - alpha = %.2f', alpha));

%% information

fprintf('Nombre de coefficients = %d\n', N);
fprintf('Valeur au centre h(0) = %.6f\n', ...
    h_rrc((N+1)/2));


%% Question 3 - Reponse globale h*h

% Convolution du filtre RRC avec lui-meme
h_global = conv(h_rrc, h_rrc);

% axe temporel pour h*h
Ng = length(h_global);
t_global = (-(Ng-1)/2:(Ng-1)/2) / L;

%% Traces

figure;

plot(t, h_rrc, 'LineWidth', 1.5);

grid on;
xlabel('Temps / T');
ylabel('Amplitude');
title('Reponse impulsionnelle du filtre RRC');

figure;

plot(t_global, h_global, 'LineWidth', 1.5);

grid on;
xlabel('Temps / T');
ylabel('Amplitude');
title('Reponse globale h * h');

%% Valeurs aux multiples de T

centre = (Ng + 1)/2;

fprintf('\nValeurs de h*h aux multiples de T :\n');

for k = -5:5

    indice = centre + k*L;

    if indice >= 1 && indice <= Ng

        fprintf('k = %2d : %.6f\n', ...
            k, h_global(indice));

    end

end