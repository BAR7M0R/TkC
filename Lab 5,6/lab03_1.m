
clear; close all;

% Zad 1
rng(666); % ziarno (seed) generatora losowego - wpisac numer grupy

constellationType = 'gray'; % 'gray' or 'bin'
SNRdB = 2.0;

length = [300, 5000].*(10^6);
Rs = [30000, 4000];
MQam = [16, 2];
S_X_band_low = [9, 12];
S_X_band_high = [26, 22];
S_X_band_delta = S_X_band_high ./ S_X_band_low;
S_X_band_delta_dbm = 10*log10(S_X_band_delta./(10^-3)); %S-band at(1) X-band at(2)
N0 = [22 25].*(1.380658*10^(-23));
variant_noise = N0/2
N = N0.*Rs;
%%%% UZUPEŁNIĆ
% Zmienić, zgodnie z danymi wejściowymi: typ modulacji (wartość MQam)
% oraz napisać fragment kodu obliczającego SNR [dB] w zadanych przypadkach, korzystając z modelu Friisa
% (funkcja tkcFriisModel.m lub napisać własny fragment kodu)
Pt = [20, 100].*(10^3);
Pt_dBm = 10*log10(Pt./(10^-3));
Gt_dBi = 60 + 2.15;
Gr_dBi = 35 + 2.15;
f = 2115*10^6;
d= length;
L = N0;
n = 2;

%[Pr_dBm,PL_dB] = tkcFriisModel(voyTransPowDelt_dBm,Gt_dBi,Gr_dBi,f,d,L,n)
lambda=3*10^8/f;
PL_dB = Gt_dBi + Gr_dBi + 20*log10(lambda/(4*pi))-10*n*log10(d);
Pr_dBm = Pt_dBm + PL_dB
SNR_rec_dB=Pr_dBm-10*log(N)



%%%%%%%%%%%%%%%

% Wykreślenie konstelacji symboli

for M = MQam
    y = qammod(0:M-1,M, constellationType, 'PlotConstellation',true);

    % Wczytanie danych - z obrazu .bmp
    [binarySource, imgShape, img] = tkcDataFromImage('planet05.bmp', log2(M));
    % binarySource = randi(0:1,1024,1);
    binarySource = reshape(binarySource, log2(M),[]); %dane źródłowe - symbole kolumnami w zapisie binarnym
    decimalData = bit2int(binarySource, log2(M));     %zamiana na wartości na dziesiętne
    
    % Nadajnik
    qamTransmit = qammod(decimalData, M, constellationType, 'UnitAveragePower', true);
    
    % Kanał
    [qamReceive, N0] = tkcAwgnBaseband(qamTransmit, SNRdB, 1);
    
    % Ilustracja - symbole nadawnae i odbierane, na płaszczyźnie zespolonej
    H = scatterplot(qamTransmit, 1, 0, 'yx');
    hold on;
    scatterplot(qamReceive, 1, 0, 'r.', H);
    
    % Odbiornik - twarde decyzje
    decimalReceived = qamdemod(qamReceive, M, constellationType, 'UnitAveragePower', true);
    binaryReceived = int2bit(decimalReceived, log2(M));
    % Odbiornik - miękkie decyzje
    softReceived = -qamdemod(qamReceive, M, constellationType, 'UnitAveragePower', true, 'OutputType', 'approxllr', 'NoiseVariance', N0/2);
    
    % Ilustracje - nadany i odebrany obraz
    figure;
    subplot(231);
    tkcShowImage(binarySource, imgShape, 'Source image');
    subplot(232);
    tkcShowImage(binaryReceived, imgShape, 'Received - hard dec.');
    subplot(233);
    tkcShowImage(softReceived*0.05+0.5, imgShape, 'Received - soft dec.');

end

%%%% Zadanie 2 UZUPEŁNIĆ

% BER_sim = ...
% SER_sim = ...
% EbN0db = SNRdb - 10*log10(log2(MQam)); % związek pomiędzy SNR (Es/N0) a Eb/N0
% [BER_calc, SER_calc] = berawgn(EbN0db, 'psk', 2, 'nondiff'); % dla BPSK
% [BER_calc, SER_calc] = berawgn(EbN0db, 'qam', MQam); % dla QAM (również można użyć dla QPSK)

% Pe = BER_sim;
% C_BSC = ...
% R_inf = ...

%%%%%%%%%%%%%%%%%%%%%%%