function avail = attempt_avail(avail,d,i)
% For use with get_red_avail script or existing avail structure
w = get_red_w('z',d,d+i,0);
   for n = 1:numel(w)
      switch lower(get(w(n),'station'))
         case 'ref'
            avail.sst{1} = [avail.sst{1}; get(w(n),'start') get(w(n),'end')];
         case 'rdwb'
            avail.sst{2} = [avail.sst{2}; get(w(n),'start') get(w(n),'end')];
         case 'rdw'
            avail.sst{3} = [avail.sst{3}; get(w(n),'start') get(w(n),'end')];
         case 'rdjh' 
            avail.sst{4} = [avail.sst{4}; get(w(n),'start') get(w(n),'end')];
         case 'rd01'
            avail.sst{5} = [avail.sst{5}; get(w(n),'start') get(w(n),'end')];
         case 'rd02'
            avail.sst{6} = [avail.sst{6}; get(w(n),'start') get(w(n),'end')];
         case 'rd03'
            avail.sst{7} = [avail.sst{7}; get(w(n),'start') get(w(n),'end')];
         case 'red' 
            avail.sst{8} = [avail.sst{8}; get(w(n),'start') get(w(n),'end')];
         case 'dfr' 
            avail.sst{9} = [avail.sst{9}; get(w(n),'start') get(w(n),'end')];
         case 'nct' 
            avail.sst{10} = [avail.sst{10}; get(w(n),'start') get(w(n),'end')];
         case 'rddr' 
            avail.sst{11} = [avail.sst{11}; get(w(n),'start') get(w(n),'end')];
         case 'rde' 
            avail.sst{12} = [avail.sst{12}; get(w(n),'start') get(w(n),'end')];
         case 'rdn'  
            avail.sst{13} = [avail.sst{13}; get(w(n),'start') get(w(n),'end')];
         case 'rdt' 
            avail.sst{14} = [avail.sst{14}; get(w(n),'start') get(w(n),'end')];
         case 'rso'
            avail.sst{15} = [avail.sst{15}; get(w(n),'start') get(w(n),'end')];
      end
   end
end