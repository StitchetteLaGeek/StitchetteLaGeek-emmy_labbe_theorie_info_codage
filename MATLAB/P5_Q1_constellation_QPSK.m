%% Partie 5 - Question 1
% Mapping Gray QPSK

clear;
clc;
close all;

%% Bits a tester
bits = [
    0 0;
    0 1;
    1 1;
    1 0
];

%% Mapping Gray

symboles = zeros(4,1);

for k = 1:4

    b1 = bits(k,1);
    b2 = bits(k,2);

    % Voie I
    I = 1 - 2*b2;

    % Voie Q
    Q = 1 - 2*b1;

    % Symbole QPSK normalise
    symboles(k) = (I + 1j*Q)/sqrt(2);

end

%% Affichage

fprintf('Mapping Gray QPSK :\n');

for k = 1:4

    fprintf('%d%d -> %.3f %+.3fj\n', ...
        bits(k,1), bits(k,2), ...
        real(symboles(k)), imag(symboles(k)));

end

%% energie

Es = mean(abs(symboles).^2);
Eb = Es / 2;
fprintf('\nEnergie symbole Es = %.4f\n', Es);
fprintf('Energie bit Eb = %.4f\n', Eb);

%% Constellation

figure;

plot(real(symboles), imag(symboles), 'o', ...
    'MarkerSize', 10, 'LineWidth', 1.5);

grid on;
axis equal;

xlabel('I');
ylabel('Q');

title('Constellation QPSK avec mapping Gray');

xlim([-1.2 1.2]);
ylim([-1.2 1.2]);

text(real(symboles)+0.05, imag(symboles)+0.05, ...
    {'00','01','11','10'});