function mcvco_xls_report(M,varargin)

M = check_id_gain(M);

t1 = datenum([2013 1 1 0 0 0]);
t2 = datenum([2013 12 31 23 59 59]);
t_12 = floor((t1:.5:t2)*2);

R1 = [];
R2 = [];
R3 = [];
R4 = [];
R5 = [];
subnets = fieldnames(M);
for n = 1:numel(subnets)
    SU = subnets{n};
    stations = fieldnames(M.(SU));
    for m = 1:numel(stations)
        ST = stations{m};
        channels = fieldnames(M.(SU).(ST));
        for k = 1:numel(channels)
            CH = channels{k};
            R1{end+1,1} = SU;
            R2{end+1,1} = [ST,':',CH];
            X = M.(SU).(ST).(CH);
            if ~isempty(X.start)
                Xt = X.start((X.start > t1) & (X.start < t2));
                Xt = floor(Xt*2);
                I = intersect(Xt,t_12);
                P = numel(I)/numel(t_12);
                R3(end+1,1) = X.id(1);
                R4(end+1,1) = X.gain(1);
                R5(end+1,1) = P;
            else
                R3(end+1,1) = 0;
                R4(end+1,1) = 0;
                R5(end+1,1) = 0;
            end
        end
    end
end

cd 'C:\AVO\McVCO_Test_Cycles'
filename = 'mcvco_report.xls';
xlswrite(filename,R1,1,'A1')
xlswrite(filename,R2,1,'B1')
xlswrite(filename,R3,1,'C1')
xlswrite(filename,R4,1,'D1')
xlswrite(filename,R5,1,'E1')
