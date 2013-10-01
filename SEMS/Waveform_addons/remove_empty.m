function w = remove_empty(w)

%REMOVE_EMPTY: Remove any empty waveforms from input waveform array
%
%USAGE: w = remove_empty(w)
%
%INPUTS:  w
%
%OUTPUT: w

k = 1;
while k <= numel(w)
    if isempty(w(k))
        w(k) = [];
    else
        k = k + 1;
    end
end