%% Zad 2
% Symulacje dla różnych kodów Hamminga
rng(3); % ziarno (seed) generatora losowego - wpisac numer grupy

clear; close all;
figure(1); % colororder("gem12");
figure(2); % colororder("gem12");

% Parametry kodu Hamminga
NK = [7 4];
MQam = 4; % liczba punktów w konstelacji M-QAM
P=1;      % srednia moc symboli
SNRdb_vector = 0.0:1:30.0; % wektor wartosci SNR, dla ktorych będą kolejno wykonywane symulacje
BER_limit = 1e-6; % limit BER, poniżej którego symulacje są przerywane

legendLabels = [];

for h=1:size(NK,1)
    N = NK(h,1);
    K = NK(h,2);
    B = K*200000; % liczba bitów informacyjnych w symulacji
    SNRdb = SNRdb_vector;
    BER_sim = zeros(size(SNRdb));
    for s=1:length(SNRdb)
        % Data source
        binarySource = randi(0:1,1,B);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Kodowanie - (Hamming, inne kody)
        % UZUPEŁNIĆ: koder, wejście: binarySource
        %                   wyjście: binarySourceCoded
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [binarySourceCoded, NumberOfPaddedBits] = tkcZeroPadding(binarySourceCoded, log2(MQam));
        binarySourceCoded = reshape(binarySourceCoded, log2(MQam),[]); %dane źródłowe - symbole kolumnami w zapisie binarnym
        decimalData = bit2int(binarySourceCoded, log2(MQam));     %zamiana na wartości na dziesiętne
        % Transmitter - modulator
        qamTransmit = qammod(decimalData, MQam, 'UnitAveragePower', true) * sqrt(P);
        % Channel
        qamReceive = tkcAwgnBaseband(qamTransmit, SNRdb(s));
        % Receiver - hard decisions
        decimalReceived = qamdemod(qamReceive, MQam, 'UnitAveragePower', true);
        binaryReceivedCoded = int2bit(decimalReceived, log2(MQam));
        binaryReceivedCoded = reshape(binaryReceivedCoded, 1,[]);
        binaryReceivedCoded = tkcTrimming(binaryReceivedCoded, NumberOfPaddedBits, 'columns');
        % Dekodowanie - Hamming
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Dekodowanie - (Hamming, inne kody)
        % UZUPEŁNIĆ : dekoder, wejście: binaryReceivedCoded/softReceived
        %                      wyjście: binaryReceived - wektor, z liczbą elemntów taką jak binarySource
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        BER_sim(s) = sum(sum(binaryReceived~=binarySource))/numel(binarySource);
        if BER_sim(s)<BER_limit
            SNRdb = SNRdb(1:s);
            BER_sim = BER_sim(1:s);
            break;
        end
    end
    
    EbN0db = SNRdb-10*log10(log2(MQam));
    
    % Rysunek 1: BER/SER w funkcji Es/N0
    figure(1);
    semilogy(SNRdb, BER_sim, '-o');
    hold on;
    
    % Rysunek 2: BER/SER w funkcji Eb/N0
    figure(2);
    semilogy(EbN0db, BER_sim, '-o');
    hold on;

    % legenda
    legendLabels = [legendLabels; "QAM-"+MQam+". Hamming ("+N+","+K+") BER simulated"]; %#ok<AGROW>
end

if MQam==2
    [BER_calc, SER_calc] = berawgn(EbN0db, 'psk', MQam, 'nondiff');
else
    [BER_calc, SER_calc] = berawgn(EbN0db, 'qam', MQam, 'nondiff');
end
figure(1);
semilogy(SNRdb, BER_calc, '-');
figure(2);
semilogy(EbN0db, BER_calc, '-');
legendLabels = [legendLabels; "QAM-"+MQam+", uncoded, BER calculated" ];

% Opisy rysunkow
figure(1);
grid on;
xlabel('SNR (Es/N0) [dB]');
ylabel ('BER / SER');
legend(legendLabels, Location="southwest");
set(gcf, Position=[0 50 960 820]);

figure(2);
grid on;
xlabel('Eb/N0 [dB]');
ylabel ('BER / SER');
legend(legendLabels, Location="southwest");
set(gcf, Position=[960 50 960 820]);

