function w = get_red_w(grp,t1,t2,f)

%GET_RED_W: Quick function for grabbing waveform data from Redoubt stations
%
%USAGE: w = get_red_w(in,t1,t2,f)
%
%INPUTS:  grp - defines group of channels to be converted into scnl object
%         t1  - start time
%         t2  - end time
%         f   - bandpass filter [1 20]? if so, enter 1, else f = 0

%% INITIALIZE VARIABLES
[t1 t2] = chk_t('num',t1,t2);
if t2<t1
   temp = t1;
   t1 = t2;
   t2 = temp;
end
scnl = get_scnl(grp);
host = 'avowinston01.wr.usgs.gov';
%host = 'avovalve01.wr.usgs.gov';
port = 16022;
ds = datasource('winston',host,port);
w = [];

%% DEAL WITH REQUESTS FOR BIG WAVEFORMS
dur = t2-t1;
t_n = floor(dur/0.5);    % Number of full 12 hour blocks
t_r =  rem(dur,0.5);     % Remaining time after last block
if t_n == 0
   w = waveform(ds,scnl,t1,t2);
else
   for n = 1:t_n
      t_1 = t1 + .5*(n-1);
      t_2 = t1 + .5*n;
      w = [w; waveform(ds,scnl,t_1,t_2)];
   end
   if t_r > 0
      w = [w; waveform(ds,scnl,t_2,t2)];
   end
end
w = combine(w);

%% FILTER W IF INPUT 'f' = 1
if f==1
   f_bp = filterobject('B',[1,15],2);   % 2 pole band-pass butterworth
   for n = 1:numel(w)
      w(n) = filtfilt(f_bp,w(n));
   end
end

%% RETURN PROPER SCNL ARGUMENT
function scnl = get_scnl(grp)

