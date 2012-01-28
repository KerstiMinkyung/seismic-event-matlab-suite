function stk = bin_stack(w,bin,ovr)

nw = numel(w);
inc = bin-ovr;
n=1;
while 1
   if (n-1)*inc+bin > nw
      return
   else
      stk(n) = stack(w((n-1)*inc+1:(n-1)*inc+bin));
      n=n+1;
   end
end
