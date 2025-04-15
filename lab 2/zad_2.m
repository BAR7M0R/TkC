clear; close all;

%% Przykładowe dane

P=2;          %Moc konstelacji
B=40000;    % liczba bitów informacyjnych
Rs=30;      %prędkość symbolowa
fp=120;      %próbkowanie
N_fft=4096; %rozmiar FFT
M=8;      %ilość odstępów międzysymbolowych
A=0.4; %współczynnik przekroczenia pasma



%% a) 

qamSymbols = qammod(0:15, 16,'UnitAveragePower', true); %generacja symboli o jednostkowej mocy
P_qam=mean(abs(qamSymbols).^2);                         %sprawdzenie mocy
qamSymbols_P=sqrt(P)*qamSymbols;                        %skalowanie do mocy docelowej
P_qam_check=mean(abs(qamSymbols_P).^2);                  %sprawdzenie mocy docelowej
scatterplot(qamSymbols_P);                              %wyświetlenie konstelacji
figure(1)
distance_qam=abs(qamSymbols_P-qamSymbols_P.');          %wyznaczanie odległości
min_distance_qam=min(distance_qam(2:end,1));            %wyznaczanie minimum odległości

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  UZUPEŁNIĆ DLA 16-PSK I 16-PAM
pamSymbols = pammod(0:15, 16);
P_pam=mean(abs(pamSymbols).^2);
pamSymbols_P= sort(P)*pamSymbols/sqrt(P_pam);
P_pam_check=mean (abs(pamSymbols_P).^2);
scatterplot(pamSymbols_P);
figure (2)
distance_pam= abs(pamSymbols_P-pamSymbols_P.');
min_distance_pam=min(distance_pam(2:end,1));

pskSymbols = pskmod (0:15, 16);
P_psk = mean(abs(pskSymbols).^2);
pskSymbols_P= sort(P)*pskSymbols/sqrt(P_psk);
P_psk_check=mean (abs(pskSymbols_P).^2);
scatterplot(pskSymbols_P);
figure (3)
distance_psk= abs(pskSymbols_P-pskSymbols_P.');
min_distance_psk=min(distance_psk(2:end,1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% b)	

binaryData=randi(0:1,B,1);                  %generacja danych binarnych
binaryData_mtx=reshape(binaryData,4,[])';   %generacja macierzy, symbole wierszami w zapisie binarnym
decimalData=bi2de(binaryData_mtx);          %zamiana na wartości dziesiętne

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%       UZUPEŁNIĆ
qamSymbols_t = qammod(decimalData, 16, 'UnitAveragePower',true)*sqrt(P);
moc_czas= mean (abs(qamSymbols_t).^2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% c) 

alpha=A;
sps=fp/Rs;
span=M;
h_RC = rcosdesign(alpha,span,sps,'normal'); %konstrukcja filtru podniesionego kosinusa
h_sqrt=rcosdesign(alpha,span,sps,'sqrt');   %konstrukcja filtru pierwiastka podniesionego cosinusa

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  UZUPEŁNIĆ INTERPOLACJĘ I TRANSMISJĘ PRZEZ FILTR KSZTAŁTUJĄCY
%
qammtx = [qamSymbols_t.' ; zeros(sps-1, length(qamSymbols_t))];
qamSymbols_int= qammtx(:);
qamSignal_RC = filter(h_RC, 1, qamSymbols_int);
qamSignal_sqrt = filter(h_sqrt,1 ,qamSymbols_int);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

eyediagram(qamSignal_RC,2*sps);     %diagram oczkowy przy filtrze podniesionego kosinusa
figure(4)
eyediagram(qamSignal_sqrt,2*sps);   %diagram oczkowy przy filtrze pierwiasta podniesionego kosinusa
figure(5)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  UZUPEŁNIĆ WYKRES WIDMOWEJ GĘSTOCI MOCY
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
