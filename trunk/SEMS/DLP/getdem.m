function M = getdem(lat, lon)

ts = 1812; % DEM tile size

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
lat = lat+1;
dir = 'C:\Gridfloat Maps';
flat = floor(lat);
flon = floor(lon);
row = [];
M = [];

for n = flat(1):flat(2)
    for m = flon(1):flon(2)
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
        F = readgridfloat(dir,ff);
        if isempty(F)
            F = NaN*ones(ts);
        end
        row = [row F];
    end
    M = [row; M];
    row = [];
end

LAT(1) = floor((lat(1) - flat(1))*ts)+1;
LAT(2) = ceil((lat(2) - lat(1))*ts) + LAT(1);
LON(1) = floor((lon(1) - flon(1))*ts)+1;
LON(2) = ceil((lon(2) - lon(1))*ts) + LON(1);

M = flipud(M);
M = M(LAT(1):LAT(2),LON(1):LON(2));
M = flipud(M);