function events = sta_lta(wave,varargin)

%STA_LTA: Short-Time-Average/Long-Time-Average event detector.
%
%USAGE: events = sta_lta(wave,prop_name_1,prop_val_1,...)
%
%DIAGRAM:
%                       /\      /\/\        /\
%              /\  /\/\/  \/\  /    \/\    /  \/\
%                \/          \/        \/\/      \
%                                           |-STA-| -->
%         --> |-----------------LTA---------------| -->
%
%INPUTS: wave - a waveform object containing events (maybe)
%        varargin - user-defined parameter name/value pairs (below)
%
%VALID PROP_NAME: 
%
%  'edp'      - Event Detection Parameters
%  'return'   - Return type of output events 
%  'lta_mode' - Post trigger-on LTA behavior
%  'skip'     - Times for STA/LTA to skip over, examples are data gaps, 
%               calibration pulses, or periods of excessive noise
%
%VALID PROP_VAL: 
%
%  'edp'(1x8 double) ... default: [1 8 2 1.6 0 1.7 0 0]
%     --> [l_sta l_lta th_on th_off skip_int min_dur pre_t post_t]
%        --> l_sta    - STA window length (s)
%        --> l_lta    - LTA window length (s)
%        --> th_on    - STA/LTA trigger on threshold
%        --> th_off   - STA/LTA trigger off threshold
%        --> skip_int - Skip ahead after end of event (s)
%        --> min_dur  - Minimum event duration (s)
%        --> pre_t    - Added pre-event time (s) 
%        --> post_t   - Added post-event time (s)
%
%	'skip' (nx2 double) ... default: []
%     --> skip_sst - List of start/stop times to skip
%
%	'return' (string) ... default: 'sst'
%     --> 'sst' - return event start/stop times (nx2)
%     --> 'wfa' - return event waveform array (1xn)
%     --> 'ssd' - return event start/stop datapoints (nx2)
%
%	'lta_mode' (string) ... default: 'continuous'
%     --> 'frozen' - LTA window fixed in place after trigger is turned on 
%                    while STA window continues forward.
%     --> 'continuous' - LTA window continues w/ STA window after trigger 
%                        is turned on (Same behavior as before trigger)
%     --> 'grow' - LTA left edge fixed, right edges continues w/ STA right 
%                  edge after trigger on, thus size of LTA window is 
%                  growing until trigger off, at which point LTA window 
%                  returns to original size.
%                           
%OUTPUTS: events - events in format specified by 'return'

%% Check waveform variable
if isa(wave,'waveform')
   Fs = get(wave,'freq');         % Sampling frequency
   l_v = get(wave,'data_length'); % Length of time series
   tv = get(wave, 'timevector');  % Time vector of waveform
else
   error('STA_LTA: First Argument must be a waveform object')
end

%% Set all default parameters
l_sta = 1*Fs;     % STA window length
l_lta = 8*Fs;     % LTA window length
th_on = 2;        % Trigger on when sta_to_lta exceeds this theshold
th_off = 1.6;     % Trigger off when sta_to_lta drops below threshold
skip_int = 0*Fs;  % Skip ahead after end of event
min_dur = 1.7*Fs; % Any triggers shorter than min_dur are discarded
pre_t = 0*Fs;     % Added pre-event time
post_t = 0*Fs;    % Added post-event time
skip_t = [];      % List of start/stop times to skip
rtype = 'sst';    % Return type of output events 
lta_mode = 'continuous'; % Post trigger-on LTA behavior

%% Check varargin size
nv = numel(varargin);
if ~rem(nv,2) == 0
   error(['STA_LTA: Arguments after wave must appear in ',...
          'property_name/property_value pairs'])
end

%% User-defined parameters (varargin)
if nv > 0
   for p = 1:2:nv-1
      v1 = varargin{p};
      v2 = varargin{p+1};
      switch lower(v1)
         case 'edp'
            if isnumeric(v2) && numel(v2) == 8 
               l_sta = v2(1)*Fs;     % STA window length
               l_lta = v2(2)*Fs;     % LTA window length
               th_on = v2(3);        % Trigger on theshold
               th_off = v2(4);       % Trigger off threshold
               skip_int = v2(5)*Fs;  % Skip ahead after end of event
               min_dur = v2(6)*Fs;   % Minimum event duration
               pre_t = v2(7)*Fs;     % Added pre-event time
               post_t = v2(8)*Fs;    % Added post-event time
            else
               error('STA_LTA: wrong edp format')
            end
         case 'skip'
            if isnumeric(v2) && size(v2,2) == 2
               skip_t = v2;
            else
               error('STA_LTA: wrong skip format')
            end
         case 'return'
            switch lower(v2)
               case 'sst'
                  rtype = v2;
               case 'wfa'
                  rtype = v2;
               case 'ssd'
                  rtype = v2;
               otherwise
                  error('STA_LTA: return type not recognized')
            end
         case 'lta_mode'
            switch lower(v2)
               case {'freeze','frozen'}
                  lta_mode = 'frozen';
               case {'continue','continuous'}
                  lta_mode = 'continuous';
               case {'grow','growing'}   
                  lta_mode = 'grow';
               otherwise
                  error('STA_LTA: lta_mode type not recognized')
            end
         otherwise
            error(['STA_LTA: ''edp'', ''return'', and ''lta_mode'' ',...
                    'are the only property names recognized'])
      end
   end
