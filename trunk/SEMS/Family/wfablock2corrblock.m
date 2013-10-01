function log = wfablock2corrblock(log)

%WFABLOCK2CORRBLOCK: Take daily blocks of waveforms and correlate them and
%stuff
%
%USAGE: log = wfablock2corrblock(log)
%
%INPUTS:  log
%
%OUTPUTS: log

for n = 1:numel(log.scnl)
   wb_dir = fullfile(log.root,get(log.scnl(n),'station'),'wfa_block');
   cb_dir = fullfile(log.root,get(log.scnl(n),'station'),'corr_block');
   range = [1 log.blockcnt(n)];
   corr_int = [1 8];
   if range(1) == range(2)
      m = range(1);
      cd(wb_dir)
      load(['WFA_BLOCK_',num2str(m,'%03.0f'),'.mat'])
      wfa = remove_empty(wfa);
      wfa = fillgaps(wfa,0);
      c = correlation(wfa);
      c = set(c,'trig',get(c,'start'));
      c = taper(c);
      c = butter(c,[1 10]);
      c = xcorr(c,corr_int);
      c = sort(c);
      c = linkage2(c);
      cd(cb_dir)
      save(['CORR_BLOCK_',num2str(m,'%03.0f'),'.mat'],'c')
   elseif range(1)<range(2)
      b1 = waveform();
      for m = range(1):range(2)-1
         cd(wb_dir)
         if isempty(b1)
            load(['WFA_BLOCK_',num2str(m,'%03.0f'),'.mat'])
            b1 = wfa;
            load(['WFA_BLOCK_',num2str(m+1,'%03.0f'),'.mat'])
            b2 = wfa;
         else
            b1 = b2;
            load(['WFA_BLOCK_',num2str(m+1,'%03.0f'),'.mat'])
            b2 = wfa;
         end
         b12 = [b1; b2];
         b12 = remove_empty(b12);
         b12 = fillgaps(b12,0);
         c = correlation(b12);
         c = set(c,'trig',get(c,'start'));
         c = taper(c);
         c = butter(c,[1 10]);
         c = xcorr(c,corr_int);
         c = sort(c);
         c = linkage2(c);
         cd(cb_dir)
         save(['CORR_BLOCK_',num2str(m,'%03.0f'),'.mat'],'c')
      end
   end
end

