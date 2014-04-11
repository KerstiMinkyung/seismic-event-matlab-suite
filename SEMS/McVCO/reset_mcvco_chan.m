function M = reset_mcvco_chan(M,subnet,sta,chan,id,gain)

fid = fopen('mcvco_config.txt');
dr = fgetl(fid);
X = M.(subnet).(sta).(chan);
X.bvl = [];
X.start = [];
X.id = [];
X.gain = [];
X.real_id = id;
X.real_gain = gain;
X.lastcheck = datenum([2012 8 1 0 0 0]);
MX.(subnet).(sta).(chan) = X;
MX = update_mcvco_struct(MX,dr);
M.(subnet).(sta).(chan) = MX.(subnet).(sta).(chan);