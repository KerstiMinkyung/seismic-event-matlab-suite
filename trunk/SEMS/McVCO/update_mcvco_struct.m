function M = update_mcvco(M,dir)

host = 'pubavo1.wr.usgs.gov';
port = 16023;
ds = datasource('winston',host,16023);

subnets = fieldnames(M);
for n = 1:numel(subnets)
    SU = subnets{n};
    stations = fieldnames(M.(SU));
    for m = 1:numel(stations)
        ST = stations{m};
        channels = fieldnames(M.(SU).(ST));
        for k = 1:numel(channels)
            CH = channels{k};
            X = M.(SU).(ST).(CH);
            scnl = scnlobject(ST,CH,'AV',[]);
            X = update(X,ds,scnl);
            M.(SU).(ST).(CH) = X;
            save([dir,'\Master.mat'],'M')
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function X = update(X,ds,scnl)

if ~isempty(X.start)
lastfind = max(X.start);
else
    lastfind = datestr([2000 1 1 0 0 0]);
end
gapcnt = X.lastcheck - lastfind;
if gapcnt < 7
    t = lastfind + .5;
else
    t = ceil(X.lastcheck);
end

while t < now
    mnt = 1/24/60;
    if gapcnt < 7
        w = get_w(ds,scnl,t-mnt,t+2*mnt);
    elseif gapcnt >= 7
        w = get_w(ds,scnl,t,t+.5);
    end
    pause(.01)
    
    try
        [start bvl id gain] = decode_mcvco(w,'start','bvl','id','gain');
    catch
        start = NaN;
    end
    
    if ~isnan(start)
        gapcnt = 0;
        X.start = [start; X.start];
        X.bvl = [bvl; X.bvl];
        X.id = [id; X.id];
        X.gain = [gain; X.gain];
        disp([datestr(t), ' - ', get(scnl,'station'), ':',...
            get(scnl,'channel'),' - McVCO Signal Found'])
        t = start;
    else
        disp([datestr(t), ' - ', get(scnl,'station'), ':',...
            get(scnl,'channel'),' - McVCO Signal Not Found'])
    end
    
    if gapcnt < 7
        X.lastcheck = t;
        t = t+.5;
        gapcnt = gapcnt + .5;
    elseif gapcnt >= 7
        X.lastcheck = t;
        t = t + 2;
        gapcnt = gapcnt + 2;
    end
end
[A B] = sort(X.start,'descend');
X.start = X.start(B);
X.bvl   = X.bvl(B);
X.id    = X.id(B);
X.gain  = X.gain(B);