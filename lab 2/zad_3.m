clear; close all;

clear; close all;

%% Przykładowe dane

P=3;          %Moc konstelacji
B=40000;    % liczba bitów informacyjnych
Rs=30;      %prędkość symbolowa
fp=120;      %próbkowanie
N_fft=4096; %rozmiar FFT
M=6;      %ilość odstępów międzysymbolowych
A=0.4; %współczynnik przekroczenia pasma


%% a)	

N=fp/Rs;  % parametr charakteryzujący nadpóbkowanie. a także ilość filtrów 
n=0:N-1;  % wektor indeksów współczynników odpowiedzi impulsowej
k=(0:N-1)'; %wektor indeksów kolejnych częstotliwości znormalizowanych 

hc=cos(2*pi*k*n/N);  %kolejne wiersze to fltry kształtujące na kolejnych podnośnych - składnik synfazowy
hs=sin(2*pi*k*n/N);  %kolejne wiersze to fltry kształtujące na kolejnych podnośnych - składnik kwadraturowy
h=hc+1i*hs;       %filtr zespolony

abs_H=abs(fft(h,N_fft));  %wyznaczenie charakterystyk amplitudowych
f=(0:N_fft-1)*fp/N_fft;  % oś częstotliwości

figure(1)
plot(f,abs_H)   %wyświetlenie ch-k amplitudowych



%% b) 

binaryData=randi(0:1,B,1);                  %generacja danych binarnych
binaryData_mtx=reshape(binaryData,4,[])';   %generacja macierzy, symbole wierszami w zapisie binarnym
decimalData=bi2de(binaryData_mtx);              %zamiana na wartości dziesiętne
sps=N;
qamSymbols = qammod(decimalData, 16,'UnitAveragePower', true)*sqrt(P); %generacja symboli QAM

qamSymbols_mtx=reshape(qamSymbols,N,[]); %rozdział na tory

% interpolacja poszczególnych torów

for i=1:N
    tym=[qamSymbols_mtx(i,:);zeros(N-1,length(qamSymbols_mtx(i,:)))];
    qamSymbols_int_mtx(i,:)=tym(1:end);
end


% filtracja poszczególnych torów

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% UZUPEŁNIĆ
for i=1:N
out_mtx(i,:)=filter(h(i,:),1,qamSymbols_int_mtx(i,:));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%sumowanie torów
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% UZUPEŁNIĆ
yb=sum(out_mtx);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%yb=0 % wartoś tymczasowa do usunęcia po dokonaniu uzupełnień

%wyświetlenie
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% UZUPEŁNIĆ
figure(2)
t=0:1/fp:(B/4/N)/Rs-1/fp;
subplot(2,1,1)
plot(t,real(yb));
xlim([0,10/Rs]);
subplot(2,1,2)
plot(t,imag(yb));
xlim([0,10/Rs]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% c)	
F=1  %dobrać właściwe
SYM_FFT=F*ifft(qamSymbols_mtx);
yc=SYM_FFT(1:end);

%wyświetlenie
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% UZUPEŁNIĆ
figure(2)
t=0:1/fp:(B/4/N)/Rs-1/fp;
subplot(2,1,1)
hold on;
plot(t,real(yc));
xlim([0,10/Rs]);
subplot(2,1,2)
hold on;
plot(t,imag(yc));
xlim([0,10/Rs]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% błąd
error=mean(abs(yb-yc).^2);


%% d) 
L=ceil(N/4);

SYM_OFDM=[SYM_FFT(end-L+1:end,:);SYM_FFT];
yd=SYM_OFDM(:);

%wyświetlenie
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% UZUPEŁNIĆ
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%







