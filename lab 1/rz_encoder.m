function output = rz_encoder(data,fp,Rb)
%generacja kodu RZ

%data - dane binarne
%fp   - częstotliwość próbkowania w systemie  
%Rb   - prędkość transmisji bit/s

%COPYRIGHT by Grzegorz Dziwoki

k=fp/Rb; % wynikowo współczynnik interpolacji czyli liczba próbke sygnału na jeden bit informacji (dobierać aby stsounek był liczbą całkowitą i parzystą)
shaping_filter=[ones(k/2,1);zeros(k/2,1)]; %filtr kształtujący reprezentujący sygnał nrz
data=data(:)'; %wektor wierszowy danych
data_bit=2*data-1; %ustalanie poziomów "1" -> 1,  "0" -> -1 (impulsy pobudzające filtr)
data_int_zero_mtx=[data_bit;zeros(k-1,length(data))]; %wypełnianie zerami, pierwszy etap interpolacji
data_int_zero=data_int_zero_mtx(:);    
output=filter(shaping_filter,1,data_int_zero); %kształtowanie

end