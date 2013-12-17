function S = set(S,varargin)
%SET: Set station properties
%   S = set(S,prop_name,prop_val)
%
%   Valid property names:
%   
%
%   See also STATION, STATION/GET
%
% Author: Dane Ketner, Alaska Volcano Observatory
% $Date$
% $Revision$

if ~isa(S,'station')
   error('STATION/SET: Not a valid station object')
end

if ~rem(nargin-1,2) == 0
    error(['STATION/SET: Arguments after ''S'' must appear in ',...
        'property name/val pairs'])
end

for n = 1:2:nargin-2
    v = varargin(2:end);
    
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
