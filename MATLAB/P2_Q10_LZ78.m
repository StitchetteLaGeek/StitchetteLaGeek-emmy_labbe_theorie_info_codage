%% Question 10 - Codage LZ78

clear;
clc;

%% Message donne dans l'enonce

message = 'ABAABABAABAB';

fprintf('Message original : %s\n', message);

%% codage LZ78

couples = lz78_encode(message);

fprintf('\nCouples obtenus :\n');

for i = 1:size(couples,1)
    fprintf('(%d,%s) ', couples{i,1}, couples{i,2});
end

fprintf('\n');

%% decodage

message_decode = lz78_decode(couples);

fprintf('\nMessage decode : %s\n', message_decode);

%% Verification

if strcmp(message, message_decode)
    fprintf('Decodage correct : message restitue sans erreur.\n');
else
    fprintf('Erreur de decodage.\n');
end