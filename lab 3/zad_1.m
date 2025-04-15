clear; close all; clc;

%wczytanie pliku nrz_signal
% output_nrz - sygnał wyjściowy nadajnika;
% nrz_awgn   - sygnał wyjściowy kanał AWGN;
% Rb - prędkość binarna
% fp_max - maksymalna częstotliwość próbkowania (częstotliwość próbkowania sygnału w nadajniku)

load('nrz_signal');
%% a) 

signal_out = output_nrz; % -> V or A
signal_AWGN = nrz_awgn;% -> V or A


raw_AWGN=signal_AWGN-signal_out;   %wyznaczenie składnika szumowego -> V or A
raw_AWGN_power=mean(raw_AWGN.^2);  % moc szumu V/1ohm or A*1ohm -> W
signal_out_power=mean(signal_out.^2); %moc sygnału -> W
SNR=10*log10(signal_out_power/raw_AWGN_power)  %wyznaczenie SNR -> W/W


t=0:1/fp_max:(N*fp_max/Rb-1)/fp_max;  %dziedzina czasu -> s
figure(1)
plot(t,signal_AWGN,t,signal_out);  %wyświetlenie sygnału
xlim([0 20/Rb]);
xlabel('time, s') 
ylabel('NRZ signal and noise, W') 

%% b) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% uzupełnić impulsy odpowiadające danym binarnym
% 
% inf_impulse=..................; 
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fp_in=[10, 20, 40, 50, 100, 200, 500, 1000]; % przyjęte częstotliwości próbkowania (najmniejsza odpowiada prędkości binarnej) -> Hz
decymation_factor_in=fp_max./fp_in;     %współczynniki decymacji na wejściu filtru -> Hz/Hz
decymation_factor_out=fp_in/Rb;         %współczynniki decymacji nw wyjściu filtru -> Hz/(bit/s) -> bit
oversampling = fp_max/Rb;
inf_impulse=signal_out(1 : oversampling : end)'; % decymacja oraz transpozycja -> V or A

signal_decymation_power=mean(inf_impulse.^2); % -> W
for i=1:length(fp_in)
    nrz_in{i}=signal_AWGN(1:decymation_factor_in(i):end);   % próbkowanie an wejściu filtru -> V or A
    matched_filter{i}=ones(1,fp_in(i)/Rb)/(fp_in(i)/Rb); %konstrukcja filtru dopasowanego -> bit/bit 
    nrz_out{i}=filter(matched_filter{i},1, nrz_in{i}); %filtracja w filtrze dopasownym -> V
    nrz_out_decymation(i,:)=nrz_out{i}(decymation_factor_out(i):decymation_factor_out(i):end); %decymacja za filtrem
    noise_out_decymation(i,:)=nrz_out_decymation(i,:)-inf_impulse;        %obliczenie składnika szumowego 
    noise_out_decymation_power(i)=mean(noise_out_decymation(i,:).^2);  %obliczenie jego mocy
    SNR_dec_m(i)=10*log10(signal_decymation_power/noise_out_decymation_power(i));  %obliczenie SNR
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
% WYKRES
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t=0:1/(fp_max):(N*fp_max/Rb-1)/(fp_max*100); 
figure(name="signal after filter")
outsig = nrz_out{1}>0;
plot(t, outsig)

figure(name="SNR for matched filter")
plot(fp_in, SNR_dec_m,'o')
xlabel("frequency, Hz")
ylabel('$SNR,  \frac{W}{W}$','Interpreter','latex')

%% c) 

input_mtx=reshape(signal_AWGN,fp_max/Rb,[]); %macierz, kolumnowo sygnały poszczególnych bitów

for i=1:length(fp_in)
    mtx_in{i}=input_mtx(1:decymation_factor_in(i):end,:);   %próbkowanie na wejściu i kolumnowo poszczególne bity
    impulse_shape{i}=ones(fp_in(i)/Rb,1)/(fp_in(i)/Rb); %konstrukcja impulsu kształtującego
    mtx_out{i}=sum(mtx_in{i}.*impulse_shape{i},1);            %korelacja 
    noise_mtx_dec(i,:)=mtx_out{i}-inf_impulse;        %obliczenie składnika szumowego 
    noise_mtx_dec_power(i)=mean(noise_mtx_dec(i,:).^2);  %obliczenie jego mocy
    SNR_dec_c(i)=10*log10(signal_decymation_power/noise_mtx_dec_power(i));  %obliczenie SNR
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

