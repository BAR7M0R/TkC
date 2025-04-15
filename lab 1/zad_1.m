clear; close all;
% LAB 1 - Generacja sygnałów cyfrowych cz.1

%% PRZYKŁADOWE DANE (ZMIEŃ NA WŁAŚCIWE)
Rs=20;           %Częstotliwość generowania symboli
K=5;             %zakres liczb
N=10000;         %długość wektora
N_fft=4096;      %rozmiar FFT do wyznaczania widmowej gęstości mocy



%% 
signal=randi(2*K+1,1,N)-(K+1); % Generacja wektora liczb/symboli


%% a)

t=(0:N-1)/Rs;

%% b)	

figure(1)
stem(t,signal);
axis([0 100/Rs min(signal)-1 max(signal)+1]); % funkcja określająca zakresy wyświetlania
grid
title('Symbole danych cyfrowych')

%% c)	

[S_sig, Freq] = pwelch(signal, N_fft, N_fft/2,  N_fft, Rs);
S_sigdB=10*log10(S_sig);
figure(2)
plot(Freq,S_sigdB) 
axis([Freq(1) Freq(end) min(S_sigdB) max(S_sigdB)+1]);
grid;
title('Widmowa gęstość mocy w skali decybelowej')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% UZUPEŁNIĆ
%

figure(3)
plot(Freq,S_sig) 
axis([Freq(1) Freq(end) min(S_sig) max(S_sig)]);
grid;
title('Widmowa gęstość mocy w skali liniowej')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% d)	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% UZUPEŁNIĆ
%
moc_czas=mean(signal.^2)
moc_widmo=sum(S_sig)*Rs/N_fft
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% e)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% UZUPEŁNIĆ
%
N=1000000;
signal1=randi(2*K+1,1,N)-(K+1);
[S_sig1, Freq]= pwelch(signal1,N_fft,N_fft/2, N_fft, Rs);
figure(4)
plot(Freq,S_sig,Freq, S_sig1) 
axis([Freq(1) Freq(end) min(S_sig) max(S_sig)]);
grid;
title('wykres sygnału cyfrowego w dziedzinie czasu')

moc_czas=mean(signal.^2)
moc_widmo=sum(S_sig)*Rs/N_fft
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



