function wout = clone(win,scnl)
% Clone wfa times from different scnl

if iscell(scnl) && numel(scnl)==1 && ischar(scnl{1})
   scnl = scnl{1};
end
if ischar(scnl)
   for m=1:numel(win)
      if rem(m,100)==0, pause(2), end
      wout(1,m) = get_red_w(scnl,get(win(m),'start'),get(win(m),'end'),0);
   end
elseif iscell && numel(scnl)>1
   for n=1:numel(scnl)
      for m=1:numel(win)
         if rem(m,100)==0, pause(2), end
         wout{n}(1,m) = get_red_w(scnl,get(win(m),'start'),get(win(m),'end'),0);
      end
   end
end