end

%% Initialize waveform data
wave = set2val(wave,skip_t,NaN); % NaN skip times 
wave = zero2nan(wave,10);        % NaN any data gaps 
v = get(wave,'data');            % Waveform data
abs_v = abs(v);                  % Absolute value of time series

%% Initialize flags and other variables
lta_calc_flag = 0;       % has the full LTA window been calculated?
ntrig = 0;               % number of triggers
trig_array = zeros(1,2); % array of trigger times: [on,off;on,off;...]

%% Loops over data
% i is the primary reference point (right end of STA/LTA window)
i = l_lta+1;
while i <= l_v

%% Skip data gaps (NaN values in LTA window)?
   if any(isnan(abs_v(i-l_lta:i)))
      gap = 1;
      lta_calc_flag = 0; % Force full claculations after gap
      while (gap == 1) && (i < l_v)
         i = i+1;
         if ~any(isnan(abs_v(i-l_lta:i)))
            gap = 0;
         end
      end
   end

%% Calculate STA & LTA Sum (Do Full Calculation?)
   if (lta_calc_flag == 0)
      lta_sum = 0;
      sta_sum = 0;
      for j = i-l_lta:i-1              % Loop to compute LTA & STA
         lta_sum = lta_sum + abs_v(j); % Sum LTA window
         if (i - j) <= l_sta           % Sum STA window (right side of LTA)
            sta_sum = sta_sum + abs_v(j);
         end
      end
      lta_calc_flag = 1;
   else
      
%% Calculate STA & LTA Sum (Single new data point if not Full) 
      lta_sum = lta_sum - abs_v(i-l_lta-1) + abs_v(i-1);
      sta_sum = sta_sum - abs_v(i-l_sta-1) + abs_v(i-1);
   end

%% Calculate STA & LTA
   lta = lta_sum/l_lta;
   sta = sta_sum/l_sta;

%% Calculate STA/LTA Ratio
   sta_to_lta = sta/lta;

%% Trigger on? (Y/N)
   if sta_to_lta > th_on
      j = i;   % Set secondary reference point = primary
      g = 0;   % l_lta growth, only used if LTA growing
      while (sta_to_lta > th_off)
         j = j+1;
         if j < l_v
            sta_sum = sta_sum - abs_v(j-l_sta-1) + abs_v(j-1);
            switch lta_mode
               case 'frozen'
                  % LTA is good just the way it is
               case 'continuous'
                  % Add new data point, remove oldest data point
                  lta_sum = lta_sum - abs_v(j-l_lta-1) + abs_v(j-1);
               case 'grow'
                  % Add new data point, increase
                  lta_sum = lta_sum + abs_v(j-1);
                  l_lta = l_lta + 1;
                  g = g+1;
            end
            sta = sta_sum/l_sta;
            lta = lta_sum/l_lta;
            sta_to_lta = sta/lta;
            if any(isnan(abs_v(j-l_sta:j))) % NaN gaps to skip?
               sta_to_lta = 0; % Force trigger off (data gap in STA window)
            end
         else
            sta_to_lta = 0; % Force trigger off (end of data)
         end
      end
      duration = (j-i); % span from trigger on to trigger off
      l_lta = l_lta-g;

%% Triggered period long enough? (Y/N)
      if duration > min_dur % If duration < min_dur then skip it
         trig_t = i-l_sta;  % Beginning of STA window during trigger on
         end_t  = j;        % End of STA window during trigger off
         ntrig = ntrig + 1; % Event counter
         trig_array(ntrig,:) = [trig_t, end_t];
      end
      i = j + skip_int;  % Skip ahead
      lta_calc_flag = 0; % Reset LTA calc flag to force new computation
   end
   i = i + 1;
end

%% Return events
if (trig_array(1,1)==0)&&(trig_array(1,2)==0)
   disp('No events detected')
   return
end
s2d = 1/24/60/60;
switch lower(rtype)
   case {'ssd'}
      events = trig_array;
   case {'sst'}
      events = tv(trig_array);
   case {'wfa'}
      events = [];
      for n=1:size(trig_array,1)
         events=[events; extract(wave,'INDEX',...
                trig_array(n,1)-pre_t, trig_array(n,2)+post_t)];
         % Need to add option for set length before/after trig_on i.e.
         % Code below does this for 1 second before, 7 seconds after
         % events=[events; extract(wave,'INDEX',trig_array(n,1)-Fs,trig_array(n,1)+7*Fs)];     
      end
end

