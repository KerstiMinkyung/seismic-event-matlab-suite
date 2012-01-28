function e = wevent(varargin)

v = varargin
%% EMPTY WEVENT
if nargin == 0               
   e.sst = [];
   e.scnl = [];
   e.wfa = waveform();

%% ANOTHER WEVENT OBJECT 
elseif nargin==1 && isa(v{1},'wevent')
    e = v{1};
    return
    
%% WAVEFORM OBJECT PROVIDED
elseif (nargin >= 1) && isa(v{1},'waveform')
   e.sst = [get(v{1},'start') get(v{1},'start')];
   e.scnl = get(v{1},'scnlobject')
   e.wfa = v{1}; 

%% SST & SCNL PROVIDED
elseif (nargin >= 2) && is_sst(v{1}) && isa(v{2},'scnlobject')
   e.sst = v{1};
   e.scnl = v{2};
   e.wfa = [];    
else
   error('wevent: Event arguments not recognized')
end

%% DEFAULT PROPERTIES
e.trig = [];
e.rms = [];
e.p2p = [];
e.pf = [];
e.fi = [];
e.loc = [];
e.fam = [];
e = class(e,'wevent');