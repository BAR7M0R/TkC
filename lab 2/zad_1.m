% Generacja sygnałów cyfrowych - cz.2

clear; clc; close all;

%% Dane przykładowe
Rs=30;      %prędkość symbolowa -> bit/s
fp=120;      %próbkowanie -> Hz
M=5;      %ilość odstępów międzysymbolowych -> bit 
Ts = 1/Rs; % okres symbolowy -> s/bit
N_fft=4096; %rozmiar FFT -> bezwymiarowe
Tp = 1/fp;
f_res = fp/N_fft;





%% a) 	

% określenie dziedziny czasu
t=0:Tp:M/Rs; % -> s

% określenie dziedziny częstotliwości
f=0:f_res:fp-1/N_fft; % -> Hz
t_h_sinc_max = M/(2*Rs);
% wyznaczenie współczynników filtru
h_amp = Rs/fp;
h_sinc=h_amp*sinc(Rs*(t-M/(2*Rs))); % -> V or A #t-M/(2*Rs) != 0 -> t !=M/(2Rs)
B= 1/(t(15) - t(7)); % -> s
% wyświetlenie odpowiedzi impulsowej w dziedzinie czasu
figure(1)
stem(t,h_sinc)
grid;
title('Odpowiedź impulsowa')
xlabel('$\textsf{Czas, }s$','Interpreter','latex')
%xlabel('$s$','Interpreter','latex')
ylabel('$\textsf{Amplituda, }V\textsf{ lub }A$', 'Interpreter','latex')
xticks(0 : 2*Tp : M/Rs)
labels_x = ["0", arrayfun(@(x) x + "Tp", 1:20)];
labels_x = labels_x(1:2:end);
xticklabels(labels_x)

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
xticks(0:205*f_res:fp-1/N_fft)
labels_x = ["0", arrayfun(@(x) x + "f_{rez}", 1:4095)];
labels_x = labels_x(1:205:end);
xticklabels(labels_x)
xtickangle(90)
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
xticks(0:125*f_res:fp-1/N_fft)
%% b)


%odpowiedź impulsowa dla NRZ
h_NRZ=1*ones(1,fp/Rs)/(fp/Rs); % -> V or A //zabieg który nie ma fizycznej interpr.


%%%%%%%%%%%%%%%%%%%%%%%
%
%  UZUPEŁNIĆ
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H_NRZ=fft(h_NRZ, N_fft);
abs_H_nrz= abs(H_NRZ);
H_nrzdB= 20*log10(abs_H_nrz);
figure (4)
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
figure(5)
plot(t,H_RC_02,t,H_RC_05,t,H_RC_30);

% wyznaczenie charakterystyk amplitudowych

H_RC_02=fft(H_RC_02,N_fft);
abs_H_RC_02 = abs(H_RC_02);
H_abs_RC_02_dB = 20*log10(abs_H_RC_02);
H_RC_05=fft(H_RC_05,N_fft);
abs_H_RC_05 = abs(H_RC_05);
H_abs_RC_05_dB = 20*log10(abs_H_RC_05);
H_RC_30=fft(H_RC_30,N_fft);
abs_H_RC_30 = abs(H_RC_30);
H_abs_RC_30_dB = 20*log10(abs_H_RC_30);

%wyświetlenie charakterystyk amplitudowych - skala liniowa i decybelowa
figure(6)
plot(f,abs_H_RC_02,f,abs_H_RC_05,f,abs_H_RC_30);
%xlim([0 4*Rs])
xlim ([0 fp/2]);
title("charakterystyka amplitudowa w skali liniowej")
figure(6)
plot(f,H_abs_RC_02_dB, f, H_abs_RC_05_dB, f, H_abs_RC_30_dB);
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
