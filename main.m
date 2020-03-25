clc
clear
close

E = 1; % средняя энергия сигнала
k = 4; % длина кодируемой последовательности
N = 200000; % количество сообщений при моделировании

%gX = x^16+x^13+x^12+x^11+x^10+x^8+x^6+x^5+x^2+1
% gX = [1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1];

%gX = x^4+x^3+x^2+1
gX = [1, 1, 1, 0, 1];
codes = codeBook(k, gX); % формирование кодового слова

% Отношение сигнал/шум
SNRdB = -20 : -10;
PeBits = zeros (1, length(SNRdB)); % вероятность ошибки на бит
PEDs = zeros (1, length(SNRdB)); % верхняя ошибка декодирования

% Моделирование
for i = 1 : length(SNRdB)
    disp(SNRdB(i));
    SNR = 10.^(SNRdB(i)/10);
    sigma = sqrt(E / (2*SNR));
    
    % функция моделирования передачи N пакетов
    [PeBit, PED] = model(k, gX, codes, sigma, N);
    
    PeBits(1, i) = PeBit;
    PEDs(1, i) = PED;
end

% Вероятности ошибки на бит для BPSK
SNRtheor = 10.^(SNRdB/10);
PeBitstheor = qfunc(sqrt(2*SNRtheor));


% Вероятность ошибки декодирования CRC
% Верхняя граница (асимптотическая):
r = length(gX) - 1;
PEDs_asimp = (ones(1, length(SNRdB)) ./ 2).^ r;

% Точная вероятность ошибки декодирования CRC
A = A_func(codes); % Формирование множества кодовых слов веса i
d_min = min(sum(codes(2:end, :),2));
n = r + k;

PEDsExact = zeros (1, length(SNRdB));
for i = 1 : length(SNRdB)
    for j = d_min : n
        PEDsExact(1, i) = PEDsExact(1, i) + A(j + 1) * ...
            PeBitstheor(i)^j * (1 - PeBitstheor(i))^(n - j);
    end
end

% Более точная верхняя граница ошибки декодирования CRC
PEDs_asimp_2 = (2^k - 1).*PeBitstheor.^d_min;

figure();
axis('square');
semilogy(SNRdB, PeBits, 'b.-', SNRdB, PeBitstheor, 'r-');
xlabel('SNRdB'); 
ylabel('PeBit');
legend ({'Практическое значение вероятности ошибки на бит', ...
    'Теоретическое значение вероятности ошибки на бит'}, ...
'Location','southwest')

figure();
axis('square');
hold on
semilogy(SNRdB, PEDs, 'b+-');
semilogy(SNRdB, PEDs_asimp, 'r.-');
semilogy(SNRdB, PEDsExact, 'cx-');
semilogy(SNRdB, PEDs_asimp_2, 'm--');
xlabel('SNRdB'); 
ylabel('PED');

legend({'Практическое значение вероятности ошибки декодера', ...
    'Асимптотическая верхняя граница вероятности ошибки декодера', ...
    'Точное значение вероятности ошибки декодера', ...
    'Более точная верхняя граница вероятности ошибки декодера'},...
'Location','east')
