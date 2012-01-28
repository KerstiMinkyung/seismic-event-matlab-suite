function varargout = cal_pulse(wave,varargin)
%
%CAL_PULSE: Finds calibration signal in 'wave' (from short-period station).
%           Input 'command' allows the user to specify whether to return
%           cal_pulse start/stop times, binary data (1x25), instrument
%           response data, or battery voltage levels.
%
%USAGE:
%sst = cal_pulse(wave,'sst')     --> Start/Stop Times
%data = cal_pulse(wave,'data')   --> Binary Instrument Data
%resp = cal_pulse(wave,'resp')   --> Instrument Response
%bvl = cal_pulse(wave,'bvl')     --> Battery Voltage Level
%[sst resp bvl] = cal_pulse(wave,'sst','resp','bvl') --> Any combination
%
%INPUTS: wave    - a waveform object with a calibration pulse
%        command - user defined: 'sst', 'data', 'resp', or 'bvl'
%
%OUTPUTS: sst       - cal pulse start/stop times (1x2 double)
%         data      - bit data from signal (1x25 boolean)
%         inst_resp - instrument response data (1x1 waveform)
%         bat_vol   - battery voltage levels (1x1 double)      

v = get(wave,'data');
Fs = get(wave,'freq');
v_l = get(wave,'data_length');
tv = get(wave,'timevector');

chk_per = Fs*5;               % Check Period (look for tone every 5 seconds)
chk_dur = Fs*1;               % Check Duration (look for 1 second)
num_per = floor(v_l/chk_per); % Number of check periods in data
tone_freq = 21.25/Fs;         % 21.25 Hz tone normalized to Fs
tone_found = 0;               % Has tone been found?         
n = 1;

while (n <= num_per)&&(tone_found==0)       
    chk_v = v(1+(n-1)*chk_per:n*chk_per);   % Window to check for tone
    s = zeros(chk_dur+2,1);
    for m = 1:chk_dur
       s(m+2)=chk_v(m)+2*cos(2*pi*tone_freq)*s(m+1)-s(m); % Goertzel algorithm
    end
    s = abs(s);
    if max(s) > 9000 % Is max amplitude of G algorithm @ 21.25 Hz > 9000
        tone_found = 1; % Got it
        m = n*chk_per; % Reference right side of window where tone is found
    end
    n=n+1;
end

if (tone_found == 1)&&(m < v_l-50*Fs) % (...)&&(Not too close to end of v)
   tone_start = 0;
   tone_end = 0;                   % Found end of 21.25 Hz signal?
   mm = m;
   while (tone_start == 0)&&(mm > 10)
      chk_v = v(mm:mm+chk_dur/2);    % Listener window by 1/2 chk_dur
      chk_v = chk_v-mean(chk_v);     % Remove any DC offset
      if max(chk_v-mean(chk_v))<100  % Start of tone found
         tone_start = mm+chk_dur/2;  % Right side of listener window
         t_start = tv(tone_start);   % Returned in 'sst'
      end
      mm=mm-5;                       % Move window 5 data points left
   end
   mm = m + 5*Fs;                    % Move window to tone middle (approx)
   while (tone_end == 0)&&(mm < v_l-50*Fs)
      chk_v = v(mm:mm+chk_dur/2);    % Listener window by 1/2 chk_dur
      chk_v = chk_v-mean(chk_v);     % Remove any DC offset
      if max(chk_v-mean(chk_v))<100  % End of tone found
         tone_end = mm;              % Left side of listener window
      end
      mm=mm+5;                       % Move window 5 data points right
   end
elseif (tone_found == 1)&&(m < v_l-50*Fs)
   disp('Cal Pulse found, but too close to end of signal.')
   for n = 1:length(varargin)
      varargout(n)={[]};
   end
   return
elseif (tone_found == 0)
   disp('Cal Pulse not found in signal.')
   for n = 1:length(varargin)
      varargout(n)={[]};
   end
   return
end

if (tone_end > 0)
   cal_start = 0;
   while (cal_start == 0)&&(m < v_l-50*Fs)
      if v(m)<-200
         while v(m-1)>v(m)
            m=m-1;
         end
         cal_start = 1;
         %plot(m/Fs,v(m),'*r')  Uncomment everything below to plot
         %figure                Instrument Response and binary data
         %subplot(2,1,1)
         resp = extract(wave,'INDEX',m-Fs/2,m+17*Fs);
         %plot(resp)
         %title('Instrument Response')
         m = m+17*Fs;
         subplot(2,1,2)
         %plot((m:m+26*Fs)/Fs,v(m:m+26*Fs))
         %xlim([m/Fs m/Fs+26])
         hold on
         t_end = tv(m+26*Fs); % Returned in 'sst'
         sst = [t_start t_end];
      else
         m=m+1;
      end
   end
end

found_edge = 0;
bin_data = [];
while found_edge == 0
    if (v(m)>500)||(v(m)<-500)
        found_edge = 1;
        m=m+Fs/4;
        for n = 1:25
            if sign(v(m))==1
                bin_data = [bin_data 1];
            elseif sign(v(m))==-1
                bin_data = [bin_data 0];
            end
            %plot(m/Fs,v(m),'*r')
            m=m+Fs;
        end
        bv_data = bin_data(14:25);
        bv_data_str = num2str(bv_data);
        %title(['Instrument Data: [',str_data,']'])
        bvl = bin2dec(bv_data_str(14:25))/100;
    end
    m=m+1;
end

for n = 1:length(varargin)
   if strcmpi(varargin{n},'sst')
      varargout(n) = {sst};
   elseif strcmpi(varargin{n},'data')
      varargout(n) = {bin_data};
   elseif strcmpi(varargin{n},'resp')
      varargout(n) = {resp};
   elseif strcmpi(varargin{n},'bvl')
      varargout(n) = {bvl};
   end
end