function outage_xls_report(D,T)

t1 = datenum([2013 1 1 0 0 0]);
t2 = datenum([2013 12 31 23 59 59]);
ref = (T>=t1 & T<=t2);

R1 = [];
R2 = [];
R3 = [];
subnets = fieldnames(D);
for n = 1:numel(subnets)
    SU = subnets{n};
    stations = fieldnames(D.(SU));
    for m = 1:numel(stations)
        ST = stations{m};
        channels = fieldnames(D.(SU).(ST));
        for k = 1:numel(channels)
            CH = channels{k};
            R1{end+1,1} = SU;
            R2{end+1,1} = [ST,':',CH];
            X = D.(SU).(ST).(CH);
            R3(end+1,1) = mean(X.percent(ref));
        end
    end
end

cd 'C:\AVO\Dig_Sta_Outage'
filename = 'outage_report.xls';
xlswrite(filename,R1,1,'A1')
xlswrite(filename,R2,1,'B1')
xlswrite(filename,R3,1,'C1')
