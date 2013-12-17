function disp(S)
%DISP: Station disp overloaded operator
%
% See also STATION
%
% Author: Dane Ketner, Alaska Volcano Observatory
% $Date$
% $Revision$

nw = numel(S.name);
disp(' ');
fprintf('%s object with %d stations(s):\n',class(S), nw);




