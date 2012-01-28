function plot_avail(d1,d2,avail)

%PLOT_AVAIL: Plot station availability chart
%
%USAGE: plot_avail(d1,d2,avail)
%
%INPUTS: d1 - plot start time
%        d2 - plot end time
%        avail - availability structure: 
%                 avail.sta - stations array
%                 avail.sst - station start/stop time array
%
%OUTPUTS: sst (merged)

%%
figure
ax = axes;
n_sta = numel(avail.sta);
top = .05;
bottom = .05;

off = (1-top-bottom)*.2/(n_sta-1);
h = (1-top-bottom-off*(n_sta-1))/n_sta;
for n = 1:n_sta
   for m = 1:size(avail.sst{n},1)
      rectangle('Position',[avail.sst{n}(m,1),bottom + (h+off)*(n-1),...
                            avail.sst{n}(m,2)-avail.sst{n}(m,1),h],...
                            'FaceColor',[.8 .8 .8]);
      tick_pos(n) = bottom + (h+off)*(n-1) +h/2;
   end
end

xlim([d1,d2])
ylim([0,1])

set(ax,'YTick',tick_pos)
set(ax,'YTickLabel',upper(avail.sta))

dynamicDateTicks
   




