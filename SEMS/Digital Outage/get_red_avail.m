% get_red_avail
% Purpose of script is to open hour-long blocks of all vertical component
% data and record the start/stop times of each block. If a waveform is not
% available, the entire block of time is recorded as unavailable. 
% 
% d1 is start time (matlab datenum)
% d2 is end time (matlab datenum)


%% Initialization of station availability structure
d1 = datenum([2009 01 01 0 0 0]);
d2 = datenum([2009 12 31 0 0 0]);
avail.sta = {'REF','RDWB','RDW','RDJH','RD01','RD02','RD03','RED',...
             'DFR','NCT','RDDR','RDE','RDN','RDT','RSO'};
avail.sst = {[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]};
          

%% Loop over all blocks to find where data does/doen't exist
%% Note: Pauses are used becauses I kept overwhelming wave server

i = 1/24 % Increment time (decimal days)
for d = d1:i:d2
   try
      avail = attempt_avail(avail,d,i);
   catch
      pause(15)
      try
         avail = attempt_avail(avail,d,i);
      catch
         pause(30)
         try
            avail = attempt_avail(avail,d,i);
         catch
            pause(60)
            try
               avail = attempt_avail(avail,d,i);
            catch
            end
         end
      end
   end
end

%% Merge all blocks separated by N seconds or less
N = 60*60; % (Seconds) If gap in time is less than 1 hour, merge together
avail.sst{1} = merge_sst(avail.sst{1},N);
avail.sst{2} = merge_sst(avail.sst{2},N);
avail.sst{3} = merge_sst(avail.sst{3},N);
avail.sst{4} = merge_sst(avail.sst{4},N);
avail.sst{5} = merge_sst(avail.sst{5},N);
avail.sst{6} = merge_sst(avail.sst{6},N);
avail.sst{7} = merge_sst(avail.sst{7},N);
avail.sst{8} = merge_sst(avail.sst{8},N);
avail.sst{9} = merge_sst(avail.sst{9},N);
avail.sst{10} = merge_sst(avail.sst{10},N);
avail.sst{11} = merge_sst(avail.sst{11},N);
avail.sst{12} = merge_sst(avail.sst{12},N);
avail.sst{13} = merge_sst(avail.sst{13},N);
avail.sst{14} = merge_sst(avail.sst{14},N);
avail.sst{15} = merge_sst(avail.sst{15},N);




