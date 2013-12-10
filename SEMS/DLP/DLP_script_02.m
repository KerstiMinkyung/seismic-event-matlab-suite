
%% DEEP LP PROJECT SCRIPTS

% 'md' - Path to folders containing miniSEED data (.mseed)
% 'pd' - Path to STP phase files (.pha)
% 'wd' - Path to waveform object file
md = 'C:\AVO\Deep LP\DLP_mseed';
pd = 'C:\AVO\Deep LP\DLP_phase';
wd = 'C:\AVO\Deep LP\DLP_wfa';
% 'WD' - Structure containing names of miniSEED folders
MD = dir(md);
MD(1:2) = []; % Get rid of '.' and '..'
% 'PD' - Structure containing names of STP phase files
PD = dir(pd);
PD(1:2) = []; % Get rid of '.' and '..'

%%
Master = [];
for n = 1:numel(MD)
    clc, disp(num2str(n)), pause(.01)
    id = MD(n).name;
    wfold = fullfile(md,id);
    pfile = fullfile(pd,[id,'.pha']);
    if exist(pfile) == 2 % If a corresponding phase file exist
        % 'MDN' - Structure w/ names of miniSEED files in current folder
        MDN = dir(wfold);
        MDN(1:2) = []; % Get rid of '.' and '..'
        if ~isempty(MDN(1).name)
            [E, P] = readphase_tp(pfile,net);
            if ~isempty(P) && ~isempty(E)
                Master.evid(n) = E.evid;
                Master.type{n} = E.type;
                Master.datenum(n) = E.datenum;
                Master.lat(n) = E.lat;
                Master.lon(n) = E.lon;
                Master.depth(n) = E.depth;
                Master.mag(n) = E.mag;
                Master.magtype{n} = E.magtype;
                Master.quality(n) = E.quality;
                pscnl = scnlobject;
                for k = 1:numel(P)
                    pscnl(k) = scnlobject(P(k).sta,P(k).chan,P(k).net,P(k).loc);
                end
                W = [];
                for m = 1:numel(MDN)
                    mfile = fullfile(md,id,MDN(m).name);
                    w = msd2wfo(mfile);
                    wscnl = get(w,'scnlobject');
                    [rA, rB] = intersect(wscnl,pscnl);
                    if ~isempty(rB)
                        w = addfield(w, 'evid', E.evid);
                        w = addfield(w, 'type', E.type);
                        w = addfield(w, 'ev_datenum', E.datenum);
                        w = addfield(w, 'ev_lat', E.lat);
                        w = addfield(w, 'ev_lon', E.lon);
                        w = addfield(w, 'ev_depth', E.depth);
                        w = addfield(w, 'ev_mag', E.mag);
                        w = addfield(w, 'ev_magtype', E.magtype);
                        %w = addfield(w, 'ev_quality', E.quality);
                        w = addfield(w, 'sta_lat', P(rB(1)).lat);
                        w = addfield(w, 'sta_lon', P(rB(1)).lon);
                        w = addfield(w, 'sta_elev', P(rB(1)).elev);
                        w = addfield(w, 'epiDist', P(rB(1)).epiDist);
                        for k = 1:numel(rB)
                            K = rB(k);
                            if strcmpi(P(K).phase,'P')
                                w = addfield(w, 'P_deltaT', P(K).deltaT);
                                w = addfield(w, 'P_datenum', P(K).datenum);
                            elseif strcmpi(P(K).phase,'S')
                                w = addfield(w, 'S_deltaT', P(K).deltaT);
                                w = addfield(w, 'S_datenum', P(K).datenum);
                            end
                        end
                        W = [W w];
                        clear w
                    end
                end
                cd(wd)
                save([id,'.mat'],'W')
                cd('C:\AVO\Deep LP')
                save('Master.mat','Master')
            end
        end
    end
end

