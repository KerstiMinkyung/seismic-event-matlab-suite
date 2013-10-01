
%% MAKE THE FILE STRUCTURE
main = 'C:\Work\McVCO_Test_Cycles';
cd(main)
host = 'pubavo1.wr.usgs.gov';
port = 16022;
ds = datasource('winston',host,port);
success = [];
for n = 1:numel(sp_scnl)
   s = sp_scnl{n};
   k = strfind(s, ':');
   sta = s(1:k-1);
   cha = s(k+1:end);
   folder = [sta,'_',cha];
   if exist(fullfile(main,folder))~=7
      mkdir(fullfile(main,folder))
      clear folder
   end
   scnl = scnlobject(sta,cha,'AV');
   w = get_w(ds,scnl,now-.5,now);
   m = 1;
   X = [];
   done = 0;
   tmpamp = 0;
   while done == 0
      clear ssr resp bvl amp
      [sst resp bvl amp] = decode_mcvco(w,'sst','resp','bvl','amp');
      if isnan(sst)
         done = 1;
      else
         if amp > tmpamp
            tmpsst = sst;
            tmpresp = resp;
            tmpbvl = bvl;
            tmpamp = amp;
         end
         w = extract(w,'Time',tmpsst(2),get(w,'end'));
      end
   end
   if (done == 1) && tmpamp > 0
      X.sst = tmpsst;
      X.resp = tmpresp;
      X.bvl = tmpbvl;
      cd(fullfile(main,folder))
      save('struct.mat','X')
      disp(['Success at ',s])
      success(n) = 1;
   else
      disp(['Failure at ',s])
      success(n) = 0;
   end
   pause(5)
end

%%
main = 'C:\Work\McVCO_Test_Cycles';
cd(main)
host = 'pubavo1.wr.usgs.gov';
port = 16022;
ds = datasource('winston',host,port);
for n = 4:numel(sp_scnl)
   try
   s = sp_scnl{n};
   k = strfind(s, ':');
   sta = s(1:k-1);
   cha = s(k+1:end);
   folder = [sta,'_',cha];
   cd(fullfile(main,folder))
   load('struct.mat')
   scnl = scnlobject(sta,cha,'AV');
   notfound = 0;
   t = X.sst(end,1)-.5-5/60/24;
   while notfound < 10
      w = get_w(ds,scnl,t,t+10/60/24);
      [sst resp bvl] = decode_mcvco(w,'sst','resp','bvl');
      if ~isnan(sst)
         X.sst(end+1,:) = sst;
         t = sst(1)-.5-5/60/24;
         X.resp(end+1) = resp;
         X.bvl(end+1) = bvl;
         notfound = 0;
      else
         t = t-.5;
         notfound = notfound + 1;
      end
   end
   catch
   end
   cd(fullfile(main,folder))
   save('struct.mat','X')
end
