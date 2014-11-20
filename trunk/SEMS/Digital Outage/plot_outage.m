function plot_outage(M,t_rng,tag,dr)

D = M.Outage;
T = M.TimeVector;
subnets = fieldnames(D);

%%
if isempty(t_rng)
    switch tag
        case 'Week'
            t_rng = [now-7, now];
        case 'Month'
            t_rng = [now-30, now];
        case '3Month'
            t_rng = [now-90, now];
        case 'Year'
            t_rng = [now-365, now];
        case 'All'
            t_rng = [T(1), now];
    end
end
keep = find(T>=t_rng(1) & T<=t_rng(2));
T = T(keep);

%%
for n = 1:numel(subnets)
    dat = [];
    names = {};
    SU = subnets{n};
    stations = fieldnames(D.(SU));
    for m = 1:numel(stations)
        ST = stations{m};
        channels = fieldnames(D.(SU).(ST));
        for k =1:numel(channels)
            CH = channels{k};
            d = D.(SU).(ST).(CH);
            dat = [dat, d(keep)];
            names{end + 1} = [ST,':',CH];
        end
    end
    imagesc(T,1:m,dat')
    set(gcf,'Color','w')
    Cmap = [linspace(1,0,64)', linspace(1,0,64)', linspace(1,.5,64)'];
    colormap(Cmap);
    for l = 1:m-1
        line([t_rng(1), t_rng(2)],[l+.5, l+.5],'Color','w','LineWidth',2)
    end
    grid on
    setxticks(tag)
    xlim(t_rng)
    set(gca,'YTick',1:length(names))
    set(gca,'YTickLabel',names)
    set(gcf,'Position',[100 100 1200 45+35*m])
    export_fig([dr,'\HTML\',SU,'-',tag],'-png')
    pause(.1)
    close all
end

%%
function setxticks(tag)

nowvec = datevec(now);
switch tag
    case 'Week'
        ticks = floor(now)-7 : floor(now);
        ticklab = datestr(ticks,'dd-mmm');
    case 'Month'
        ticks = floor(now)-30 :2: floor(now);
        ticklab = datestr(ticks,'dd-mmm');
    case '3Month'
        ticks = floor(now)-90 :6: floor(now);
        ticklab = datestr(ticks,'dd-mmm');
    case 'Year'
        y = floor(nowvec(1)-1 : 1/12 : nowvec(1)+1)';
        m = mod(1:length(y),12)'; m(m==0) = 12;
        d = ones(size(y));
        z = zeros(size(y));
        ticks = datenum([y,m,d,z,z,z]);
        ticklab = datestr(ticks,'mmm');

    case 'All'
        y = floor(2012 : .25 : nowvec(1)+1)';
        m = mod(1:3:length(y)*3,12)'; m(m==0) = 12;
        d = ones(size(y));
        z = zeros(size(y));
        ticks = datenum([y,m,d,z,z,z]);
        ticklab = datestr(ticks,'mmm-yyyy');
end
set(gca,'XTick',ticks,'XTickLabel',ticklab)
pause(.1)