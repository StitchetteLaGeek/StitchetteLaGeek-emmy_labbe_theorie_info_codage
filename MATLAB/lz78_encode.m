function couples = lz78_encode(message)

% Initialisation du dictionnaire
dico = {''};

% Liste des couples (indice, symbole)
couples = {};

i = 1;

while i <= length(message)

    phrase = '';
    indice = 0;

    % Recherche de la plus longue phrase deja connue
    while i <= length(message)

        test = [phrase message(i)];

        pos = find(strcmp(dico, test), 1);

        if isempty(pos)
            break;
        end

        phrase = test;
        indice = pos - 1;
        i = i + 1;
    end

    % Si on arrive a la fin du message
    if i > length(message)
        break;
    end

    % Nouveau symbole ajoute
    symbole = message(i);

    % enregistrement du couple
    couples{end+1,1} = indice;
    couples{end,2} = symbole;

    % Ajout de la nouvelle phrase au dictionnaire
    dico{end+1} = [phrase symbole];

    i = i + 1;

end

end