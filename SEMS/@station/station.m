function S = station(varargin)

%STATION: 
%
%USAGE: S = station()------------------ Empty station
%       S = station(prop_1,val_1,...)-- User-defined properties         
%
%OUTPUTS: S - station object
%
%   See also STATION/GET, STATION/SET
%
% Author: Dane Ketner, Alaska Volcano Observatory
% $Date$
% $Revision$

%% EMPTY STATION    
    
S.name = [];
S.instrument = [];
S.channel = [];
S.network = [];
S.subnetwork = [];
S.elevation = [];
S.latitude = [];
S.longitude = [];

S.rx_name = [];
S.rx_bearing = [];
S.rx_latitude = [];
S.rx_longitude = [];
S.rx_elevation = [];

S.tx_name = [];
S.tx_bearing = [];
S.tx_latitude = [];
S.tx_longitude = [];
S.tx_elevation = [];

S.events = [];
S.status = [];
S.outage = [];

%% USER-DEFINED PROPERTIES
if nargin
   v = varargin;
   nv = nargin;
   if ~rem(nv,2) == 0
       error(['STATION: Arguments after wave must appear in ',...
           'property name/val pairs'])
   end
   for n = 1:2:nv-1
       field = strtrim(lower(v{n}));
       val = v{n+1};
       switch field
           case 'name'
               S.name = val;
           case 'instrument'
               S.instrument = val;
           case 'channel'
               S.channel = val;
           case 'network'
               S.network = val;
           case 'subnetwork'
               S.subnetwork = val;
           case 'elevation'
               S.elevation = val;
           case 'latitude'
               S.latitude = val;
           case 'longitude'
               S.longitude = val;
           case 'rx_name'
               S.rx_name = val;
           case 'rx_bearing'
               S.rx_bearing = val;
           case 'rx_latitude'
               S.rx_latitude = val;
           case 'rx_longitude'
               S.rx_longitude = val;
           case 'rx_elevation'
               S.rx_elevation = val;
           case 'tx_name'
               S.tx_name = val;
           case 'tx_bearing'
               S.tx_bearing = val;
           case 'tx_latitude'
               S.tx_latitude = val;
           case 'tx_longitude'
               S.tx_longitude = val;
           case 'tx_elevation'
               S.tx_elevation = val;
           case 'events'
               S.events = val;
           case 'status'
               S.status = val;
           case 'outage'
               S.outage = val;
           otherwise
               error('STATION: Property name not recognized')
       end
   end
end

S = class(S,'station');
