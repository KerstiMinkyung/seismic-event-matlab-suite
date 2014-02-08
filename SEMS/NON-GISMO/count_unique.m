function [val cnt] = count_unique(A)

val = unique(A);
cnt = [];
for n =1:numel(val)
   cnt(n) = sum(A == val(n));
end

