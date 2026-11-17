function bits = qpsk_demod(symboles)

% decision sur le signe de Q
b1 = imag(symboles) < 0;

% decision sur le signe de I
b2 = real(symboles) < 0;

% Reconstruction des paires
paires = [b1 b2];

% Retour sous forme dune suite de bits
bits = reshape(paires.', 1, []);

end