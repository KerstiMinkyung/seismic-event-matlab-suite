function varargout = decode_mcvco(wave,varargin)

%DECODE_MCVCO: Locates and decodes test cycle from a short period seismic
%           station hooked up to a McVCO. 
%
%USAGE:
%sst = decode_mcvco(wave,'sst')     --> Start/Stop Times of test cycle
%data = decode_mcvco(wave,'data')   --> Binary String
%resp = decode_mcvco(wave,'resp')   --> Instrument Response, this returns
%                                       the trimmed waveform between the 
%                                       tone and the binary data
%bvl = decode_mcvco(wave,'bvl')     --> Battery Voltage Level
%[sst resp bvl] = decode_mcvco(wave,'sst','resp','bvl') --> Any combination
%
%INPUTS: wave    - a waveform object with a calibration pulse
%        command - user defined: 'sst', 'data', 'resp', or 'bvl'
%
%OUTPUTS: start - cal pulse start time (1x1 double)
%         sst   - cal pulse start/stop times (1x2 double)
%         data  - bit data from signal (1x25 boolean)
%         gain  - instrument gain (1x1 double)
%           id  - instrument ID (1x1 double)
%         resp  - instrument response data (1x1 waveform)
%         bvl   - battery voltage levels (1x1 double)
%         amp   - tone amplitude (from Goertzel Algorithm)

%% INITIALIZATIONS
warning off
if ~isempty(wave)
v = get(wave,'data');
tv = get(wave,'timevector');
Fs = get(wave,'freq');
v_l = get(wave,'data_length');

chk_per = Fs*5;         % Check Period (look for tone every 5 seconds)
chk_dur = Fs*1;         % Check Duration (look for 1 second)
tone_freq = 21.25/Fs;   % 21.25 Hz tone normalized to Fs
tone_found = 0;         % Has tone been found?         
edge_found = 0;         % Has right edge of tone been found?
n = 1;                  % Ref to left edge of window

%% LOOK FOR LEADING EDGE OF 21.25 Hz TONE USING A
while (edge_found==0) && ((n+43*Fs) < v_l)
   chk_v = v(n:n+chk_dur-1);   % Window to check for tone
   s = gmax(chk_v,tone_freq);
   if (s < 10000) && (tone_found == 0)
      n = n+chk_per;
   elseif (s > 10000) && (tone_found == 0)
      tone_found = 1;
      max_s = s;
   elseif (tone_found == 1) && (edge_found == 0)
      if s > max_s
         max_s = s;
         n = n + 1;
      elseif s < max_s*(.75)
         edge_found = 1;
      else
         n = n + 1;
      end
   elseif tone_found == 0
      n = n+chk_per;
   end
end

%% CREATE A SECOND LISTENER WINDOW SUCH THAT THE MIDDLE OF THE SECOND IS
%  10.25 SECONDS BEFORE THE MIDDLE OF THE FIRST. BALANCE THE OUTPUT OF THE
%  GOERTZEL ALGORITHM FROM THE 2 WINDOWS TO LOCATE AN EXACT FRONT EDGE AND
%  BACK EDGE OF THE 10.25 SECOND TONE

if edge_found
   flag = 0;
   m = n-10.25*Fs;
   while flag == 0
      chk_left = v(m:m+chk_dur-1);
      sl = gmax(chk_left,tone_freq);
      chk_right = v(n:n+chk_dur-1);
      sr = gmax(chk_right,tone_freq);
      if sl>sr
         flag = 1;
         tone_edge(1) = floor(m+chk_dur/2);
         tone_edge(2) = floor(n+chk_dur/2);
         k = round(tone_edge(2) + 18*Fs);
         mv = mean(v(tone_edge(1):tone_edge(2)));
         for K = 1:25
            bin_data(K) = mean(v(k+K-.5:k+K)) > mv;
            bin_ref(K) = k+K-.25;
            k = k + Fs;
         end
      else
         m = m+1;
         n = n+1;
      end
   end
end
else % No Waveform
   edge_found = 0;
   bin_data = [];
end

%%
if (edge_found == 1) && (numel(bin_data) == 25) && k+.25*Fs+10 <= numel(tv)
   complete = 1;
else
   complete = 0;
end

%% USER-DEFINED OUTPUTS
for n = 1:numel(varargin)
    if complete
        switch(lower(varargin{n}))
            case{'start'}
                varargout{n} = tv(tone_edge(1));
                
            case{'end'}
                varargout{n} = tv(tone_edge(2))+ 18 + 25;
                
            case{'sst'}
                varargout{n} = tv(tone_edge)+ [0, 18 + 25];
                
            case{'data'}
                varargout{n} = {bin_data};
                
            case{'gain'}
                switch bin2dec(num2str(bin_data(1:3)))
                    case 0
                        varargout{n} = 42;
                    case 1
                        varargout{n} = 48;
                    case 2
                        varargout{n} = 54;
                    case 3
                        varargout{n} = 60;
                    case 4
                        varargout{n} = 66;
                    case 5
                        varargout{n} = 72;
                    case 6
                        varargout{n} = 78;
                    case 7
                        varargout{n} = 84;
                end
                
            case{'id'}
                varargout{n} = bin2dec(num2str(bin_data(4:13)));
                
            case{'resp'}
                varargout{n} = extract(wave,'INDEX',tone_edge(2),...
                    tone_edge(2)+18*Fs);
                
            case{'bvl'}
                varargout{n} = bin2dec(num2str(bin_data(14:25)))/79;
                
            case{'amp'}
                varargout{n} = max_s;
                
            case{'plot'}
                fh = figure;
                plot(extract(wave,'INDEX',tone_edge(1)-Fs,k+.25*Fs+Fs))
                hold on
                scatter((bin_ref-tone_edge(1)+Fs)/Fs,v(bin_ref),'*','r')  
                varargout{n} = fh;
        end
    else
        varargout{n} = NaN;
    end
end
warning on

%% Compute Goertzel Algorithm
function s = gmax(chk_v,tone_freq)
s = zeros(numel(chk_v)+2,1);
for m = 1:numel(chk_v)
   s(m+2)=chk_v(m)+2*cos(2*pi*tone_freq)*s(m+1)-s(m);
end
s = max(abs(s));






    
    