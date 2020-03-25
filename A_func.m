function A = A_func(codes)

A = zeros(1, length(codes(1, :)) + 1);

% Формирование множества кодовых слов веса i
for i = 1 : length(codes(:,1))
    weigth = sum(codes(i, :));
    A(1, weigth + 1) = A(1, weigth + 1) + 1;    
end
