function S = substruct(S,R,D)
%
% INPUTS:  S - structure with separate fields that are identically sized
%          R - reference to elements to keep or discard within each field
%          D - if D>0,  R is reference of elements to keep in each field
%              if D<=0, R is reference of elements to discard in each field

if ~isstruct(S), error('First input must be a structure'), end
fields = fieldnames(S);
for n = 1:numel(fields)
    s = S.(fields{n}); 
    if D > 0
       S.(fields{n}) = s(R);
    else
       s(R) = [];
       S.(fields{n}) = s;
    end
end
