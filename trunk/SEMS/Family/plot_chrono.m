function plot_chrono(F,varargin)

%% CREATE FIGURE
fh = figure;                           % Figure hande for occurence plot
ax = axes('Position',[.06 .1 .72 .85]); % Axes handle for occurence plot

%% PLOT EXPLOSION LINES
% nex = numel(explosion);
% for m = 1:nex
%    line([explosion(m),explosion(m)],[0 1],'color','r')
% end

%% PLOT MULTIPLET CHRONOLOGY
nf = numel(F.wave);                    % Number of families
tm = .025;                             % Axes Top Margin
bm = .025;                             % Axes Bottom Margin
t_start = datestr([2009 02 26 0 0 0]);
t_end = datestr([2009 02 28 0 0 0]);
gap = (1-tm-bm)*.2/(nf-1);             % Gap between rectangles 
h = (1-tm-bm-gap*(nf-1))/nf;           % Height of rectangles

for n = 1:nf                           % 1:number of families
   yts = 1; % Y-Tick Spacing
   if rem(n,yts)==0
   ylab{n/yts} = num2str(n,'%03.0f');      % Y-axis Family Label
   ypos(n/yts) = bm+(h+gap)*(n-1)+h/2;     % Y-axis Family Label Position
   end
   F_start = get(F.wave{n}(1),'start'); % Time of first family member
   F_end = get(F.wave{n}(end),'start'); % Time of last family member
   % DRAW FAMILY RECTANGLE
   rectangle('Position',[F_start,bm+(h+gap)*(n-1),F_end-F_start,h],...
             'FaceColor',[1 1 1]);    
   % DRAW VERTICAL TICKS INSIDE FAMILY RECTANGLE FOR ALL INTERIOR MEMBERS
   for m = 2:numel(F.wave{n})-1            
      x = get(F.wave{n}(m),'start');
      line([x x],[bm+(h+gap)*(n-1), bm+(h+gap)*(n-1)+h],'color',[0 0 0])
   end
end

set(ax,'YTick',ypos)
set(ax,'YTickLabel',ylab)
set(ax,'XGrid','on')
YLabel('MULTIPLET NUMBER')
XLabel('DATE')
dynamicDateTicks
ylim([0,1])

%% PLOT CUMULATIVE NUMBER OF FAMILY MEMBERS (LINEAR)
% ax2 = axes('Position',[.78 .1 .18 .85]); % Axes handle for occurence plot
% for n=1:length(F.wave)
%    nw(n) = numel(F.wave{n});
% end
% roof = ceil(max(nw)/10)*10;
% norm = nw/roof;
% for n = 1:nf                           % 1:number of families
%    rectangle('Position',[1-norm(n),bm+(h+gap)*(n-1),norm(n),h],...
%              'FaceColor',[0 0 0]);    
% end
% 
% spacing = 10; % You will have to change this manually
% n_spaces = floor(roof/spacing);
% for n = 1:n_spaces
%    xlab{n} = num2str(roof+(1-n)*spacing);
%    xpos(n) = (spacing*(n-1)/roof);
% end
% 
% set(ax2,'YTick',ypos)
% set(ax2,'YTickLabel',[])
% set(ax2,'XGrid','on')
% XLabel('')
% set(ax2,'XTick',xpos)
% set(ax2,'XTickLabel',xlab)
% ax3 = [ax,ax2];
% linkaxes(ax3,'y')

%% PLOT CUMULATIVE NUMBER OF FAMILY MEMBERS (LOGARITHMIC)
ax2 = axes('Position',[.78 .1 .18 .85]); % Axes handle for occurence plot
for n=1:length(F.wave)
   nw(n) = numel(F.wave{n});
end
lnw = log10(nw);
roof = ceil(max(lnw));
norm = lnw/roof;
 
for n = 1:nf                           % 1:number of families
   rectangle('Position',[1-norm(n),bm+(h+gap)*(n-1),norm(n),h],...
             'FaceColor',F.color(n,:));    
end

for n = 1:roof
   xlab{n} = (['10^',num2str(roof+1-n)]);
   xpos(n) = ((n-1)/roof);
end

set(ax2,'YTick',ypos)
set(ax2,'YTickLabel',[])
set(ax2,'XGrid','on')
XLabel('EVENT COUNT')
set(ax2,'XTick',xpos)
set(ax2,'XTickLabel',xlab)
ax3 = [ax,ax2];
linkaxes(ax3,'y')

clear ylab ypos xlab xpos x tm t_start t_end gap nf n m h fh dur bm ax
