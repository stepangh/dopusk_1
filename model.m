function [PeBit, PED] = model(k, gX, codes, sigma, N)

r = length(gX) - 1;
n = k + r;
K = 2^k;

PeBit = 0;
PED = 0;

for i = 1 : N
    %     Источник
    indexCode = randi([1 K],1,1);%генерация индекса код. слова
    %     CRC-r
    mX = codes(indexCode, :); % берём код. слово по индексу из код. книжки
    %     BPSK
    mS = mX.*-2 + 1;
    
    %     АБГШ
    mR = mS + sigma * randn(1, n);
    
    %     BPSK ^-1
    mX_ = mR < 0;
    %     CRC-r ^-1
    flag_sum = sum(xor(mX_, mX)); 
    
    PED = PED + (flag_sum > 0 & sum(modGx(mX_, gX)) == 0); 
    
    PeBit = PeBit + flag_sum; % количество ошибок в код слове
end

PeBit = PeBit / N / n;
PED = PED / N;