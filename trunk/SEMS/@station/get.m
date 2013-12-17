function val = get(S,prop_name)
%GET: Get station properties
%   S = get(S,prop_name)
%
%   Valid property names:
%   
%
%   See also STATION, STATION/SET
%
% Author: Dane Ketner, Alaska Volcano Observatory
% $Date$
% $Revision$

if ~isa(S,'station')
   error('STATION/SET: Not a valid station object')
end

if nargin ~= 2
    error(['STATION/SET: Wrong number of inputs - Station object and property name required'])
end

switch prop_name
    case 'name'
         val = S.name;
    case 'instrument'
        val = S.instrument;
    case 'channel'
        val = S.channel;
    case 'network'
        val = S.network;
    case 'subnetwork'
        val = S.subnetwork;
    case 'elevation'
        val = S.elevation;
    case 'latitude'
        val = S.latitude;
    case 'longitude'
        val = S.longitude;
    case 'rx_name'
        val = S.rx_name;
    case 'rx_bearing'
        val = S.rx_bearing;
    case 'rx_latitude'
        val = S.rx_latitude;
    case 'rx_longitude'
        val = S.rx_longitude;
    case 'rx_elevation'
        val = S.rx_elevation;
    case 'tx_name'
        val = S.tx_name;
    case 'tx_bearing'
        val = S.tx_bearing;
    case 'tx_latitude'
        val = S.tx_latitude;
    case 'tx_longitude'
        val = S.tx_longitude;
    case 'tx_elevation'
        val = S.tx_elevation;
    case 'events'
        val = S.events;
    case 'status'
        val = S.status;
    case 'outage'
        val = S.outage;
    otherwise
        error('STATION: Property name not recognized')
end

