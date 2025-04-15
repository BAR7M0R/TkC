clear; close all; clc;

%% PRZYKŁADOWE DANE (ZMIEŃ NA WŁAŚCIWE)
Rb=20;         %Prędkość binarna
fp=1000;        %częstotliwośc próbkowania
N=10000;   %liczba bitów
N_fft=4096;      %rozmiar FFT do wyznaczania widmowej gęstości mocy


%% UWAGA: PSD wyznaczane funkcją pwelch ma dwa razy większe wartości bo jest wyświetlane jednostronnie

%% a)	
data=randi(2,1,N)-1;


%% b)	

t=0:1/fp:(N*fp/Rb-1)/fp;

output_nrz = nrz_encoder(data,fp,Rb);
output_rz = rz_encoder(data,fp,Rb);
output_manchester = manchester_encoder(data,fp,Rb);
output_miller = miller_encoder(data,fp,Rb);

figure(1)
subplot(4,1,1);
plot(t,output_nrz);
axis([0 20/Rb -1.1 1.1])
title('NRZ')
grid;
subplot(4,1,2);
plot(t,output_rz);
axis([0 20/Rb -1.1 1.1])
title('RZ')
grid;
subplot(4,1,3);
plot(t,output_manchester);
axis([0 20/Rb -1.1 1.1])
title('manchester')
grid;
subplot(4,1,4);
plot(t,output_miller);
axis([0 20/Rb -1.1 1.1])
title('miller')
grid;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% UZUPEŁNIĆ CD. WYSWIETLANIA
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% c)	

% wartości praktyczne PSD
[S_nrz, Freq] = pwelch(output_nrz, N_fft, N_fft/2,  N_fft, fp);
[S_rz, Freq] = pwelch(output_rz, N_fft, N_fft/2,  N_fft, fp);
[S_manchester, Freq] = pwelch(output_manchester,N_fft, N_fft/2,  N_fft, fp);
[S_miller, Freq] = pwelch(output_miller, N_fft, N_fft/2,  N_fft, fp);

% wartości teoretyczne 
% UZUPEŁNIĆ OBLICZENIA ZE WZORÓW
%
Am=1;
S_nrzt=(Am^2/Rb)*sinc(Freq/Rb).^2;
S_rzt=((Am/2)^2/Rb)*sinc(Freq/(Rb*2)).^2;
A=pi*Freq/Rb;
S_millert=(Am^2/Rb)*1./(2*A.^2.*(17+8*cos(8*A))).*(23-2*cos(A)-22*cos(2*A)-12*cos(3*A)+5*cos(4*A)+12*cos(5*A)+2*cos(6*A)-8*cos(7*A)+2*cos(8*A));
S_manchestert=(Am^2/Rb)*sinc(A/(pi*2)).^2.*sin(A/2).^2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% UZUPEŁNIĆ OBLICZENIA ZE WZORÓW
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2)
subplot(4,1,1);plot(Freq,S_nrz, Freq, 2*S_nrzt)
axis([0 10*Rb 0 1.1*max(S_nrz)])

title('PSD - sklala liniowa - NRZ')
grid;
subplot(4,1,2);plot(Freq,S_rz, Freq, 2*S_rzt)
axis([0 10*Rb 0 1.1*max(S_rz)])
title('PSD - skala liniowa - RZ')
grid;
subplot(4,1,3);plot(Freq,S_manchester, Freq,2*S_manchestert)
axis([0 10*Rb 0 1.1*max(S_manchester)])
title('PSD - skala liniowa - manchester')
grid;
subplot(4,1,4);plot(Freq,S_miller,Freq,2*S_miller)
axis([0 10*Rb 0 1.1*max(S_miller)])
title('PSD - skala liniowa - miller')
grid;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% UZUPEŁNIĆ CD. WYSWIETLANIA W SKALI LINIOWEJ + 
% NANIEŚĆ NA WYKRES ODPOWIEDNIĄ KRZYWĄ TEORETYCZNĄ
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S_nrztdB=10*log10(S_nrzt);
S_rztdB=10*log10(S_rzt);
S_millertdB=10*log10(S_millert);
S_manchestertdB=10*log10(S_manchestert);
figure('Name','PSD in logarithmic scale')
S_nrzdB=10*log10(S_nrz);
S_rzdB=10*log10(S_rz);
S_manchesterdB=10*log10(S_manchester);
S_millerdB = 10*log10(S_miller);
subplot(4,1,1);
plot(Freq,S_nrzdB,Freq,S_nrztdB)
axis([0 10*Rb -100 1.1*max(S_nrzdB)])
title('PSD - sklala dB - NRZ')
grid;
subplot(4,1,2);plot(Freq,S_rzdB,Freq,S_rztdB)
axis([0 10*Rb -100 1.1*max(S_rzdB)])
title('PSD - skala dB - RZ')
grid;
subplot(4,1,3);plot(Freq,S_manchesterdB,Freq,S_manchestertdB)
axis([0 10*Rb -100 1.1*max(S_manchesterdB)])
title('PSD - skala dB - manchester')
grid;
subplot(4,1,4);plot(Freq,S_millerdB,Freq,S_millertdB )
axis([0 10*Rb -100 1.1*max(S_millerdB)])
title('PSD - skala dB - miller')
grid;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% UZUPEŁNIĆ WYŚWIETLANIE JAK WYŻEJ ALE W SKALI DECYBELOWEJ
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


