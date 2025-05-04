function [qamSymbol_out, qamSymbol_ref, binaryData]=qam_symbol_generator(N,SNR)


binaryData=randi(0:1,4*N,1);                      %generacja wektora danych binarnych o długości 4*N 
binaryData_mtx=reshape(binaryData,4,[])';       %przekształcenie w macierz, kolejne wiersze to binarna reprezentacja symboli QAM 
decimalData=bi2de(binaryData_mtx,'left-msb');          %zamiana każdego z wierszy na wartości dziesiętne
qamSymbol_ref = qammod(decimalData, 16,'UnitAveragePower', true); %generacja symboli QAM
qamSymbol_out=awgn(qamSymbol_ref,SNR,'measured'); %dodanie szumu
end