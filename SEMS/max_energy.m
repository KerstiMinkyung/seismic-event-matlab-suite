function max_w = max_energy(w,win_l)
%
%MAX_ENERGY: Extract the most energetic 'abs(demean(amplitude))' portion of
%   a waveform or waveform array
%
%USAGE: max_w = max_energy(w,win_l)
%
%INPUTS: w - waveform object
%        win_l - window length 
%
%OUTPUTS: max_win - maximum energy window start/stop times

nw = numel(w);
w = demean(w);
for n = 1:nw
   dat = abs(get(w(n),'data'));
   dat_l = get(w(n),'data_length');
   Fs = get(w(n),'freq');
   t1 = 1;
   t2 = round(win_l*Fs);
   win_n = 1;

   if t2<dat_l
      while t2<dat_l
         sum_win(win_n) = sum(dat(t1:t2));
         t1 = t1+1;
         t2 = t2+1;
         win_n = win_n+1;
      end
      [M I] = max(sum_win);
      max_w(n) = extract(w(n),'index',I,I+floor(win_l*Fs)-1);
      clear sum_win
   else
      max_w(n) = w(n);
   end
end

