function w = zero2nan(w,l)

for nw = 1:numel(w)
   dat = get(w(nw),'data');
   z_cnt = 0; % zero count
   flag = 0;  % filled beginning of gap?
   for n = 1:length(dat)
      if abs(dat(n)) < 0.1,
         z_cnt = z_cnt+1;
         if z_cnt > l
            if flag == 0
               dat(n-l:n-1)=NaN;
               flag = 1;
            end
            dat(n) = NaN;
         end
      else
         z_cnt = 0;
         flag = 0;
      end
   end

   w(nw) = set(w(nw),'data',dat);
end