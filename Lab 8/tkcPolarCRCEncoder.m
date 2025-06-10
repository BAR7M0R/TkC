function [dataOutput] = tkcPolarCRCEncoder(msg, N, K)
% function [dataOutput] = tkcPolarEncoder(msg, N, K)
%   Polar code encoder - wrapping the 5G-Toolbox CRC + nrPolarEncode functions
%   msg - vector of data, that should have size being multiple of K
%   N - number of bits in every code vector
%   K - numner of bits in every information vector
%   dataOutput - coded vectors, reshaped into a single row vector

poly = '11'; % CRC polynomial
crcLen = 11; % Number of CRC bits
nMax = 9; % Maximum value of n, for 2^n
iIL = false; % Interleave input
iBIL = true; % Interleave coded bits


% Information vectors in columns
msg = reshape(msg,K,[]);

% CRC, Polar encode and Rate-match
dataOutput = zeros(N, size(msg,2));
for i=1:size(msg,2)
    % Attach CRC
    msg_i_withcrc = nrCRCEncode(msg(:,i), poly);
    %Polar Encode
    msg_i_enc = nrPolarEncode(msg_i_withcrc,N,nMax,iIL);
    % LengthBeforeRateMatch = length(msg_i_enc);
    % Rate match
    dataOutput(:,i) = nrRateMatchPolar(msg_i_enc,K+crcLen,N,iBIL);

end


dataOutput = reshape(dataOutput,1,[]);