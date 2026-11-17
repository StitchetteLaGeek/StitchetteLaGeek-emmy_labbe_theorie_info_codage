function message = lz78_decode(couples)

% Initialisation du dictionnaire
dico = {''};

% Message decode
message = '';

for i = 1:size(couples,1)

    indice = couples{i,1};
    symbole = couples{i,2};

    % Reconstruction de la phrase
    phrase = [dico{indice+1} symbole];

    % Ajout au message decode
    message = [message phrase];

    % ajout de la nouvelle phrase au dictionnaire
    dico{end+1} = phrase;

end

end