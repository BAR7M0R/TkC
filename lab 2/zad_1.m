% Generacja sygnałów cyfrowych - cz.2

clear; clc; close all;

%% Dane przykładowe
Rs=15;      %prędkość symbolowa -> bit/s
fp=120;      %próbkowanie -> Hz
M=5;      %ilość odstępów międzysymbolowych -> bit 
Ts = 1/Rs; % okres symbolowy -> s/bit
N_fft=4096; %rozmiar FFT -> bezwymiarowe






%% a) 	

% określenie dziedziny czasu
t=0:1/fp:M/Rs; % -> s
% określenie dziedziny częstotliwości
f=0:fp/N_fft:fp-1/N_fft; % -> Hz

% wyznaczenie współczynników filtru
h_sinc=1*Rs/fp*sinc(Rs*(t-M/(2*Rs))); % -> V or A
sym_wst_gl= t(15) - t(7); % -> s
% wyświetlenie odpowiedzi impulsowej w dziedzinie czasu
figure(1)
stem(t,h_sinc)
grid;
title('Odpowiedź impulsowa')
xlabel('$\textsf{Czas, }s$','Interpreter','latex')
%xlabel('$s$','Interpreter','latex')
ylabel('$\textsf{Amplituda, }V\textsf{ lub }A$', 'Interpreter','latex')
%wyznaczenie charakterystyki częstotliwościowej
H_sinc=fft(h_sinc,N_fft); % -> V or A
abs_H_sinc=abs(H_sinc); % -> V or A

% wyświetlenie ch-ki amplitudowej - skala liniowa
figure(2)
plot(f,abs_H_sinc);
grid
title('Charakterystyka amplitudowa - skala liniowa')
xlabel('$\textsf{Czestotliwosc, }Hz$','Interpreter','latex')
ylabel('$\textsf{Amplituda, }V\textsf{ lub }A$', 'Interpreter','latex')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   UZUPEŁNIĆ O DECYBELOWĄ
%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

abs_H_sinc_dB = 20*log10(abs_H_sinc); % -> dB
figure(3)
plot(f,abs_H_sinc_dB);
xlim ([0,fp/2]);
grid
title('Charakterystyka amplitudowa - skala logarytmiczna')
xlabel('$\textsf{Czestotliwosc, }Hz$','Interpreter','latex')
ylabel('$\textsf{Amplituda, } dB$', 'Interpreter','latex')
%% b)


%odpowiedź impulsowa dla NRZ
h_NRZ=1*ones(1,fp/Rs)/(fp/Rs); % -> bit

%%%%%%%%%%%%%%%%%%%%%%%
%
%  UZUPEŁNIĆ
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H_NRZ=fft(h_NRZ, N_fft);
abs_H_nrz= abs(H_NRZ);
H_nrzdB= 20*log10(abs_H_nrz);
figure (3)
hold on
plot(f, H_nrzdB);
hold off
xlim ([0,fp/2]);
grid
title('Charakterystyka amplitudowa - skala decybelowa')

%% c)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  UZUPEŁNIĆ DLA POZOSTAŁYCH ALPHA
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A=0.2; %współczynnik przekroczenia pasma ->
sps=fp/Rs;
span=M;
shape='normal';

%wyznaczenie współczynników filtru podniesionego cosinusa
H_RC_02 = rcosdesign(0.2,span,sps,'normal');
H_RC_05 = rcosdesign(0.5,span,sps,'normal');
H_RC_30 = rcosdesign(1,span,sps,'normal');



% wyświetlenie odpowiedzi impulsowej
figure(4)
plot(t,H_RC_02,t,H_RC_05,t,H_RC_30);

% wyznaczenie charakterystyk amplitudowych

H_RC_02=fft(H_RC_02,N_fft);
abs_H_RC_02 = abs(H_RC_02);
H_RC_05=fft(H_RC_05,N_fft);
abs_H_RC_05 = abs(H_RC_05);
H_RC_30=fft(H_RC_30,N_fft);
abs_H_RC_30 = abs(H_RC_30);

%wyświetlenie charakterystyk amplitudowych - skala liniowa i decybelowa
figure(5)
plot(f,abs_H_RC_02,f,abs_H_RC_05,f,abs_H_RC_30);
%xlim([0 4*Rs])
xlim ([0 fp/2]);
title("charakterystyka amplitudowa w skali liniowej")
figure(6)
plot(f,20*log10(abs_H_RC_02), f, 20*log10(abs_H_RC_05), f, 20*log10(abs_H_RC_30));
%xlim([0 4*Rs])
xlim ([0 fp/2]);
title("charakterystyka amplitudowa w skali logarytmicznej")


%% d) 
h_RC = rcosdesign(A,span,sps,'normal');
h_sqrt = rcosdesign(A,span,sps,'sqrt');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% UZUPEŁNIĆ WYSWIETLANIE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
