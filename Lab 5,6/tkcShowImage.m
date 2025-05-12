function tkcShowImage(imgData, imgShape, imgTitle)
% function tkcShowImage(binOutput, imgShape)
%
% Dane w imgData są rysowane na obrazku o rozmiarze imgShape.
% Jesli podano imgTitle, to jest wypisywany jako tytuł, nad obrazkiem
%
% imgData - jeden kanał, wartosci w zakresie [0...1]
% imgShape - rozmiar obrazka - wektor określający [Wysokosc, Szerokosc]


imgData = imgData(:);
while numel(imgData)>imgShape(1)*imgShape(2)
    imgData = imgData(1:end-1); % trimming bits that were padded
end
imshow(reshape(imgData,imgShape), 'DisplayRange',[0 1], 'InitialMagnification', 'fit');
title(imgTitle);

end