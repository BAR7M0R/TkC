clc; clear; close all;
load("graphic_1.mat");

signal_mtx=reshape(ofdm_signal,N+CP,[]); % macierz symboli OFDM w dziedzinie czasu (dane + CP)
signal_freq=fft(signal_mtx(CP+1:end,:)); % transformacja na stronę częstotliwościową fft
symbols_QAM=signal_freq(:); % przekształcenie symboli QAM na wektor
scatterplot(symbols_QAM);


signal_freq=signal_freq.*1./fft(channel_IR,N).';
symbols_QAM=signal_freq(:); 
scatterplot(symbols_QAM);

LLR_receive=qamdemod(symbols_QAM,16,'UnitAveragePower',true,'OutputType','llr','NoiseVariance',10^(-14/10));
binary_receive=qamdemod(symbols_QAM,16,'UnitAveragePower',true,'OutputType','bit');
binary_LLR=(-sign(LLR_receive)+1)/2;
binary_LLR= binary_LLR(1:(512*512*8*3));
binary_receive =binary_receive(1:(512*512*8*3));
graphic_decoder(binary_LLR);
graphic_decoder(binary_receive);