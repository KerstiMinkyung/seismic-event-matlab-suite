function n_sst = get_n_sst(n_sst,d)

% r_sst better be sorted!
d = datenum(d);
t1 = d;
t2 = d+1/24;
w = get_red_w('ref:ehz',t1,t2,1);
sub_sst = extract_sst(n_sst,t1,t2);
if ~isempty(sub_sst)
   sub_sst = event_pick(w,'sst',sub_sst);
else
   sub_sst = event_pick(w);
end

n_sst = add_sst(n_sst,sub_sst{:},'merge');


