function w = get_wf(scnl,t1,t2)

%GET_WF: Quick function for grabbing waveform object
%
%USAGE: w = get_wf(scnl,t1,t2)
%
%INPUTS:  scnl - scnl object
%         t1  - start time
%         t2  - end time

%% INITIALIZE VARIABLES
[t1 t2] = chk_t('num',t1,t2);
if t2<t1
   temp = t1;
   t1 = t2;
   t2 = temp;
end
if ~isa(scnl,'scnlobject')
   error('SCNLOBJECT needed')
end
host = 'avovalve01.wr.usgs.gov';
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

