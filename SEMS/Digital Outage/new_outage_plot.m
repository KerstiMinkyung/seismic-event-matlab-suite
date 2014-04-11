function new_outage_plot(D,T)

subnets = fieldnames(D);
grid = [];
names = {};

for n = 1:numel(subnets)
    SU = subnets{n};
    stations = fieldnames(D.(SU));
    for m = 1:numel(stations)
        ST = stations{m};
        X = D.(SU).(ST).BHZ;
        grid = [grid, X.percent];
        names{end + 1} = [SU,':',ST];
    end
end
imagesc(T,1:size(grid,2),grid)