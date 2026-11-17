function H = entropie_empirique(sequence)

% Symboles presents dans la sequence
alphabet = unique(sequence);

% Calcul des frequences
frequences = zeros(size(alphabet));

for i = 1:length(alphabet)
    frequences(i) = sum(sequence == alphabet(i)) / length(sequence);
end

% Calcul de lentropie empirique
H = -sum(frequences .* log2(frequences));

end