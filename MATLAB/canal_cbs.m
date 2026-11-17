function bits_recus = canal_cbs(bits_emis, pe)

% Generation dun vecteur d'erreurs
erreurs = rand(size(bits_emis)) < pe;

% Inversion des bits lorsqu une erreur est presente
bits_recus = xor(bits_emis, erreurs);

end