function colorhist(X,C,xbins,cbins)

%COLORHIST: 
%
%USAGE: colorhist(X,Y,nbins)
%
%STATIC INPUTS: X - Data controlling bar height (after mapping to bins)
%               C - Data controlling bar color (after mapping to bins)
%               xbins - number of bins in which to map X
%               cbins - number of bins in which to map C
%
%OUTPUTS: none 

hold on
dX = (max(X)-min(X))/xbins;
dC = (max(C)-min(C))/cbins;
Cmap = jet(cbins);

for xx = 1:xbins
    x1 = min(X) + (xx-1)*dX;
    x2 = min(X) + xx*dX;
    ind = find(X >= x1 & X < x2);
    subC = C(ind);
    yoff = 0;
    for cc = 1:cbins
        c1 = min(C) + (cc-1)*dC;
        c2 = min(C) + cc*dC;
        y1 = sum(subC < c1);
        y2 = sum(subC < c2);
        area([x1,x2,x2,x1],[y1,y1,y2,y2],...
             'LineStyle','none','FaceColor',Cmap(cc,:))
    end
end