switch lower(grp)
   case 'rdwb'
      scnl = scnlobject('RDWB',{'BHZ','BHE','BHN'},'AV');
   case 'rdwb:bhz'
      scnl = scnlobject('RDWB','BHZ','AV');   
   case 'rdwb:bhe'
      scnl = scnlobject('RDWB','BHE','AV');   
   case 'rdwb:bhn'
      scnl = scnlobject('RDWB','BHN','AV');         
   case 'rdw'
      scnl = scnlobject('RDW',{'BHZ','BHE','BHN'},'AV');
   case 'rdw:bhz'
      scnl = scnlobject('RDW','BHZ','AV');      
   case 'rdw:bhe'
      scnl = scnlobject('RDW','BHE','AV');  
   case 'rdw:bhn'
      scnl = scnlobject('RDW','BHN','AV');        
   case 'rdjh'
      scnl = scnlobject('RDJH',{'BHZ','BHE','BHN'},'AV');   
   case 'rdjh:bhz'
      scnl = scnlobject('RDJH','BHZ','AV'); 
   case 'rd01'
      scnl = scnlobject('RD01',{'BHZ','BHE','BHN'},'AV');
   case 'rd01:bhz'
      scnl = scnlobject('RD01','BHZ','AV');      
   case 'rd01:bhe'
      scnl = scnlobject('RD01','BHE','AV');      
   case 'rd01:bhn'
      scnl = scnlobject('RD01','BHN','AV');            
   case 'rd02'
      scnl = scnlobject('RD02',{'BHZ','BHE','BHN'},'AV');
   case 'rd02:bhz'
      scnl = scnlobject('RD02','BHZ','AV'); 
   case 'rd02:bhe'
      scnl = scnlobject('RD02','BHE','AV'); 
   case 'rd02:bhn'
      scnl = scnlobject('RD02','BHN','AV');       
   case 'rd03'
      scnl = scnlobject('RD03',{'BHZ','BHE','BHN'},'AV');
   case 'rd03:bhz'
      scnl = scnlobject('RD03','BHZ','AV');       
   case 'rd03:bhe'
      scnl = scnlobject('RD03','BHE','AV'); 
   case 'rd03:bhn'
      scnl = scnlobject('RD03','BHN','AV');        
   case 'ref'
      scnl = scnlobject('REF',{'EHZ','EHE','EHN'},'AV');
   case 'ref:ehz'
      scnl = scnlobject('REF','EHZ','AV');
   case 'ref:ehe'
      scnl = scnlobject('REF','EHE','AV');
   case 'ref:ehn'
      scnl = scnlobject('REF','EHN','AV');      
   case 'red'
      scnl = scnlobject('RED',{'EHZ','EHE','EHN'},'AV');
   case 'red:ehz'
      scnl = scnlobject('RED','EHZ','AV');      
   case 'dfr'
      scnl = scnlobject('DFR','EHZ','AV');
   case 'nct'
      scnl = scnlobject('NCT','EHZ','AV');
   case 'rddr'
      scnl = scnlobject('RDDR','EHZ','AV');
   case 'rde'
      scnl = scnlobject('RDE','EHZ','AV');
   case 'rdn'
      scnl = scnlobject('RDN','EHZ','AV');
   case 'rdt'
      scnl = scnlobject('RDT','EHZ','AV');
   case 'rso'
      scnl = scnlobject('RSO','EHZ','AV');
   case {'all','available','everything','any'}
      s1 = scnlobject('RDWB',{'BHZ','BHE','BHN'},'AV');
      s2 = scnlobject('RDW',{'BHZ','BHE','BHN'},'AV');
      s3 = scnlobject('RDJH',{'BHZ','BHE','BHN'},'AV');
      s4 = scnlobject('RD01',{'BHZ','BHE','BHN'},'AV');
      s5 = scnlobject('RD02',{'BHZ','BHE','BHN'},'AV');
      s6 = scnlobject('RD03',{'BHZ','BHE','BHN'},'AV');
      s7 = scnlobject('REF',{'EHZ','EHE','EHN'},'AV');
      s8 = scnlobject('RED',{'EHZ','EHE','EHN'},'AV');
      s9 = scnlobject('DFR','EHZ','AV');
      s10 = scnlobject('NCT','EHZ','AV');
      s11 = scnlobject('RDDR','EHZ','AV');
      s12 = scnlobject('RDE','EHZ','AV');
      s13 = scnlobject('RDN','EHZ','AV');
      s14 = scnlobject('RDT','EHZ','AV');
      s15 = scnlobject('RSO','EHZ','AV');
      scnl = [s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15];
   case {'sp','short','short_period','shortperiod'}
      s1 = scnlobject('REF',{'EHZ','EHE','EHN'},'AV');
      s2 = scnlobject('RED',{'EHZ','EHE','EHN'},'AV');
      s3 = scnlobject('DFR','EHZ','AV');
      s4 = scnlobject('NCT','EHZ','AV');
      s5 = scnlobject('RDDR','EHZ','AV');
      s6 = scnlobject('RDE','EHZ','AV');
      s7 = scnlobject('RDN','EHZ','AV');
      s8 = scnlobject('RDT','EHZ','AV');
      s9 = scnlobject('RSO','EHZ','AV');
      scnl = [s1 s2 s3 s4 s5 s6 s7 s8 s9];
   case {'bb','broad','broadband','broad-band','broad_band'}
      s1 = scnlobject('RDWB',{'BHZ','BHE','BHN'},'AV');
      s2 = scnlobject('RDW',{'BHZ','BHE','BHN'},'AV');
      s3 = scnlobject('RDJH',{'BHZ','BHE','BHN'},'AV');
      s4 = scnlobject('RD01',{'BHZ','BHE','BHN'},'AV');
      s5 = scnlobject('RD02',{'BHZ','BHE','BHN'},'AV');
      s6 = scnlobject('RD03',{'BHZ','BHE','BHN'},'AV');
      scnl = [s1 s2 s3 s4 s5 s6];
   case {'3','triple','3axis','three','3component','threecomp','threeaxis'}
      s1 = scnlobject('RDWB',{'BHZ','BHE','BHN'},'AV');
      s2 = scnlobject('RDW',{'BHZ','BHE','BHN'},'AV');
      s3 = scnlobject('RDJH',{'BHZ','BHE','BHN'},'AV');
      s4 = scnlobject('RD01',{'BHZ','BHE','BHN'},'AV');
      s5 = scnlobject('RD02',{'BHZ','BHE','BHN'},'AV');
      s6 = scnlobject('RD03',{'BHZ','BHE','BHN'},'AV');
      s7 = scnlobject('REF',{'EHZ','EHE','EHN'},'AV');
      s8 = scnlobject('RED',{'EHZ','EHE','EHN'},'AV');
      s9 = scnlobject('REF',{'EHZ','EHE','EHN'},'AV');
      s10 = scnlobject('RED',{'EHZ','EHE','EHN'},'AV');
      scnl = [s1 s2 s3 s4 s5 s6 s7 s8 s9 s10];
   case {'z','vert','vertical'}
      s7 = scnlobject('REF','EHZ','AV');
      s1 = scnlobject('RDWB','BHZ','AV');
      s2 = scnlobject('RDW','BHZ','AV');
      s3 = scnlobject('RDJH','BHZ','AV');
      s4 = scnlobject('RD01','BHZ','AV');
      s5 = scnlobject('RD02','BHZ','AV');
      s6 = scnlobject('RD03','BHZ','AV');
      
      s8 = scnlobject('RED','EHZ','AV');
      s9 = scnlobject('DFR','EHZ','AV');
      s10 = scnlobject('NCT','EHZ','AV');
      s11 = scnlobject('RDDR','EHZ','AV');
      s12 = scnlobject('RDE','EHZ','AV');
      s13 = scnlobject('RDN','EHZ','AV');
      s14 = scnlobject('RDT','EHZ','AV');
      s15 = scnlobject('RSO','EHZ','AV');
      scnl = [s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 s12 s13 s14 s15];
   case{'e','east'}
      s1 = scnlobject('RDWB','BHE','AV');
      s2 = scnlobject('RDW','BHE','AV');
      s3 = scnlobject('RDJH','BHE','AV');
      s4 = scnlobject('RD01','BHE','AV');
      s5 = scnlobject('RD02','BHE','AV');
      s6 = scnlobject('RD03','BHE','AV');
      s7 = scnlobject('REF','EHE','AV');
      s8 = scnlobject('RED','EHE','AV');
   case{'n','north'}
      s1 = scnlobject('RDWB','BHN','AV');
      s2 = scnlobject('RDW','BHN','AV');
      s3 = scnlobject('RDJH','BHN','AV');
      s4 = scnlobject('RD01','BHN','AV');
      s5 = scnlobject('RD02','BHN','AV');
      s6 = scnlobject('RD03','BHN','AV');
      s7 = scnlobject('REF','EHN','AV');
      s8 = scnlobject('RED','EHN','AV');
   otherwise
      error('SCNL type not recognized')
end





