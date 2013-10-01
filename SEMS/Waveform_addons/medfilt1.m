function w = medfilt1(w)

%MEDFILT1: Wrapper function for applying 1-D Median Filter (Signal 
%          Processing Toolbox) to waveform data
%
%USAGE: w = medfilt1(w)
%
%INPUTS: w = unfiltered waveform
%        
%OUTPUTS: w = filtered waveform

for n=1:numel(w)
    s = get(w(n),'start');
    d = get(w(n),'data');
    d = medfilt1(d,10);
    w(n) = set(w(n),'data',d);
    w(n) = set(w(n),'start',s);
end