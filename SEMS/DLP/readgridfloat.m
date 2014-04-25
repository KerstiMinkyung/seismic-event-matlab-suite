function [M, lat, lon] = readgridfloat(dir,file)

olddir = cd;
d = fullfile(dir,file);
if exist(d,'dir') == 7
    cd(fullfile(dir,file))
    try
    fid = fopen(['float',file,'_2.hdr']);
    ncols = sscanf(fgetl(fid),'ncols%d');               % ncols         1812
    nrows = sscanf(fgetl(fid),'nrows%d');               % nrows         1812
    xllcorner = sscanf(fgetl(fid),'xllcorner%f');       % xllcorner     -174.0033333333
    yllcorner = sscanf(fgetl(fid),'yllcorner%f');       % yllcorner     50.99666666667
    cellsize = sscanf(fgetl(fid),'cellsize%f');         % cellsize      0.000555555555556
    NODATA_value = sscanf(fgetl(fid),'NODATA_value%d'); % NODATA_value  -9999
    byteorder = sscanf(fgetl(fid),'byteorder%s');       % byteorder     LSBFIRST
    fclose(fid);
    lat = linspace(yllcorner, yllcorner+(nrows-1)*cellsize,nrows);
    lon = linspace(xllcorner, xllcorner+(ncols-1)*cellsize,ncols);
    data = ['float',file,'_2.flt'];
    M = readmtx(data,nrows,ncols,'float32',[1 nrows],[1 ncols],'ieee-le');
    M(M == -9999) = NaN;
    catch
        M = [];
    end
else
    M = [];
    lat = [];
    lon = [];
    disp([d,' does not exist'])
end
cd(olddir)