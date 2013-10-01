function log = wfa_day2block(log)

%WFA_DAY2BLOCK: Take daily waveform event detection arrays and convert them 
%   to blocks of the same size. --> i.e. consider 1 week of daily event 
%   waveforms: D1 (120 events)
%              D2 (210 events)
%              D3 (180 events)
%              D4 (140 events)
%              D5 (160 events)
%              D6 (220 events)
%              D7 (150 events)
%
%   A block size of 200 is chosen resulting in the following:
%           Block 1 (200 events)
%           Block 2 (200 events)
%           Block 3 (200 events)
%           Block 4 (200 events)
%           Block 5 (200 events)
%           Block 6 (180 events)
%
%USAGE: wfa_day2block(log)
%
%INPUTS:  log
%
%OUTPUTS: log

%% CHECK d1 AND d2 INPUTS

cur_dir = cd; % save original directory
try
for n = 1:numel(log.scnl)
   day_dir = fullfile(log.root,get(log.scnl(n),'station'),'wfa_day');
   block_dir = fullfile(log.root,get(log.scnl(n),'station'),'wfa_block');
   blocksize = log.blocksize;
   W = [];
   block_n = 1;
   
   for day = log.start:log.end
      cd(day_dir)
      try
         load([datestr(day,29),'.mat'],'wfa_day')
      catch
         wfa_day = [];
      end
      if ~isempty(wfa_day)
         k = numel(wfa_day);
         W = [W; reshape(wfa_day,k,1)];
         while numel(W) >= blocksize
            cd(block_dir)
            wfa_block = W(1:blocksize);
            save(['WFA_BLOCK_',num2str(block_n,'%03.0f'),'.mat'],'wfa_block')
            log.blockcnt(n) = block_n;
            W(1:blocksize) = [];
            block_n = block_n + 1;
         end
      end
   end

   if numel(W)> 0 % Residual
      cd(block_dir)
      wfa_block = W;
      save(['WFA_BLOCK_',num2str(block_n,'%03.0f'),'.mat'],'wfa_block')
   end
end
catch
   cd(log.root)
   save log
end
cd(cur_dir) % Reset to original directory

