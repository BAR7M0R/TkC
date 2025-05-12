
clear; close all;

% Zad 4 - wykres maks. szybkość transmisji (pojemność kanału w/g Shannona) w funkcji mocy nadajnika Pt i szerokości pasma

% Stałe
fc = 2295e6;
Gt = 36;
Gr = 61;
T = 22; % st. K
kB = 1.380658e-23; % J/K
d = 4000e9; % 10 mln km

% Zmienne

BW = [1000:100:10000];
Pt = (1:50)';
Pt_matrix = repmat(Pt,1, length(BW));
BW_matrix = repmat(BW, length(Pt), 1);

%%%%% UZUPEŁNIĆ
% Wyznaczyć (jak w zad. 1):
% Pr = ... % moc odbierana - obliczyć na całej macierzy Pt_matrix
% Pnoise = ... % moc szumu


Capacity_AWGN = BW_matrix.*log2(1+Pr./Pnoise);

mesh(Pt_matrix, BW_matrix, Capacity_AWGN);
xlabel('Pt'); ylabel('Pasmo W=Rs'); zlabel('Capacity AWGN [b/s]');
title(["Capacity for Voyager-1 S-Band, distance d="+d/1e9+" [mln km]"]);



