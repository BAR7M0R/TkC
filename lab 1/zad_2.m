clear; close all;
% LAB 1 - Generacja sygnałów cyfrowych cz.1


%% PRZYKŁADOWE DANE (ZMIEŃ NA WŁAŚCIWE)
Rs=20;           %Prędkość generowania symboli
K=5;             %zakres liczb
N=10000;         %długość wektora
N_fft=4096;      %rozmiar FFT do wyznaczania widmowej gęstości mocy

signal=randi(2*K+1,1,N)-(K+1);
t=(0:N-1)/Rs;

%% Sygnał uzyskany w Zad 1 poddaj operacji interpolacji,

L=100;  %stopień interpolacji
t_int=0:1/(Rs*L):(N-1)/Rs;  

signal_si0=interp1(t,signal,t_int,'previous'); %interpolacja rzędu 0
signal_si1=interp1(t,signal,t_int);            %interpolacja liniowa
signal_si2=interp1(t,signal,t_int,'cubic');    % interpolacja rzędu 3

%% a)

figure(1)
plot(t_int,signal_si0,t_int,signal_si1,t_int,signal_si2,t,signal,'o' );
%axis([ - - -uzupełnić - - -])
xlim([0,19/Rs]);
grid

%% b)	
[S_sig_i0, Freq] = pwelch(signal_si0, N_fft, N_fft/2,  N_fft, Rs*L);
[S_sig_i1, Freq] = pwelch(signal_si1, N_fft, N_fft/2,  N_fft, Rs*L);
[S_sig_i2, Freq] = pwelch(signal_si2, N_fft, N_fft/2,  N_fft, Rs*L);
S_sig_i0dB=10*log10(S_sig_i0);
S_sig_i1dB=10*log10(S_sig_i1);
S_sig_i2dB=10*log10(S_sig_i2);
figure(2)
plot(Freq,S_sig_i0,Freq,S_sig_i1,Freq,S_sig_i2)
axis([0 10*Rs 0 max(S_sig_i2)])
title('wykresy PSD sygnałów zinterpolowanych w dziedzinie częstotliwości – skala liniowa')

figure(3)
plot(Freq,S_sig_i0dB,Freq,S_sig_i1dB,Freq,S_sig_i2dB)
axis([0 10*Rs -100 max(S_sig_i2dB)])
title('wykresy PSD sygnałów zinterpolowanych w dziedzinie częstotliwości – skala decybelowa')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% UZUPEŁNIĆ DLA SKALI DECYBELOWEJ
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% c)	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% UZUPEŁNIĆ 
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s0=trapz (t_int,signal_si0 )
s1=trapz (t_int,signal_si1 )
s2=trapz (t_int,signal_si2 )
