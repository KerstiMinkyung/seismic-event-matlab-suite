
%% STA/LTA ILW

clear w E
f = fullfile('C:','Work','Iliamna','Single_Station_Detection');
cd(f);
scnl = scnlobject('ILW','EHZ','AV');
host = 'avowinston01.wr.usgs.gov';
%host = 'pubavo1.wr.usgs.gov';
port = 16022;
ds = datasource('winston',host,port);
t_start = datenum([2012 1 1 0 0 0]);
t_end = datenum([2012 6 30 0 0 0]);
edp = [1 8 2.2 1.6 3 1.5 0 0];
for day = t_start:t_end % Range to detect
   try
      disp('fetching waveform')
      w = get_w(ds,scnl,day,day+1,'bp',[1 10]);
      
      disp('detecting events')
      E.wfa = sta_lta(w,'edp',edp,'lta_mode','frozen','return','wfa');
      disp('computing metrics')
      E.rms = rms(E.wfa);
      E.pa = peak_amp(E.wfa,'val');
      E.p2p = peak2peak_amp(E.wfa,'val');
      E.pf = peak_freq(E.wfa,'val');
      E.fi = freq_index(E.wfa,[1 3],[8 15],'val');
      E.mf = middle_freq(E.wfa,'val');

      disp('saving structure')
      cd(fullfile(f,'ILW','Event_Structure'))
      save([datestr(day,29),'.mat'],'E')

%     load(fullfile(f,'ILW','Event_Structure',datestr(day,29)));
      disp('building helicorder')
      fh = build(helicorder(w,'mpl',30,'e_sst',wfa2sst(E.wfa)));
      set(fh,'PaperType','A','PaperOrientation','portrait',...
      'PaperUnits','normalized','PaperPosition',[0,0,1,1])
      print(fh, '-dpng', fullfile(f,'ILW','Helicorder',datestr(day,29))) 
      close(fh)
      clear E w

   catch
   end
end

%%
coverage = [];
f = fullfile('C:','Work','Iliamna','Single_Station_Detection');
t_start = datenum([2005 11 1 0 0 0]);
t_end = datenum([2012 2 20 0 0 0]);
for day = t_start:t_end % Range to detect
    if exist(fullfile(f,'ILW','Event_Structure',[datestr(day,29),'.mat']),'file')
        coverage = [coverage; day, 1];
    else
        coverage = [coverage; day, 0];
    end
end
    
    


