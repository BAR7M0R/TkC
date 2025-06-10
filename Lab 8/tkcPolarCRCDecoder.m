function [msgDecoded] = tkcPolarCRCDecoder(inputLLR, N, K)
% function [msgDecoded] = tkcPolarCRCDecoder(inputLLR, N, K)
%   Polar code decoder - wrapping the 5G-Toolbox CRC + nrPolarDecode functions 
%   inputLLR - soft input decisions (LLRs), a vector containing data for any number of N-element codewords
%   N - number of bits in every code vector
%   K - numner of bits in every information vector
%   msgDecoded - decoded information vectors, reshaped into a single row vector


% poly = '11'; % CRC polynomial
crcLen = 11; % Number of CRC bits
nMax = 9; % Maximum value of n, for 2^n
iIL = false; % Interleave input
iBIL = true; % Interleave coded bits
ListLen = 8; % List length, a power of two, [1 2 4 8]


% code vectors in columns
inputLLR = reshape(inputLLR,N,[]);

NBeforeRateMatch = length(nrPolarEncode(zeros(K,1),N,nMax,iIL));

msgDecoded = zeros(K, size(inputLLR,2));
for i=1:size(inputLLR,2)
    % Rate recover
    decIn = nrRateRecoverPolar(inputLLR(:,i),K+crcLen,NBeforeRateMatch,iBIL);
    % Polar decode
    decOut = nrPolarDecode(decIn,K+crcLen,N,ListLen,nMax,iIL,crcLen);
    msgDecoded(:,i) = decOut(1:K,:);
end

msgDecoded = reshape(msgDecoded,1,[]);