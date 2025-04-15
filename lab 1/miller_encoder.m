function output = miller_encoder(data,fp,Rb)
%generacja kodu RZ

%data - dane binarne
%fp   - częstotliwość próbkowania w systemie  
%Rb   - prędkość transmisji bit/s

%COPYRIGHT by Grzegorz Dziwoki


k=fp/Rb; % wynikowo współczynnik interpolacji czyli liczba próbke sygnału na jeden bit informacji (dobierać aby stsounek był liczbą całkowitą i parzystą)
x1=repmat(data,2,1)'; % powielenie o dwa,  

data_before=0;
state_before=0;

for i=1:length(x1)
    x2(i,1)=or(and(not(x1(i,1)),not(xor(data_before,state_before))),and(x1(i,1),state_before));
    x2(i,2)=or(and(not(x1(i,1)),not(xor(data_before,state_before))),and(x1(i,1),not(state_before)));
    data_before=x1(i,1);
    state_before=x2(i,2);
end
x2=x2';

shaping_filter=[ones(k/2,1)]; %filtr kształtujący reprezentujący sygnał nrz
data=x2(:)'; %wektor wierszowy danych
data_bit=2*data-1; %ustalanie poziomów "1" -> 1,  "0" -> -1 (impulsy pobudzające filtr)
data_int_zero_mtx=[data_bit;zeros(k/2-1,length(data))]; %wypełnianie zerami, pierwszy etap interpolacji
data_int_zero=data_int_zero_mtx(:);    
output=filter(shaping_filter,1,data_int_zero); %kształtowanie
end