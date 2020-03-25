function codes = codeBook(k, gX)
r = length(gX) - 1; % длина избыточной части CRC
n = k + r; % длина кодового слова

R = 2^r; % количество кодовых слов
K = 2^k; % количество векторов ошибок

codes = zeros(K, n);

% кодирование 
for m = 0 : K - 1
   m_xK = de2bi(m*R, n);
   m_xK = m_xK(end:-1:1); %мл.б на свое место
   
   codes(m + 1, :) = xor(m_xK, modGx(m_xK, gX));
end
