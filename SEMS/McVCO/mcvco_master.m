function mcvco_master
%% UPDATE McVCO VOLTAGE PLOTS

fid = fopen('mcvco_config.txt');
dr = fgetl(fid);
load([dr, '\Master.mat'])
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
dr2 = [dr,'\HTML\network_voltage_plots\'];
plot_mcvco_voltages(M,SN,t_range)
export_fig([dr2,SN,tag],'-png')
pause(.1)
close all

function chanplot(M,SN,t_range,tag,dr)
dr3 = [dr,'\HTML\channel_voltage_plots\'];
stations = fieldnames(M.(SN));
for m = 1:numel(stations)
    ST = stations{m};
    channels = fieldnames(M.(SN).(ST));
    for k = 1:numel(channels)
        CH = channels{k};
        X = M.(SN).(ST).(CH);
        x = find(X.start > t_range(1) & X.start < t_range(2));
        figure, hold on
        x_txt = t_range(1)+(t_range(2)-t_range(1))*.05;
        if X.real_bvl
            scatter(X.start(x),X.bvl(x))
        else
            text(x_txt,14.5,'No Voltage Monitoring','fontsize',16)
        end
        text(x_txt,15.5,[ST,':',CH,' (ID: ',num2str(X.real_id),...
            ', GAIN: ',num2str(X.real_gain),')'],'fontsize',16)
        set(gcf,'Color',[1 1 1])
        set(gcf,'Position',[1 1 1200 400])
        grid on
        xlim(t_range)
        ylim([9 16])
        switch tag
            case {'-week','-month','-3month'}
                datetick('x','dd/mm','keeplimits')
            case {'-year','-all'}
                datetick('x','mmmyy','keeplimits')
        end
        export_fig([dr3,ST,'_',CH,tag],'-png')
        pause(.1)
        close all
    end
end