%%
cd('C:\AVO\Deep LP\DLP_wfa')
EM = [];
for n = 1:numel(WD)
    try
        load(WD(n).name);
        %clc, disp(['[',num2str(n),'] - ',num2str(numel(W)),' waveforms']), pause(.01)
        EM.evid(n) = get(W(1),'evid');
        EM.ev_datenum(n) = get(W(1),'ev_datenum');
        EM.type{n} = get(W(1),'type');
        EM.lat(n) = get(W(1),'ev_lat');
        EM.lon(n) = get(W(1),'ev_lon');
        EM.depth(n) = get(W(1),'ev_depth');
        EM.mag(n) = get(W(1),'ev_mag');
        EM.magtype{n} = get(W(1),'ev_magtype');
        EM.numw(n) = numel(W);
    catch
        WD(n) = [];
    end
    
end

%% LOAD EVERY EVENT & COMPUTE MEDIAN & STACKED FREQUENCY
warning off
cd('C:\AVO\Deep LP\DLP_wfa')
N = numel(EM.evid);
for n = 1:N %numel(Master.evid)
    load([num2str(Master.evid(n)),'.mat'])
    disp(num2str(n))
    W = W(isvertical(W));
    P = get_picks(W,'p');
    W = W(find(P));
    P = P(find(P));
    fftA = zeros(1,512);
    for m = 1:numel(W)
        w = extract(W(m),'TIME',P(m),P(m)+20.48/24/60/60);
        w = filt(w,'hp',.5);
        f = get(w,'freq');
        if round(f) == 50
            [A, F] = pos_fft(w,'nfft',1024,'fr',[0 25],'taper',.025);
            A = [A; 0];
            F = [F; 0];
            fftA(m,:) = A(1:512)./nanmean(A(1:512));
        elseif round(f) == 100
            [A, F] = pos_fft(w,'nfft',2048,'fr',[0 25],'taper',.025);
            A = [A; 0];
            F = [F; 0];
            fftA(m,:) = A(1:512)./nanmean(A(1:512));
        end
    end
    [V R] = nanmax(fftA');
    EM.pfmed(n) = nanmedian(F(R));
    [V R] = nanmax(sum(fftA));
    EM.pfstk(n) = F(R);
end

%% SCATTER PLOT OF MEDIAN VS. STACKED FREQUENCY
%% RANDOM VARIATION ADDED FOR BETTER VIEW OF MARKER DENSITY
F1 = EM.pfmed;
F2 = EM.pfstk;
r1 = .02*rand(size(F1))-.01;
r2 = .02*rand(size(F2))-.01;
figure
scatter(F1+r1, F2+r2)
ylabel('Stacked Peak Frequency')
xlabel('Median Peak Frequency')

%% SORT ALL EVENT WAVEFORMS INTO A STATION STRUCTURE 'S'
%% ONLY VERTICAL COMPONENT CHANNELS WITH P-ARRIVALS ARE CONSIDERED
warning off
cd('C:\AVO\Deep LP\DLP_wfa')
N = numel(EM.evid);
S = [];
for n = 1:N %numel(Master.evid)
    load([num2str(EM.evid(n)),'.mat'])
    disp(num2str(n))
    W = W(isvertical(W));
    W = W(find(get_picks(W,'p')));
    for m = 1:numel(W)
        sta = strtrim(lower(get(W(m),'station')));
        if ~isfield(S,sta), S.(sta) = []; end
        S.(sta) = [S.(sta) W(m)];
    end
end

%% CROSS-CORRELATE ALL WAVEFORMS IN EACH FIELD OF 'S'
%% CLUSTER WAVEFORMS INTO FAMILIES
f = fieldnames(S);
FM = [];
for n = 1:numel(f)
    try
        disp(num2str(n))
        W = S.(f{n});
        T = get(W,'start');
        [V R] = sort(T);
        W = W(R);
        W = W(isvertical(W));
        P = get_picks(W,'p');
        W = W(find(P));
        P = P(find(P));
        
        clear w
        for m = 1:numel(W)
            w(m) = extract(W(m),'TIME',P(m),P(m)+10.24/24/60/60);
        end
        
        C = correlation(w);
        C = taper(C);
        C = butter(C,[1 10]);
        C = xcorr(C);
        C = sort(C);
        C = adjusttrig(C,'MIN');
        C = linkage(C);
        C = cluster(C,.75);
        stat = getclusterstat(C);
        FM.(f{n}) = stat;
        save(f{n},'W','C','stat')
        close all
        plot(C,'corr')
    catch
    end
end

%%  LOAD ALL WAVEFORMS FROM THE LARGEST FAMILY FOUND AT STATION 'n'
%%  PLOT THE WAVEFORMS & PICKS, AS WELL AS MAP SCATTER PLOT
%   EM - Event Master Structure
%   FM - Family Master Structure
f = fieldnames(FM);
n = 40;
load([f{n},'.mat'])
ind = FM.(f{n}).index{1};
ID = get(W(ind),'evid');
[A B] = intersect(EM.evid,ID);
plot_picks(W(ind),'ylab','time','scale',.25)
title(upper(f{n}))
figure, hold on,
for n=1:numel(L), plot(L(n).lon,L(n).lat,'k'), end
colorscat(EM.lon(B), EM.lat(B), 5.^(EM.mag(B)+.5), EM.pfmed(B))

%%  REMOVE EVENTS FROM EM WHICH ARE OVER 25km FROM A VOLCANIC CENTER
%   EM       - Event Master Structure
%   volc_loc - Volcanic Center Location Structure
LAT = EM.lat;
LON = EM.lon;
for n = 1:length(volc_loc.lat)
    vlat = volc_loc.lat(n).*ones(size(LAT));
    vlon = volc_loc.lon(n).*ones(size(LON));
    dist(n,:) = lldistkm(LAT,LON,vlat,vlon);
end
[EM.ev2volc, volcnumber] = min(dist);
EM.volc = volc_loc.name(volcnumber);
R = find(mindist <= 25);
EM = substruct(EM,R, 1);
clear LAT LON vlat vlon dist mindist R

%% PLOT DEM MAP OF COOK INLET WITH EVENTS SCATTERED ABOVE
%% (STILL NEED TO FIX COLOR BAR)
fh = figure;
ax = axes;
imagesc(map.lon,map.lat,map.elev)
set(fh,'Colormap',mycmap)
set(ax,'YDir','Normal')
axis image
hold on
colorscat(EM.lon, EM.lat, 6.^(EM.mag+.5), EM.depth)

%% 3-DIMENSIONAL SCATTER PLOT OF EVENTS BELOW ALASKA COASTLINE
fh = figure;
ax1 = axes;
hold on
for n=1:numel(L)
    plot3(L(n).lon,L(n).lat,zeros(size(L(n).lat)),'k')
end
scatter3(volc_loc.lon,volc_loc.lat,zeros(37,1),...
    '^','markerFaceColor','r','markerEdgeColor','k')
for n = 1:37
    plot3([1,1]*volc_loc.lon(n),[1,1]*volc_loc.lat(n),[0,-15],'r')
end
X = EM.pfmed;
X(X>10) = 10;
colorscat3(EM.lon, EM.lat, -EM.depth, 6.^(EM.mag+.5), X)
xlim([-185 -150])
ylim([50 63])
zlim([-50 10])
set(ax1,'CameraPosition',[5.371, -31.876 105.706])
set(ax1,'CameraTarget',[-167.5 56.5 -20])
set(ax1,'CameraViewAngle',8.638)
ax2 = axes('Position',[.9 .5 .08 .4]);
a = .5:.5:3.5; 
scatter(zeros(size(a)), a, 6.^(.5+a),'k')

%%
close all
for kk = 1:37
vn = volc_loc.name{kk};
%vn = 'ARC';
min_pf = 0;
max_pf = 10;

fh = figure;

ax1 = axes('Position',[.08 .51 .42 .42]);
hold on
switch lower(vn)
    case {'redoubt','spurr'}
        subIND = find(strcmpi(EM.volc,vn));
        subEM = substruct(EM,subIND,1);
        contour(ax1,map.lon,map.lat,map.elev,'LineColor','k') 
    case {'arc'}
        subEM = EM;
        for n=1:numel(L), plot(L(n).lon,L(n).lat,'k'), end
    otherwise
        subIND = find(strcmpi(EM.volc,vn));
        subEM = substruct(EM,subIND,1);
end
subPF = subEM.pfmed;
subPF(subPF>max_pf) = max_pf;
colorscat(subEM.lon, subEM.lat, 6.^(subEM.mag+.5), subPF, 'cbar', 0)
grid on
set(ax1,'XTickLab',[],...
    'XLim',[min(subEM.lon)-.02, max(subEM.lon)+.02],...
    'YLim',[min(subEM.lat)-.02, max(subEM.lat)+.02]);
ylabel('Northing (Degrees)')

ax2 = axes('Position',[.08 .06 .42 .42]);
switch lower(vn)
    case {'redoubt'}
        rlat = volc_loc.lat(25);
        [v r] = min(abs(map.lat - rlat));
        plot(map.lon,map.elev(r,:)./1000,'k')
        hold on
    case {'spurr'}
        rlat = volc_loc.lat(29);
        [v r] = min(abs(map.lat - rlat));
        plot(map.lon,map.elev(r,:)./1000,'k')
        hold on
    otherwise
end
colorscat(subEM.lon, -subEM.depth, 6.^(subEM.mag+.5), subPF, 'cbar', 0)
grid on
ylim([-50 10])
xlabel('Easting (Degrees)')
ylabel('Depth (km)')
linkaxes([ax1, ax2],'x')

Nx = 30;

ax3a = axes('Position',[.55 .53 .3 .18]);
x1 = min(subEM.depth);
x2 = max(subEM.depth);
dx = (x2-x1)/Nx;
colorhist(subEM.depth,subPF,Nx,64)
tick = x1+dx:2*dx:x2;
for n = 1:numel(tick), ticklb{n} = sprintf('%0.0f',tick(n)); end
set(ax3a,'XTick',tick);
set(ax3a,'XTickLab',ticklb);
xlabel('Depth (km)')
xlim([x1, x2])
grid on

ax3b = axes('Position',[.55 .75 .3 .18]);
x1 = min(subEM.mag);
x2 = max(subEM.mag);
dx = (x2-x1)/Nx;
colorhist(subEM.mag,subPF,Nx,64)
tick = x1+dx:4*dx:x2;
for n = 1:numel(tick), ticklb{n} = sprintf('%0.1f',tick(n)); end
set(ax3b,'XTick',tick);
set(ax3b,'XTickLab',ticklb);
xlabel('Magnitude')
xlim([x1, x2])
grid on

ax3c = axes('Position',[.55 .95 .3 .035]);
scatter(tick,zeros(size(tick)),6.^(tick+.5),'k')
set(ax3c,'Visible','off')
ylim([0, 1])
xlim([x1, x2])

ax4 = axes('Position',[.53 .06 .42 .42]);
colorscat(subEM.datenum, -subEM.depth, 6.^(subEM.mag+.5), subPF, 'cbar', 0)
grid on
set(ax4,'YTickLab',[])
dynamicDateTicks
ylim([-50 0])
xlabel('Time (years)')
linkaxes([ax2, ax4],'y')

ch = colorbar;
set(ch,'colormap','Jet')
tick = min_pf:max_pf;
for n = 1:numel(tick)
    ticklab{n} = [num2str(tick(n)),' Hz'];
end
tick = (tick-min_pf)./max_pf;
set(ch,'Position',[.87 .51 .03 .42],...
    'YTickMode','manual','YTickLabelMode','manual',...
    'YTick',tick,'YTickLabel',ticklab)
ax5 = axes('Position',[.15 .95 .45 .035],'Visible','off');
text(0,0,[upper(vn),' SUMMARY'],'FontSize',18)

warning off
set(fh,'PaperSize',[10 10],'PaperPosition',[.25 .25 9.5 9.5])

print(fh,'-dpdf','-r300',[vn,'_Summary.pdf'])
end


