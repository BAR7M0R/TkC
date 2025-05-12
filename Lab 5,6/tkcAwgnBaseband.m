function [r, N0] = tkcAwgnBaseband(s, SNRdb, P_mean)
%function [r, N0] = tkcAwgnBaseband(s, SNRdb, P_mean)
%
% Do symboli (zepsolonych) s, funkcja dodaje biały szum gaussowski,
% przy zadanym stosunku mocy sygnału do szumu SNRdb
%
% s - wektor lub macierz z symbolami rzeczywistymi lub zespolonymi
% SNRdb - Signal-to-Noise-Ratio [dB]
% P_mean - średnia moc sygnału (jeśli nie podano, to jest mierzona w wektorze wejściowym s)
% r - wektor z dodanym szumem
% N0 - widmowa gęstość mocy dodanego szumu
%

gamma = 10^(SNRdb/10); %SNR w skali liniowej
if ~exist('P_mean', 'var')
    P_mean = sum(sum(abs(s).^2))/numel(s); % moc wyliczona
end
N0=P_mean/gamma;
sigma = sqrt(N0/2); % (wariancja sigma^2=N0/2)
if(isreal(s))
    n = sigma*randn(size(s)); % szum
else
    n = sqrt(N0/2)*(randn(size(s))+1i*randn(size(s))); % szum "zespolony"
end 
r = s + n; % sygnal z addytywnym szumem

end
