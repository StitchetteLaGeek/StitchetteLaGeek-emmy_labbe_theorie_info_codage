function symboles = qpsk_mod(bits)

% on verifie que le nombre de bits est paire
if mod(length(bits),2) ~= 0
    error('Le nombre de bits doit etre pair');
end

% Regroupement par paires
paires = reshape(bits, 2, []).';

% Mapping Gray
% b1 agit sur Q, b2 agit sur I

I = 1 - 2*paires(:,2);
Q = 1 - 2*paires(:,1);

% symboles QPSK normalises
symboles = (I + 1j*Q) / sqrt(2);

end