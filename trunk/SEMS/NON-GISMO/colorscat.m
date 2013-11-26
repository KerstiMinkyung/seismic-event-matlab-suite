function colorscat(X,Y,S,R,varargin)

%COLORSCAT: Plots a scatter plot with marker color proportional to the full
%           range of the input array 'R'. The highst and lowest value in
%           'R' define the two extremes of the colorscale used.
%
%USAGE: colorscat(X,Y,S,R)
%       colorscat(X,Y,S,R,prop_name, prop_val)
%
%STATIC INPUTS: X - horizontal axis data
%               Y - vertical axis data
%               S - marker scale data
%               R - marker color range data
%
%VALID PROP_NAME/PROP_VAL PAIRS:
%  'nbins'      --> (1x1)-[numeric]-[default: 50]
%  'colorlabel' --> (1x2)-[char]   -[default: '']
%  'time'       --> (1x1)-[logical]-[default: false]
%
%OUTPUTS: none 

nbins = 50;
colorlabel = '';
time = 0;

%%
if (nargin > 4)
   v = varargin;
   nv = nargin-4;
   if ~rem(nv,2) == 0
      error(['colorscat: Arguments after X,Y,S,R must appear in ',...
             'property name/val pairs'])
   end
   for n = 1:2:nv-1
      name = lower(v{n});
      val = v{n+1};
      switch name
         case 'nbins' 
            if isnumeric(val) && numel(val)==1
               nbins = val;
            end
         case 'colorlabel' 
            colorlabel = val;  
         case 'time' 
            time = val;    
         otherwise
            error('colorscat: Property name not recognized')
      end
   end
end

%%
d = max(R) - min(R);
r = ceil((R-min(R))/d*nbins);
r(r==0) = 1;
c = jet(nbins);
for n=1:nbins
    if n == 2, hold on, end
    ref = r == n;
    scatter(X(ref),Y(ref),S(ref),'markerEdgeColor','k','markerFaceColor',c(n,:))
end

rng = linspace(min(R),max(R),11);
for n = 1:11
    if time
        clab{n} = datestr(rng(n),'yyyy');
    else
        clab{n} = num2str(rng(n));
    end
end
colorbar('YTickLabel',clab)
title(colorlabel)


