function M = getdem(lat, lon)

if lat(1) > lat(2)
    tmp = lat(1);
    lat(1) = lat(2);
    lat(2) = tmp;
end
if lon(1) > lon(2)
    tmp = lon(1);
    lon(1) = lon(2);
    lon(2) = tmp;
end

dir = 'C:\Gridfloat Maps';
flat = floor(lat(1)+1):floor(lat(2)+1);
flon = floor(lon(1)):floor(lon(2));
row = [];
Mlon = [];
Mlat = [];
M = [];
rowdone = 0;

for n = flat
    for m = flon
        if n >= 0
            ff = ['n',num2str(n)];
        else
            ff = ['s',num2str(-n)];
        end
        if m < 0
            ff = [ff,'w',num2str(-m)];
        else
            ff = [ff,'e',num2str(m)];
        end
        [F, sublat, sublon] = readgridfloat(dir,ff);
        %sublat = sublat-1;
        if isempty(F)
            F = zeros(1812);
        end
        row = [row, F];
        if ~rowdone
            Mlon = [Mlon, sublon];
        end
    end
    rowdone = 1;
    Mlat = [Mlat, sublat];
    M = [row; M];
    row = [];
end

k = 10000;
[Mlat, latindx] = unique(round(Mlat*k));
[Mlon, lonindx] = unique(round(Mlon*k));
Mlat = Mlat/k; Mlon = Mlon/k;
M = M(latindx, lonindx);
M = flipud(M);
M(Mlat < lat(1) | Mlat > lat(2),:) = [];
M(:,Mlon < lon(1) | Mlon > lon(2)) = [];
