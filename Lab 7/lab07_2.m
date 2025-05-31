
clear; close all;

% Zad 1
rng(4); % ziarno (seed) generatora losowego - wpisac numer grupy

MQam = 16; % liczba punktów konstelacji (M-QAM)
constellationType = 'gray'; % 'gray' or 'bin'

% Obliczenie SNR dla określonego przypadku transmisji z sondy Voyager-1
%Zad.2
%Kody Hamminga:
%(7,4)
%(31,26)
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
d = 500 * 1e9; % [m] (1e9 to 1 mln km)
BW = 50000;

Pt_dBm = 10*log10(P*1000);
[Pr_dBm,PL_dB] = tkcFriisModel(Pt_dBm,Gt,Gr,fc,d, 1,2);
Pr = 10.^(Pr_dBm/10) / 1000;

N0 = kB*T;
Pnoise = BW*N0;

SNRdB = 10*log10(Pr./Pnoise);
C = log2(MQam)- SNRdB/(MQam-1)
selectedCode = 2
% Parametry kodu Hamminga
N = [7,31]; K = [4,26]; M = N-K;
sk = K./N
% Wczytanie danych - z obrazu .bmp
for selectedImg = 5
    
    plotvar = 1;
    figure;
    for selectedCode = 1:2
        [binarySource, imgShape, img] = tkcDataFromImage('planet0'+ string(selectedImg) +'.bmp', K);
        binarySource = binarySource'
        binarySourceCoded = encode(binarySource,N(selectedCode),K(selectedCode),'hamming');
        % binarySourcePadded = binarySource;

        % 
        % r = mod(length(binarySource), K(selectedCode));
        % if r ~= 0
        %     padding = K(selectedCode) - r;
        %     binarySourcePadded = [binarySource, zeros(1, padding)];
        % end
        % u = reshape(binarySourcePadded', K(selectedCode), [])'
        % parityIndices = 2.^(0:M(selectedCode)-1)
        % informationIndices = setdiff(1:2^M(selectedCode)-1, parityIndices)
        % c = zeros(size(u, 1),N(selectedCode))
        % c(:, informationIndices) = u;
        % G = de2bi(1:(2^M(selectedCode)-1))
        % pc = c * G;
        % s = mod(pc, 2);
        % [m, n] = size(s);      
        % d = size(c, 2);              
        % posMatrix = repmat(parityIndices, m, 1);  
        % rowIdx = repmat((1:m)', 1, n);    
        % selRows = rowIdx(s == 1);          
        % selCols = posMatrix(s == 1);     
        % c(sub2ind(size(c), selRows, selCols)) = 1;
        % pc = c * G;
        % s = mod(pc, 2);
        % c = reshape(c', 1, [])
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Kodowanie - (Hamming, inne kody)
        % UZUPEŁNIĆ: koder, wejście: binarySource
        %                   wyjście: binarySourceCoded
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % binarySourceCoded = c;
        % uzupełnienie zerami 
        [binarySourceCoded, NumberOfPaddedBits] = tkcZeroPadding(binarySourceCoded, log2(MQam));
        binarySourceCoded = reshape(binarySourceCoded, log2(MQam),[]); %dane źródłowe - symbole kolumnami w zapisie binarnym
        decimalData = bit2int(binarySourceCoded, log2(MQam)); %zamiana na wartości na dziesiętne
        
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
        softReceived = -qamdemod(qamReceive, MQam, constellationType, 'UnitAveragePower', true, 'OutputType', 'approxllr', 'NoiseVariance', N0/2);
        binaryReceived = decode(binaryReceivedCoded, N(selectedCode),K(selectedCode),'hamming')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Dekodowanie - (Hamming, inne kody)
        % UZUPEŁNIĆ : dekoder, wejście: binaryReceivedCoded/softReceived
        %                      wyjście: binaryReceived - wektor, z liczbą elemntów taką jak binarySource
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % r = reshape(binaryReceivedCoded', N(selectedCode), [])';
        % for val = [1 0 0 1]
        %     pc = r * G;
        %     s = mod(pc, 2);
        %     r_cp = r;
        %     s_cp = s;
        %     [Lia, Locb] = ismember(s, G, 'rows');
        %     col_idx = Locb(Lia);
        %     row_idx = find(ismember(s, G, 'rows') == 1);
        %     size(s)
        %     idx = sub2ind(size(r), row_idx, col_idx); 
        %     r(idx) = val;
        % end
        % pc = r * G;
        % s = mod(pc, 2);
        % r_data = r(:,informationIndices)
        % r_data = reshape(r_data', 1, [])
        % binaryReceived = r_data
        % Ilustracje - nadany i odebrany obraz
        binaryReceived = binaryReceived(1:length(binarySource));
        BER_sim = sum(sum(binaryReceived~=binarySource))/numel(binarySource);
        subplot(2,3,plotvar);
        plotvar = plotvar +1;
        tkcShowImage(binarySource, imgShape, 'Source image');
        subplot(2,3,plotvar);
        plotvar = plotvar +1;
        binaryReceived_ColumnVectors = reshape(binaryReceivedCoded, N(selectedCode),[]);
        binaryReceived_InfPart = binaryReceived_ColumnVectors(N(selectedCode)-K(selectedCode)+1:N(selectedCode),:);
        tkcShowImage(binaryReceived_InfPart, imgShape, 'Received');
        subplot(2,3,plotvar);
        plotvar = plotvar +1;
        tkcShowImage(binaryReceived, imgShape, 'Received - ECC decoded');
        R_inf = 200000*sk(selectedCode)*C/(1/BW);
        % subplot(2,4,plotvar);
        % plotvar = plotvar +1;
        % tkcShowImage(reshape(binaryReceived_InfPart, 1, []) - binaryReceived+1, imgShape, 'diff');
    end
end