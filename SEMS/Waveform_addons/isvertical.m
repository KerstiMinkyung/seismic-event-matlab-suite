function [bool] = isvertical(W)

tmp = get(W,'channel');
if ischar(tmp)
    C{1} = tmp;
elseif iscell(tmp)
    C = tmp;
end
for n = 1:numel(C)
    bool(n) = strcmpi(strtrim(C{n}(3)),'z');
end
