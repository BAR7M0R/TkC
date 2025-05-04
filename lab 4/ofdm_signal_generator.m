function [ofdm_signal,ofdm_symbols,binary_data]=ofdm_signal_generator(B,P,N,CP,SNR,channel_IR);

%{
ofdm_signal - sygnał OFDM w dziedzinie czasu razem z szumem AWGN dla
zadanego SNR
ofdm_symbols - macierz symboli QAM przypisanych do poszczególnych symboli
OFDM (symbol OFDM to kolumna tej macierzy)
binary_data - dane binarne


B - liczba bitów 
N- ilość podkanałów/podnośnych
CP - rozmiar prefiksu cyklicznego
P - moc konstelacji
SNR - stosunek mocy sygnału do mocy szumu
channel_IR - odpowiedź impulsowa kanału
%}


binaryData=randi(0:1,B,1);                      %generacja wektora danych binarnych o długości B 
binaryData_mtx=reshape(binaryData,4,[])';       %przekształcenie w macierz, kolejne wiersze to binarna reprezentacja symboli QAM 
decimalData=bi2de(binaryData_mtx,'left-msb');          %zamiana każdego z wierszy na wartości dziesiętne
qamSymbols = qammod(decimalData, 16,'UnitAveragePower', true)*sqrt(P); %generacja symboli zespolonych z konstelacji o mocy P
ofdmSymbols_freq=reshape(qamSymbols,N,[]);      %przekształcenie w symbole OFDM (dziedzina częstotliwości), kolumnowo
ofdmSymbols_time=ifft(ofdmSymbols_freq);   % transformacja w symbole OFDM w dziedzinie czasu
ofdmSymbols_time_cp=[ofdmSymbols_time(end-CP+1:end,:);ofdmSymbols_time]; %uzupełnienie o prefiks cykliczny
ofdm_signal_vec=ofdmSymbols_time_cp(:);  %przekształcenie w wektor sygnału na wyjściu nadajnika
ofdm_signal_channel=filter(channel_IR,1,ofdm_signal_vec);   %transmisja przez kanał
ofdm_signal=awgn(ofdm_signal_channel,SNR,'measured');   % dodanie szumu dla zadanego SNR
ofdm_symbols=ofdmSymbols_freq;
binary_data=binaryData;
end