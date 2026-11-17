function bits = source(N, p1)
% Generation de N valeurs aleatoires entre 0 et 1
% Si la valeur est inferieure a p1, le bit vaut 1
    bits = rand(1,N) < p1; 
end