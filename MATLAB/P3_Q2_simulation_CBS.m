%% Question 2 - Taux d erreur binaire du canal CBS

clear;
clc;

%% Parametres

P = parametres_perso('LABBE Emmy');

pe = P.pe_cbs;

% nombre de bits simules
N = 1e5;

%% Generation de la source

bits_emis = source(N, P.p1);

%% Passage dans le canal binaire symetrique

bits_recus = canal_cbs(bits_emis, pe);

%% calcul du nombre derreurs

nb_erreurs = sum(bits_emis ~= bits_recus);

%% calcul  TEB

TEB = nb_erreurs / N;

fprintf('Probabilite theorique pe = %.4f\n', pe);
fprintf('Nombre d''erreurs = %d\n', nb_erreurs);
fprintf('TEB mesure = %.4f\n', TEB);

%% Intervalle de confiance a 95 %

ecart = 1.96 * sqrt(TEB * (1 - TEB) / N);

borne_inf = TEB - ecart;
borne_sup = TEB + ecart;

fprintf('Intervalle de confiance a 95 %% : [%.4f ; %.4f]\n', ...
    borne_inf, borne_sup);

% Verification que pe appartient a l'intervalle
if pe >= borne_inf && pe <= borne_sup
    fprintf('La valeur theorique pe appartient a l''intervalle.\n');
else
    fprintf('La valeur theorique pe n''appartient pas a l''intervalle.\n');
end