% Odbiór sygnałów cyfrowych - cz.2

clear;clc; close all;

%% Dane przykładowe
N_fft=4096; %rozmiar FFT
N=100000; % liczba symboli QAM
P=1;

%% a) 
% 
alpha=[0,0.25,0.5,0.75,1];
span=[2,4,6,8];
sps=5;

for a=1:length(alpha)
    for b=1:length(span)
        h_sqrt{a,b}=rcosdesign(alpha(a),span(b),sps,'sqrt');
        h_full{a,b}=conv(h_sqrt{a,b},h_sqrt{a,b});
    end
end


%% b) 

SNR=100; %stosunek mocy sygnału do mocy szumu;

%generacja symboli
[qamSymbols_out, qamSymbols_ref, binaryData]=qam_symbol_generator(N,SNR);

%interpolacja
qamSymbols_mtx=[qamSymbols_ref.';zeros(sps-1,length(qamSymbols_ref))]; 
qamSymbols_int=qamSymbols_mtx(:);

for a=1:length(alpha)
    for b=1:length(span)
        qamSignal_sqrt=filter(h_full{a,b},1,qamSymbols_int);        %transmisja przez kaskadę filtr kształtujący i dopasowany
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %qamSymbols_dec=         UZUPEŁNIĆ                                   %decymacja (ważna poprawna synchronizacja)
        qamSymbols_dec=qamSignal_sqrt(1+span(b)*sps: sps : end);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        qamSymbols_store{a,b}=qamSymbols_dec;
        qamSymbols_ref_cut=qamSymbols_ref(1:end-span(b));                   %skracanie wektora symboli oryginalnych o span elementów (specyfika działania funkcji filter)
        evm(a,b)=evm_measure(qamSymbols_dec,qamSymbols_ref_cut,P);
        
    end
end
evm_tran = evm';
%figure(Name="min")
scatterplot(qamSymbols_store{1,1});
%figure(Name="ref")
scatterplot(qamSymbols_ref);

%figure(Name="max")
scatterplot(qamSymbols_store{5,4});

%% c) 
SNR=[0 10 20];
for i=1:length(SNR)

    %generacja symboli QAM
    [qamSymbol_out, qamSymbol_ref, binary_data]=qam_symbol_generator(N,SNR(i));
    
    %  detekcja twardodecyzyjna
    
    binary_receive=qamdemod(qamSymbol_out,16,'UnitAveragePower',true,'OutputType','bit');
    [~,BER_hard(i)]=biterr(binary_receive,binary_data);
    
    %  detekcja miękkodecyzyjna
    
    LLR_receive=qamdemod(qamSymbol_out,16,'UnitAveragePower',true,'OutputType','llr','NoiseVariance',10^(-SNR(i)/10));
    binary_LLR=(-sign(LLR_receive)+1)/2;
    [~,BER_LLR(i)]=biterr(binary_LLR,binary_data);
    
    %  detekcja miękkodecyzyjna przybliżona
    
    LLR_approx_receive=qamdemod(qamSymbol_out,16,'UnitAveragePower',true,'OutputType','approxllr','NoiseVariance',10^(-SNR(i)/10));
    binary_LLR_approx=(-sign(LLR_approx_receive)+1)/2;
    [~,BER_LLR_approx(i)]=biterr(binary_LLR_approx,binary_data);
end