function dataOutput = tkcTrimming(dataInput, X, RowsOrColumns)
% function dataOutput = tkcTrimming(dataInput, X, RowsOrColumns)
%
% Funkcja usuwa X ostatnich kolumn / wierszy w wektora (macierzy)
% np.:
%   u = tkcTrimming(u, 6, 'columns'); % usunie 6 ostatnich kolumn wektora u
%   y = tkcTrimming(y, 8, 'rows'); % usunie 8 ostatnich wierszy wektora y
%

if ~exist('RowsOrColumns','var')
    RowsOrColumns = 'columns';
end

if strcmpi(RowsOrColumns,'columns')
    dataOutput = dataInput(:, 1:end-X);
elseif strcmpi(RowsOrColumns,'rows')
    dataOutput = dataInput(1:end-X, :);
else
    dataOutput = dataInput;
end

end