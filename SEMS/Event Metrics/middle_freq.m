function mf = middle_freq(w)

for n=1:length(w)
   [amp freq] = pos_fft(w(n),'nfft',1024);
   c = cumsum(amp);
   [val ref] = min(abs(c-c(end)/2));
   mf(n) = freq(ref);
end