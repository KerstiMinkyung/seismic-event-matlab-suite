function archive_events(sta_str,d1,d2,varargin)

edp = [1 7 2 1.6 3 1.5 0 0];
path = fullfile('C:','Work','RED_Events','STA_LTA_Daily');
n_sst = [];

for day = d1:d2 % Range to detect
   w = get_red_w(sta_str,day,day+1,1);
   w = zero2nan(w,10);
   %sub_n_sst = extract_sst(n_sst,day,day+1);
   %w = set2val(w,sub_n_sst,NaN);
   sst = sta_lta(w,'edp',ref_edp,'lta_mode','continuous');
   [rms fi pf] = sst2eventop(sst);
   save(fullfile(f,'SST_001',[datestr(day,29),'.mat']),'sst','rms','fi','pf')
   clear rms fi pf sub_n_sst
   
   w = resample(w,'median',4);
   fh = build(helicorder(w,'mpl',30,'e_sst',sst));
   set(fh,'PaperType','A','PaperOrientation','portrait',...
      'PaperUnits','normalized','PaperPosition',[0,0,1,1])
   print(fh, '-dpng', fullfile(f,'HEL_001',datestr(day,29))) 
   close(fh)
   clear fh sst w
   clc
end

