% Zad 3
rng(3); % ziarno (seed) generatora losowego - wpisac numer grupy

clear; close all;
figure(1); % colororder("gem12");
figure(2); % colororder("gem12");

B = 6000; % liczba bitów informacyjnych w symulacji Monte-Carlo
MQam = 4; % liczba punktów w konstelacji M-QAM
SNRdB_vector = 0.0:1:30.0; % wektor wartosci SNR, dla ktorych będą kolejno wykonywane symulacje
SER_limit = 1e-5; % limit SER, poniżej którego symulacje są przerywane

legendLabels = [];

% Symulacja dla modulacji o konstelacji MQam-punktowej
% UZUPEŁNIĆ:
% a) powtórzyć (zapętlić) dla innych konstelacji
% b) dodatkowy wykres - BER w funkcji odległości od sondy
% d = logspace(11,13, 20); 
% ...
% SNRdB = ... % obliczyć jak w zadaniu 1
% ...
% loglog(d/1e9, BER_calc, '-x');
%


SNRdB = SNRdB_vector;
SER_sim = zeros(size(SNRdB));
BER_sim = zeros(size(SNRdB));
% pętla - symulacje Monte-Carlo
for s=1:length(SNRdB)
    % Źródło danych
    %[binarySource, imgShape] = tkcReadImage('icons8-earth-planet-64.bmp');
    binarySource = randi(0:1,B,1);
    binarySource = reshape(binarySource, log2(MQam),[]); %dane źródłowe - symbole kolumnami w zapisie binarnym
    decimalData = bit2int(binarySource, log2(MQam));     %zamiana na wartości na dziesiętne
    % Nadajnik - modulator
    qamTransmit = qammod(decimalData, MQam, 'UnitAveragePower', true);
    % Kanał
    qamReceive = tkcAwgnBaseband(qamTransmit, SNRdB(s));
    % Odbiornik - demodulator z twardymi decyzjami
    decimalReceived = qamdemod(qamReceive, MQam, 'UnitAveragePower', true);
    binaryReceived = int2bit(decimalReceived, log2(MQam));
    SER_sim(s) = sum(decimalReceived~=decimalData)/numel(decimalData);
    BER_sim(s) = sum(sum(binaryReceived~=binarySource))/numel(binarySource);
    if SER_sim(s)<SER_limit
        SNRdB = SNRdB(1:s);
        BER_sim = BER_sim(1:s);
        SER_sim = SER_sim(1:s);
        break;
    end
end

EbN0db = SNRdB-10*log10(log2(MQam)); % związek pomiędzy SNR (Es/N0) a Eb/N0 [dB]
if MQam==2
    [BER_calc, SER_calc] = berawgn(EbN0db, 'psk', MQam, 'nondiff');
else
    [BER_calc, SER_calc] = berawgn(EbN0db, 'qam', MQam, 'nondiff');
end

% Rysunek 1: BER/SER w funkcji Es/N0
figure(1);
semilogy(SNRdB, SER_sim, 'o', SNRdB, BER_sim, 'o');
hold on;
set(gca, 'ColorOrderIndex', mod(gca().ColorOrderIndex-3, size(gca().ColorOrder,1))+1);
semilogy(SNRdB, SER_calc, '-', SNRdB, BER_calc, '-');


% Rysunek 2: BER/SER w funkcji Eb/N0
figure(2);
semilogy(EbN0db, SER_sim, 'o', EbN0db, BER_sim, 'o');
hold on;
set(gca, 'ColorOrderIndex', mod(gca().ColorOrderIndex-3, size(gca().ColorOrder,1))+1)
semilogy(EbN0db, SER_calc, '-', EbN0db, BER_calc, '-');

% legenda
legendLabels = [legendLabels; "QAM-"+MQam+" SER simulated";...
    "QAM-"+MQam+" BER simulated";...
    "QAM-"+MQam+" SER calculated";...
    "QAM-"+MQam+" BER calculated" ]; %#ok<AGROW>


% Opisy rysunkow
figure(1);
grid on;
xlabel('SNR (Es/N0) [dB]');
ylabel ('BER / SER');
legend(legendLabels, Location="southwest");
set(gcf, Position=[10 50 800 600]);

figure(2);
grid on;
xlabel('Eb/N0 [dB]');
ylabel ('BER / SER');
legend(legendLabels, Location="southwest");
set(gcf, Position=[820 50 800 600]);

