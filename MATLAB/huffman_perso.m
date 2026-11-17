function codes = huffman_perso(proba)

% Construction d'un code de Huffman a partir des probabilites
n = length(proba);

% Initialisation des groupes et des codes
groupes = cell(1,n);
codes = cell(1,n);

for i = 1:n
    groupes{i} = i;
    codes{i} = '';
end

% Copie des probabilites
p = proba;

% fusion jusqu'a obtenir un seul groupe
while length(p) > 1

    % Tri des probabilites dans l'ordre croissant
    [p, ordre] = sort(p);

    % On remet les groupes dans le meme ordre
    groupes = groupes(ordre);

    % Deux groupes les moins probables
    g1 = groupes{1};
    g2 = groupes{2};

    % ajout de 0 au premier groupe
    for k = g1
        codes{k} = ['0' codes{k}];
    end

    % ajout de 1 au deuxieme groupe
    for k = g2
        codes{k} = ['1' codes{k}];
    end

    % Fusion des deux groupes
    nouveau_groupe = [g1 g2];
    nouvelle_proba = p(1) + p(2);

    % Suppression des deux groupes fusionnes
    p(1:2) = [];
    groupes(1:2) = [];

    % Ajout du nouveau groupe
    p(end+1) = nouvelle_proba;
    groupes{end+1} = nouveau_groupe;

end

end