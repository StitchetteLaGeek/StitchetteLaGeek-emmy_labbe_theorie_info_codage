%% Partie 4 - Question 3
% Validation du codeur et du decodeur Hamming (7,4)

clear;
clc;

%% Message test
m = [1 0 1 1];

fprintf('Message original : ');
disp(m);

%% Codage

c = hamming_encode(m);

fprintf('Mot code : ');
disp(c);

%% test sans erreur

m_decode = hamming_decode(c);

fprintf('Message decode sans erreur : ');
disp(m_decode);

if isequal(m, m_decode)
    fprintf('Test sans erreur : OK\n');
else
    fprintf('Test sans erreur : ECHEC\n');
end

%% test avec une erreur dans chacune des 7 positions

fprintf('\nTests avec une erreur simple :\n');

for position = 1:7

    r = c;

    % Inversion dun bit
    r(position) = 1 - r(position);

    m_decode = hamming_decode(r);

    fprintf('Erreur position %d : ', position);

    if isequal(m, m_decode)
        fprintf('corrigee\n');
    else
        fprintf('ECHEC\n');
    end

end