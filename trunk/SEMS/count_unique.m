function [val cnt] = count_unique(A)

val = unique(A);
for n =1:numel(val)
   cnt(n) = sum(A == val(n));
end

