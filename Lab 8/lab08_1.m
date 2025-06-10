
clear; close all; clc;

% Zad 1
rng(4); % ziarno (seed) generatora losowego - wpisac numer grupy

MQam = 16; % liczba punktów konstelacji (M-QAM)
constellationType = 'gray'; % 'gray' or 'bin'

% Obliczenie SNR dla określonego przypadku transmisji z sondy Voyager-1

P = 26; % [W]
% fc = 2295e6; % [Hz] S-Band
fc = 8415e6; % [Hz] X-Band
% Gt = 36; % S-Band
Gt = 47; % X-Band
% Gr = 61;
Gr = 71; % X-Band
% T = 22; % st.K - S-Band
T = 25; % st.K - X-Band
kB = 1.380658e-23; % J/K
d = 1600 * 1e9; % [m] (1e9 to 1 mln km)
BW = 50000;

Pt_dBm = 10*log10(P*1000);
[Pr_dBm,PL_dB] = tkcFriisModel(Pt_dBm,Gt,Gr,fc,d, 1,2);
Pr = 10.^(Pr_dBm/10) / 1000;

N0 = kB*T;
Pnoise = BW*N0;

SNRdB = 10*log10(Pr./Pnoise);

%%%%%%%%%%%%%%%
% UZUPEŁNIĆ: dobrać parametry kodu BCH / kodu polarnego
% Sprawdzenie dopuszczalnych wielkosci kodów BCH, np.: bchnumerr(63)
% Parametry kodu
M = log2(MQam);
K = 5
N = 2^M-1; 
% bchnumerr(N,K)
% Wczytanie danych - z obrazu .bmp
[binarySource, imgShape, img] = tkcDataFromImage('planet05.bmp', K);
binarySource = binarySource';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kodowanie kanałowe
% UZUPEŁNIĆ: koder, wejście: binarySource
%                   wyjście: binarySourceCoded
%
%%%%%%%%%% koder Hamminga
% binarySourceCoded = encode(binarySource,N,K,'hamming');
%%%%%%%%%% koder BCH
temp = reshape(binarySource,[],4);
binarySourceGF = gf(temp);

% M = 4;
% n = 2^M-1;   % Codeword length
 k = 5;       % Message length
% nwords = 10;
% msgTx = gf(randi([0 1],nwords,k));
% enc = bchenc(msgTx,n,k);
binarySourceCoded = bchenc(binarySourceGF,N,K);
% binarySourceCoded = reshape(binarySourceCoded,1,[]);
% binarySourceCoded = binarySourceCoded.x; % gf to uint32
%%%%%%%%%% koder Polarny
% binarySourceCoded = tkcPolarCRCEncoder(binarySource, N, K);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% zamiana na liczby calkowite 0...(2^X-1), gdzie 2^X - liczba punktow konstelacji
[binarySourceCoded, NumberOfPaddedBits] = tkcZeroPadding(binarySourceCoded, log2(MQam));
binarySourceCoded = reshape(binarySourceCoded, log2(MQam),[]); %dane źródłowe - symbole kolumnami w zapisie binarnym
decimalData = bit2int(binarySourceCoded.x, log2(MQam));     %zamiana na wartości na dziesiętne
temp = de2bi(decimalData)
% Nadajnik
qamTransmit = qammod(decimalData, MQam, constellationType, 'UnitAveragePower', true);

% Kanał
[qamReceive, N0] = tkcAwgnBaseband(qamTransmit, SNRdB, 1);

% Odbiornik - twarde decyzje
decimalReceived = qamdemod(qamReceive, MQam, constellationType, 'UnitAveragePower', true);
binaryReceivedCoded = int2bit(decimalReceived, log2(MQam));
binaryReceivedCoded = reshape(binaryReceivedCoded, 1,[]);
binaryReceivedCoded = tkcTrimming(binaryReceivedCoded, NumberOfPaddedBits, 'columns');

% Odbiornik - miękkie decyzje
%softReceived = qamdemod(qamReceive, MQam, constellationType, 'UnitAveragePower', true, 'OutputType', 'approxllr', 'NoiseVariance', N0/2);
%softReceived = reshape(softReceived, 1,[]);
%softReceived = tkcTrimming(softReceived, NumberOfPaddedBits, 'columns');

% Dekodowanie kanałowe
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dekodowanie kanałowe
% UZUPEŁNIĆ : dekoder, wejście: binaryReceivedCoded/softReceived
%                      wyjście: binaryReceived - wektor, z liczbą elemntów taką jak binarySource
%
%%%%%%%%%%% dekoder Hamminga
% binaryReceived = decode(binaryReceivedCoded,N,K,'hamming');
% binaryReceived_ColumnVectors = reshape(binaryReceivedCoded, N,[]);
% binaryReceivedNoisy_InfPart = binaryReceived_ColumnVectors(N-K+1:N,:);
%%%%%%%%%% dekoder BCH
binaryReceivedCoded = reshape(binaryReceivedCoded,[],N);
% binaryReceivedNoisy_InfPart = binaryReceivedCoded(:,1:K);
% binaryReceivedCodedGF = gf(binaryReceivedCoded);
% binaryReceivedGF = bchdec(binaryReceivedCodedGF,N,K);
% binaryReceived = reshape(binaryReceivedGF.x,1,[]);
%%%%%%%%%% dekoder Polarny
% binaryReceivedNoisy_InfPart = double(binarySourceCoded == reshape(binaryReceivedCoded, size(binarySourceCoded)));
% binaryReceivedNoisy_InfPart = binaryReceivedNoisy_InfPart(1:length(binarySource)); % położenie błędów - w części informacyjnej
% binaryReceived = tkcPolarCRCDecoder(softReceived, N, K);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Ilustracje - nadany i odebrany obraz
figure;
subplot(231);
tkcShowImage(binarySource, imgShape, 'Source image');
subplot(232);
tkcShowImage(binaryReceivedNoisy_InfPart, imgShape, 'Error pattern');
subplot(233);
tkcShowImage(binaryReceived, imgShape, 'Received - ECC decoded');

