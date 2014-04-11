function new_outage_plot(D,T,varargin)

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
        names{end + 1} = [ST,':BHZ'];
    end
end
imagesc(T,1:size(grid,2),grid')
set(gca,'ytick',1:numel(names))
set(gca,'yticklab',names)
colorbar
dynamicDateTicks
set(xlim([datenum([2012 8 15 0 0 0]), now]))