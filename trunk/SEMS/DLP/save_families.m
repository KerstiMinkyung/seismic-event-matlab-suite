function save_families(EM, FAM)

% This program is an ad hoc sack of shit
% There has to be a clearer way...

wd = 'C:\AVO\DeepQuake\Waveform_Objects\';
fd = 'C:\AVO\DeepQuake\Families\';
ds = 1/24/60/60;
for jj = 1:numel(FAM.evid)
    WW = [];
    for kk = 1:numel(FAM.evid{jj})
        load([wd,num2str(FAM.evid{jj}(kk)),'.mat'])
        WW = [WW, W];
    end
    WW = WW(isvertical(WW));
    p = get(WW,'P_DATENUM');
    P = [];
    K = [];
    if iscell(p)
        for k = 1:numel(p)
            P = [P p{k}];
            if isempty(p{k})
                K = [K k];
            end
        end
    else
        P = p;
    end
    WW(K) = [];
    sta = get(WW,'station');
    [val, cnt] = count_unique(sta);
    val(cnt == 1) = [];
    cnt(cnt == 1) = [];
    [x, ind] = sort(cnt,'descend');
    list = val(ind);
    for ss = 1:numel(list)
        remain = get(WW,'station');
        sub = strcmp(list{ss},remain);
        w = WW(sub);
        p = get(w,'P_DATENUM');
        c = correlation(w);
        c = set(c,'trig',p);
        c = taper(c);
        c = butter(c,[1 10]);
        c = xcorr(c,[-1 14]);
        c = adjusttrig(c,'MIN');
        t = get(c,'trig');
        [t ind] = sort(t);
        w = w(ind);
        c = sort(c);
        FW.(list{ss}).c = c;
        for n = 1:numel(p)
            FW.(list{ss}).w(n) = extract(w(n), 'TIME', t(n)-5*ds, t(n)+15*ds);
        end
        WW(sub) = [];
        
        fh = figure('Position',[1,1,2000,1000]);
        ax1 = axes('position',[.11 .01 .4 .98]);
        plot_picks(FW.(list{ss}).w)
        ax2 = axes('position',[.51 .01 .48 .98]);
        imagesc(get(c,'corr'))
        
        name = [fd,'Fam',sprintf('%03d',jj),list{ss}];
        export_fig(name,'-pdf')
        close all
    end
    save([fd,'Fam',sprintf('%03d',jj)],'FW')
    clear WW kk W p P K sta val cnt x ind list ss remain sub w FW
end