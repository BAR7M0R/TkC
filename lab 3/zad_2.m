clear;clc; close all

%% dane dotyczące pliku
number=1;
grupa=2;

%%wczytanie pliku
s1='signal';
s2=num2str(number);
s3=num2str(grupa);
load(strcat(s1,'_',s2,'_',s3));
load("nrz_signal.mat", "nrz_awgn")
%% Parametry symulacji
N_FFT=2048;
Rb=10;
fp_max = 1000;
fp=fp_max;
%ov=fp/Rb;
figure('Name', "Row signal")
%t = (0:ov:size(signal))
plot(signal)
xlabel("sampels")
ylabel("current/voltage")

%% a) identyfikacja kodu liniowego na podstawie PSD  (uwaga, dodatkowo szum AWGN)


[S,Freq]=pwelch(signal,N_FFT,N_FFT/2,N_FFT,fp_max);
figure('Name',"PSD in linear scale for signal")
plot(Freq,S); % psd liniowo
axis([0 10*Rb 0 1.1*max(S)])
xlabel('frequency, Hz','Interpreter','latex')
ylabel('$PSD,  \frac{W}{Hz}$','Interpreter','latex')
xticks([0 : Rb : 10*Rb])
figure('Name',"PSD in logaritmic scale for signal")
S_dB = 20*log10(S);
plot(Freq,S_dB) % psd decybelowo
axis([0 10*Rb 1.1*min(S_dB) -4])
xticks([0 : Rb : 10*Rb])
xlabel("frequency, Hz")
ylabel('$PSD,  dB$','Interpreter','latex')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Uzupełnić odbiór za pomocą odpowiednio dobranego filtru dopasowanego
% lub metodą korelacyjną
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fp_in=[1,2,4,5,10, 20, 40, 50, 100]*10; 
dec_factor_in=fp_max./fp_in;     %współczynniki decymacji na wejściu filtru
dec_factor_out=fp_in/Rb;         %współczynniki decymacji nw wyjściu filtru

inf_impulse=signal(1:fp_max/Rb:end)';

input_mtx=reshape(signal,fp_max/Rb,[]); %macierz, kolumnowo sygnały poszczególnych bitów

signal_dec_power=mean(inf_impulse.^2);

for i=1:length(fp_in)
    mtx_in{i}=input_mtx(1:dec_factor_in(i):end,:);   %próbkowanie na wejściu i kolumnowo poszczególne bity
    impulse_shape{i}=ones(fp_in(i)/Rb,1)/(fp_in(i)/Rb); %konstrukcja impulsu kształtującego
    mtx_out{i}=sum(mtx_in{i}.*impulse_shape{i},1);            %korelacja 
    noise_mtx_dec(i,:)=mtx_out{i}-inf_impulse;        %obliczenie składnika szumowego 
    signal_out(i,:)=mtx_out{i};
    noise_mtx_dec_power(i)=mean(noise_mtx_dec(i,:).^2);  %obliczenie jego mocy
    SNR_dec_c(i)=20*log10(signal_dec_power/noise_mtx_dec_power(i));  %obliczenie SNR
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
% WYKRES
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(name="SNR for correlation receive")
plot(fp_in, SNR_dec_c,'o')
xlabel("frequency, Hz")
ylabel("SNR, $\frac{W}{W}$", "Interpreter","latex")

tekst=bity2text(signal_out)


