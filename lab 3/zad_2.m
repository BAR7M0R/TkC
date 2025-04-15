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
xticks(0 : Rb : 10*Rb)
figure('Name',"PSD in logaritmic scale for signal")
S_dB = 20*log10(S);
plot(Freq,S_dB) % psd decybelowo
axis([0 10*Rb 1.1*min(S_dB) -4])
xticks(0 : Rb : 10*Rb)
xlabel("frequency, Hz")
ylabel('$PSD,  dB$','Interpreter','latex')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Uzupełnić odbiór za pomocą odpowiednio dobranego filtru dopasowanego
% lub metodą korelacyjną
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

signal_AWGN = signal;
figure(name="received AWGN signal")
plot(signal)
xlabel("sample")
ylabel("signal, V or A")

k = [1,2,4,5,10,20,50,100];

fp_in=k.*Rb; % przyjęte częstotliwości próbkowania (najmniejsza odpowiada prędkości binarnej) -> Hz
fp_max = max(fp_in);
fp_out = Rb;

decymation_factor_in=fp_max./fp_in;     %współczynniki decymacji na wejściu filtru -> Hz/Hz
decymation_factor_out=fp_in/Rb;         %współczynniki decymacji nw wyjściu filtru -> Hz/(bit/s) -> 1/bit

oversampling = fp_max/Rb;

%signal_decymation_power=mean(inf_impulse.^2); % -> W
for i=1:length(fp_in)
    nrz_in{i}=signal_AWGN(1:decymation_factor_in(i):end);   % próbkowanie an wejściu filtru -> V or A
    matched_filter{i}=ones(1,fp_in(i)/Rb)/(fp_in(i)/Rb); %konstrukcja filtru dopasowanego -> bit/bit 
    signal_out{i}=filter(matched_filter{i},1, nrz_in{i}); %filtracja w filtrze dopasownym -> V
    signal_out_decymation{i}=signal_out{i}(decymation_factor_out(i):decymation_factor_out(i):end); %decymacja za filtrem

end

threshold_compared_signal_out = signal_out_decymation{8}>0; 

tekst=bity2text(threshold_compared_signal_out)


