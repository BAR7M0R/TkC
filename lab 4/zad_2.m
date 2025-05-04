% Odbiór sygnałów cyfrowych - cz.2

clear; close all;

%% przykładowe dane

B=4*100000; %liczba bitów
P=1;       %moc konstelacje
N=100;     %ilość podnośnych
CP=10;     %rozmiar prefiksu
SNR=50;    %stosunek mocy sygnału do mocy szumu

%% Generacja sygnału OFDM
podpunkt='c'; %wybierz a lub b lub c

switch podpunkt %odpowiedzi impulsowe
    case 'c'
        channel_IR=[1 .2 0];
    otherwise
        channel_IR=[1 0 0];
end

% generacja sygnału OFDM
[ofdm_signal,ofdm_symbols,binary_data]=ofdm_signal_generator(B,P,N,CP,SNR,channel_IR);

switch  podpunkt

%% a) odbiór sygnału OFDM dla idealnej synchronizacji
    case 'a'
signal_mtx=reshape(ofdm_signal,N+CP,[]); % macierz symboli OFDM w dziedzinie czasu (dane + CP)
signal_without_CP=signal_mtx(CP+1:end,:); %pełne usunięcie prefiksu cyklicznego (idealna synchronizacja)
signal_freq=fft(signal_without_CP); % transformacja na stronę częstotliwościową fft
symbols_QAM=signal_freq(:); % przekształcenie symboli QAM na wektor
scatterplot(symbols_QAM);
evm=evm_measure(symbols_QAM,ofdm_symbols(:),P)

%% b) odchyłka synchronizacji
    case 'b'
L=1;  % liczba próbek
subchan=4; %numer podkanału

signal_mtx=reshape(ofdm_signal,N+CP,[]); % macierz symboli OFDM w dziedzinie czasu (dane + CP)
signal_without_CP=signal_mtx(CP+1-L:end-L,:); % wyprzedzenie odbioru / opóźnienie sygnału o L próbek
signal_freq=fft(signal_without_CP); % transformacja na stronę częstotliwościową fft
%%%%% KOMPENSACJA/KOREKCJA %%%%%
%
% UZUPEŁNIĆ
%signal_freq=signal_freq.*exp(1i*2*pi*L/N*(0:N-1)).';
%%%%
symbols_QAM=signal_freq(:);
scatterplot(symbols_QAM); % wyświetlenie wszystkich symboli
scatterplot(signal_freq(subchan,:)); %wyświetlenie symboli z wybranego podkanału
evm=evm_measure(symbols_QAM,ofdm_symbols(:),P)

%% c) kanał transmisyjny
    case 'c'
subchan=100; %numer podkanału
scatterplot(ofdm_signal)
signal_mtx=reshape(ofdm_signal,N+CP,[]); % macierz symboli OFDM w dziedzinie czasu (dane + CP)
signal_without_CP=signal_mtx(CP+1:end,:); % wyprzedzenie odbioru / opóźnienie sygnału o L próbek
signal_freq=fft(signal_without_CP); % transformacja na stronę częstotliwościową fft
%%%%% KOMPENSACJA/KOREKCJA %%%%%
%
%
% UZUPEŁNIĆ
%equ=1./fft(channel_IR,N);
%signal_freq=signal_freq.*equ.';
%%%%%
symbols_QAM=signal_freq(:);
scatterplot(symbols_QAM); % wyświetlenie wszystkich symboli %wyświetlenie symboli z wybranego podkanału
% Załóżmy, że signal_freq to macierz [100 x N]
figure;
hold on;
xlim([-2 2]); ylim([-2 2]);
xlabel('In-Phase'); ylabel('Quadrature');
grid on;

% Inicjalizacja bufora dla poprzednich punktów
prev_points = [];

for i = 1:100
    % Dodaj aktualne punkty do bufora
    prev_points = [prev_points; real(signal_freq(i,:)).', imag(signal_freq(i,:)).'];
    
    clf; % Wyczyść rysunek
    hold on;
    grid on;
    xlim([-3 3]); ylim([-3 3]);
    xlabel('In-Phase'); ylabel('Quadrature');
    title(['Subcarrier ', num2str(i)]);

    % Rysuj poprzednie punkty (bladym kolorem)
    if ~isempty(prev_points)
        scatter(prev_points(:,1), prev_points(:,2), 10, [0.5 0.5 0.5], 'filled'); % szary
    end

    % Rysuj aktualne punkty (wyraźnie)
    scatter(real(signal_freq(i,:)), imag(signal_freq(i,:)), 30, 'y', 'filled'); % żółty
    
    pause(0.2); % pauza między krokami
end
evm =evm_measure(symbols_QAM,ofdm_symbols(:),P)
end