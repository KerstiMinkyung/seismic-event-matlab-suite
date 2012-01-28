function [spike_flag, max_amp, skip_interval, nspikes] = spike_check(absdata,i,datalength,stationcal,Fs)
% Check trigger for possible glitchiness. Default assumption: 
% trigger is not a glitch (trig_flag = spike_flag = 1)
% Program looks test_secs ahead & computes RMS ratios to detect glitches.

test_secs = 6;               
skip_interval = 6;
test_counts = test_secs * Fs;
spike_flag = 1;

% First test; glitches will have wiggle amplitudes > 650 * scale counts
max_amp = 0;
nspikes = 0;
for j=i:1:i+test_counts
   if (j <= datalength)
      if (absdata(j) > max_amp)
	     max_amp = absdata(j);
      end
      if (absdata(j) > 650 * stationcal) % Any trigger w/ amplitude BELOW this number will be considered an event.
	     nspikes = nspikes + 1;
		 spike_flag = 0;
      end
   end
end

% Second test; glitches are short (< 6 sec), so glitch rms amp for first 0.5 seconds should
% be 100 times greater than rms amp for 4.5-5 seconds after trigger.

if (spike_flag == 0 && i+test_counts < datalength)
   if (max_amp > 3000 * stationcal)  % Any trigger with amplitudes greater than X will be considered glitches
      spike_flag = 0;
   else
	  first_half_sec = 0;
	  last_half_sec = 0;
	  for j=i:1:i+50	
	     first_half_sec = first_half_sec + absdata(j);
      end
	  rms_first_half = first_half_sec / 50.;
      for j=i+test_counts-50:1:i+test_counts
	     last_half_sec = last_half_sec + absdata(j);
      end
	  rms_last_half = last_half_sec / 50.;
      
% Glitch test; if 50 counts following trigger have rms amp 4.5 times greater than 
% rms amplitude for 50-count sample at time test_counts (6 seconds) from trigger,
% then there is not an exponential decay as with normal eqs.

      if (rms_first_half/rms_last_half < 4.5)  % Not a glitch %% JP I've never changed the 4.5 values, but it could be played with
	     spike_flag = 1;
      end

	  if (nspikes > 200)  % Potential cal pulse. Cal pulses at AVO last 55 seconds, with first part
                          % lasting 10.3 sec with many spikes. So skip
                          % ahead 10.5 seconds, compute rms for next 0.5 sec and look
                          % at ratio with rms at time of triger. If ratio is
                          % large, then cal pulse (big eq would still have coda
                          % energy @ 10.5 sec, so ratio would be smaller). In
                          % this case skip ahead 20 sec instead of 6.
	     last_half_sec = 0;
         test_secs = 10.5; % JP this could be changed if cal pulses have different durations at different stations
	     test_counts = test_secs * Fs;
         if i+test_counts+50 < datalength
		    for j=i+test_counts:1:i+test_counts+50
			   last_half_sec = last_half_sec + absdata(j);
            end
		    rms_last_half = last_half_sec / 50.;
		    if (rms_first_half/rms_last_half < 25)  % Not a cal pulse
			   spike_flag = 1;
		    else  % A cal pulse
			   spike_flag = 0;
               skip_interval = 54; %% JP this could also be changed for different cal pulse lengths
            end
         else % Datalength exceeded, treat as a trigger 
            spike_flag = 1;
         end
         % fprintf('%d %d %d %f %f\n', i-1, nspikes,spike_flag,rms_first_half, rms_last_half);
      else
         spike_flag = 1;
      end
   end
end