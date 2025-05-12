function [binOutput, imgShape, img] = tkcDataFromImage(fileName, M)
% function [binOutput, imgShape] = tkcDataFromImage(fileName, M)
%
% fileName - blik bitmapy monochromatycznej (dwa kolory: czarny / biały)
% M - binOutput zostanie uzupelnione tak, aby jego rozmiar byl podzielny przez M
% binOutput - wektor danych binarnych
% imgShape - rozmiar obrazka - wektor określający [Wysokosc, Szerokosc]
% img - obraz zapisany w macierzy

img = double(imread(fileName));
imgShape = size(img);
binOutput = reshape(img, numel(img), 1);
binOutput = tkcZeroPadding(binOutput,M);

end