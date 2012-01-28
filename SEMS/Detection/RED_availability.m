
% Purpose of script is to open hour-long blocks of all vertical component
% data and record the start/stop times of each block. If a waveform is not
% available, the entire block of time is recorded as unavailable. 

%% Initialization of station availability sst arrays
ref_sst = [];
rdwb_sst = [];
rdw_sst = [];
rdjh_sst = [];
rd01_sst = [];
rd02_sst = [];
rd03_sst = [];
red_sst = [];
dfr_sst = [];
nct_sst = [];
rddr_sst = [];
rde_sst = [];
rdn_sst = [];
rdt_sst = [];
rso_sst = [];

%% Loop over all blocks to find where data does/doen't exist
d1 = datenum([2009 01 01 00 00 00]);
d2 = datenum([2009 12 31 00 00 00]);
for d = d1:1/24:d2
   w = get_red_w('z',d,d+1/24,0);
   for n = 1:numel(w)
      switch lower(get(w(n),'station'))
         case 'ref'
            ref_sst = [ref_sst; get(w(n),'start') get(w(n),'end')];
         case 'rdwb'
            rdwb_sst = [rdwb_sst; get(w(n),'start') get(w(n),'end')];
         case 'rdw'
            rdw_sst = [rdw_sst; get(w(n),'start') get(w(n),'end')];
         case 'rdjh' 
            rdjh_sst = [rdjh_sst; get(w(n),'start') get(w(n),'end')];
         case 'rd01'
            rd01_sst = [rd01_sst; get(w(n),'start') get(w(n),'end')];
         case 'rd02'
            rd02_sst = [rd02_sst; get(w(n),'start') get(w(n),'end')];
         case 'rd03'
            rd03_sst = [rd03_sst; get(w(n),'start') get(w(n),'end')];
         case 'red' 
            red_sst = [red_sst; get(w(n),'start') get(w(n),'end')];
         case 'dfr' 
            dfr_sst = [dfr_sst; get(w(n),'start') get(w(n),'end')];
         case 'nct' 
            nct_sst = [nct_sst; get(w(n),'start') get(w(n),'end')];
         case 'rddr' 
            rddr_sst = [rddr_sst; get(w(n),'start') get(w(n),'end')];
         case 'rde' 
            rde_sst = [rde_sst; get(w(n),'start') get(w(n),'end')];
         case 'rdn'  
            rdn_sst = [rdn_sst; get(w(n),'start') get(w(n),'end')];
         case 'rdt' 
            rdt_sst = [rdt_sst; get(w(n),'start') get(w(n),'end')];
         case 'rso'
            rso_sst = [rso_sst; get(w(n),'start') get(w(n),'end')];
      end
   end
end

%% Merge all blocks separated by N seconds or less
N = 60; % 1 minute
ref_sst = merge_sst(ref_sst,N);
rdwb_sst = merge_sst(rdwb_sst,N);
rdw_sst = merge_sst(rdw_sst,N);
rdjh_sst = merge_sst(rdjh_sst,N);
rd01_sst = merge_sst(rd01_sst,N);
rd02_sst = merge_sst(rd02_sst,N);
rd03_sst = merge_sst(rd03_sst,N);
red_sst = merge_sst(red_sst,N);
dfr_sst = merge_sst(dfr_sst,N);
nct_sst = merge_sst(nct_sst,N);
rddr_sst = merge_sst(rddr_sst,N);
rde_sst = merge_sst(rde_sst,N);
rdn_sst = merge_sst(rdn_sst,N);
rdt_sst = merge_sst(rdt_sst,N);
rso_sst = merge_sst(rso_sst,N);

%% Use this when block detection loop throws error (increment)
% ref_sst = [ref_sst; ref_sst2];
% rdwb_sst = [rdwb_sst; rdwb_sst2];
% rdw_sst = [rdw_sst; rdw_sst2];
% rdjh_sst = [rdjh_sst; rdjh_sst2];
% rd01_sst = [rd01_sst; rd01_sst2];
% rd02_sst = [rd02_sst; rd02_sst2];
% rd03_sst = [rd03_sst; rd03_sst2];
% red_sst = [red_sst; red_sst2];
% dfr_sst = [dfr_sst; dfr_sst2];
% nct_sst = [nct_sst; nct_sst2];
% rddr_sst = [rddr_sst; rddr_sst2];
% rde_sst = [rde_sst; rde_sst2];
% rdn_sst = [rdn_sst; rdn_sst2];
% rdt_sst = [rdt_sst; rdt_sst2];
% rso_sst = [rso_sst; rso_sst2];

%%
%clear ref_sst2 rdwb_sst2 rdw_sst2 rdjh_sst2 rd01_sst2 rd02_sst2 rd03_sst2
%clear red_sst2 dfr_sst2 nct_sst2 rddr_sst2 rde_sst2 rdn_sst2 rdt_sst2 rso_sst2

%% Finally, combine all into availability structure
%avail.sta = {'ref','rdwb','rdw','rdjh','rd01','rd02','rd03','red','dfr','nct','rddr','rde','rdn','rdt','rso'};
%avail.sst = {ref_sst,rdwb_sst,rdw_sst,rdjh_sst,rd01_sst,rd02_sst,rd03_sst,red_sst,dfr_sst,nct_sst,rddr_sst,rde_sst,rdn_sst,rdt_sst,rso_sst};


