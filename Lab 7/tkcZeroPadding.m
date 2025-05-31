function [dataOutput, NumberOfBitsPadded] = tkcZeroPadding(dataInput, M)
% function [dataOutput, NumberOfBitsPadded] = tkcZeroPadding(dataInput, M)
%
% Funkcja uzupełnia wektor dataInput zerami tak, aby jego dlugosc byla podzielna przez M
%

if iscolumn(dataInput)
    dataSize = size(dataInput,1);
    NumberOfBitsPadded = (mod(dataSize,M)~=0)*M-mod(dataSize,M);
    dataOutput = [dataInput; zeros(NumberOfBitsPadded,1)];
else
    dataSize = size(dataInput,2);
    NumberOfBitsPadded = (mod(dataSize,M)~=0)*M-mod(dataSize,M);
    dataOutput = [dataInput, zeros(size(dataInput,1), NumberOfBitsPadded)];
end

end