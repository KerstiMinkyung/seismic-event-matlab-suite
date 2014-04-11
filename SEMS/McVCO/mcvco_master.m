function mcvco_master
%% UPDATE McVCO VOLTAGE PLOTS

fid = fopen('mcvco_config.txt');
dr = fgetl(fid);
cd(dr)
load('Master.mat')
%M = update_mcvco_struct(M,dr);
M = check_id_gain(M);

%%
subnets = fieldnames(M);
t = ceil(now);
for n = 1:numel(subnets)
    SN = subnets{n};
    
    t_range = [t-7 t];
    tag = '-week';
    netplot(M,SN,t_range,tag,dr)
    chanplot(M,SN,t_range,tag,dr)
    
    t_range = [t-30 t];
    tag = '-month';
    netplot(M,SN,t_range,tag,dr)
    chanplot(M,SN,t_range,tag,dr)
    
    t_range = [t-90 t];
    tag = '-3month';
    netplot(M,SN,t_range,tag,dr)
    chanplot(M,SN,t_range,tag,dr)
    
    t_range = [t-365 t];
    tag = '-year';
    netplot(M,SN,t_range,tag,dr)
    chanplot(M,SN,t_range,tag,dr)
    
    t_range = [datenum([2012 8 1 0 0 0]) t];
    tag = '-all';
    netplot(M,SN,t_range,tag,dr)
    chanplot(M,SN,t_range,tag,dr)
end

function netplot(M,SN,t_range,tag,dr)
cd([dr,'\network_voltage_plots'])
plot_mcvco_voltages(M,SN,t_range)
set(gcf,'visible','off')
export_fig([SN,tag],'-png')
pause(.1)
close all

function chanplot(M,SN,t_range,tag,dr)
cd([dr,'\channel_voltage_plots'])
stations = fieldnames(M.(SN));
for m = 1:numel(stations)
    ST = stations{m};
    channels = fieldnames(M.(SN).(ST));
    for k = 1:numel(channels)
        CH = channels{k};
        X = M.(SN).(ST).(CH);
        x = find(X.start > t_range(1) & X.start < t_range(2));
        figure
        set(gcf,'visible','off')
        scatter(X.start(x),X.bvl(x))
        set(gcf,'Color',[1 1 1])
        x_txt = t_range(1)+(t_range(2)-t_range(1))*.4;
        text(x_txt,15,[ST,':',CH],'fontsize',16) 
        grid on
        xlim(t_range)
        ylim([9 16])
        switch tag
            case {'-week','-month','-3month'}
                datetick('x','dd/mm','keeplimits')
            case {'-year','-all'}
                datetick('x','mmmyy','keeplimits')
        end
        export_fig([ST,'_',CH,tag],'-png')
        pause(.1)
        close all
    end
end