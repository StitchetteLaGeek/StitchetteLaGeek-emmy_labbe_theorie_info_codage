function m_corrige = hamming_decode(r)

% Matrice utilisee pour construire le code de Hamming (7,4)
P = [
    1 1 0;
    0 1 1;
    1 1 1;
    1 0 1
];

% Matrice de controle H
H = [P' eye(3)];

% Calcul du syndrome pour detecter une erreur
syndrome = mod(r * H', 2);

% Recherche de la position de l'erreur
position_erreur = 0;

for i = 1:7

    if isequal(syndrome, H(:,i)')
        position_erreur = i;
        break;
    end

end

% Correction si une erreur simple est detectee
r_corrige = r;

if position_erreur ~= 0
    r_corrige(position_erreur) = 1 - r_corrige(position_erreur);
end

% Code systematique : les 4 premiers bits sont le message
m_corrige = r_corrige(1:4);

end