clear; close all; clc;

%wczytanie pliku nrz_signal
% output_nrz - sygnał wyjściowy nadajnika;
% nrz_awgn   - sygnał wyjściowy kanał AWGN;
% Rb - prędkość binarna
% fp_max - maksymalna częstotliwość próbkowania (częstotliwość próbkowania sygnału w nadajniku)

load('nrz_signal');

%% a) 

noise=nrz_awgn-output_nrz;   %wyznaczenie składnika szumowego
noise_power=mean(noise.^2);  % moc szumu
signal_power=mean(output_nrz.^2); %moc sygnału
SNR=10*log10(signal_power/noise_power)  %wyznaczenie SNR


t=0:1/fp_max:(N*fp_max/Rb-1)/fp_max;  %dziedzina czasu
figure(1)
plot(t,nrz_awgn,t,output_nrz);  %wyświetlenie sygnału
xlim([0 20/Rb]);
xlabel('time, s') 
ylabel('NRZ signal and noise, W') 

%% b) 
fp_in=[10, 20, 40, 50, 100, 200, 500, 1000]; % przyjęte częstotliwości próbkowania (najmniejsza odpowiada prędkości binarnej)
dec_factor_in=fp_max./fp_in;     %współczynniki decymacji na wejściu filtru
dec_factor_out=fp_in/Rb;         %współczynniki decymacji nw wyjściu filtru


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% uzupełnić impulsy odpowiadające danym binarnym
% 
% inf_impulse=..................; 
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dec_factor_in=fp_max./fp_in;     %współczynniki decymacji na wejściu filtru
dec_factor_out=fp_in/Rb;         %współczynniki decymacji nw wyjściu filtru

inf_impulse=output_nrz(1 : fp_max/Rb : end)';

signal_dec_power=mean(inf_impulse.^2);
for i=1:length(fp_in)
    nrz_in{i}=nrz_awgn(1:dec_factor_in(i):end);   % próbkowanie an wejściu filtru
    qwe= fp_in(i)/Rb
    matched_filter{i}=ones(1,fp_in(i)/Rb)/(fp_in(i)/Rb); %konstrukcja filtru dopasowanego
    nrz_out{i}=filter(matched_filter{i},1, nrz_in{i}); %filtracja w filtrze dopasownym
    nrz_out_dec(i,:)=nrz_out{i}(dec_factor_out(i):dec_factor_out(i):end); %decymacja za filtrem
    noise_out_dec(i,:)=nrz_out_dec(i,:)-inf_impulse;        %obliczenie składnika szumowego 
    noise_out_dec_power(i)=mean(noise_out_dec(i,:).^2);  %obliczenie jego mocy
    SNR_dec_m(i)=10*log10(signal_dec_power/noise_out_dec_power(i));  %obliczenie SNR
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
% WYKRES
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(name="SNR for matched filter")
plot(fp_in, SNR_dec_m,'o')
xlabel("frequency, Hz")
ylabel('$SNR,  \frac{W}{W}$','Interpreter','latex')

%% c) 

input_mtx=reshape(nrz_awgn,fp_max/Rb,[]); %macierz, kolumnowo sygnały poszczególnych bitów

for i=1:length(fp_in)
    mtx_in{i}=input_mtx(1:dec_factor_in(i):end,:);   %próbkowanie na wejściu i kolumnowo poszczególne bity
    qq = fp_in(i)/Rb
    q = ones(fp_in(i)/Rb,1);
    a = (fp_in(i)/Rb);
    impulse_shape{i}=ones(fp_in(i)/Rb,1)/(fp_in(i)/Rb); %konstrukcja impulsu kształtującego
    mtx_out{i}=sum(mtx_in{i}.*impulse_shape{i},1);            %korelacja 
    noise_mtx_dec(i,:)=mtx_out{i}-inf_impulse;        %obliczenie składnika szumowego 
    noise_mtx_dec_power(i)=mean(noise_mtx_dec(i,:).^2);  %obliczenie jego mocy
    SNR_dec_c(i)=10*log10(signal_dec_power/noise_mtx_dec_power(i));  %obliczenie SNR
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
% WYKRES
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(name="SNR for correlation receiver")
plot(fp_in, SNR_dec_c,'*')
xlabel("frequency, Hz")
ylabel('$SNR,  \frac{W}{W}$','Interpreter','latex')

