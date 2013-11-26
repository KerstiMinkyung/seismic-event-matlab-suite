
%% DEEP LP PROJECT

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
cd(wd)
Master = [];
for n = 1:numel(WD)
    try
    load(WD(n).name);
    %clc, disp(['[',num2str(n),'] - ',num2str(numel(W)),' waveforms']), pause(.01)
    Master.evid(n) = get(W(1),'evid');
    Master.ev_datenum(n) = get(W(1),'ev_datenum');
    Master.type{n} = get(W(1),'type');    
    Master.lat(n) = get(W(1),'ev_lat');
    Master.lon(n) = get(W(1),'ev_lon');    
    Master.depth(n) = get(W(1),'ev_depth');
    Master.mag(n) = get(W(1),'ev_mag');
    Master.magtype{n} = get(W(1),'ev_magtype');
    Master.numw(n) = numel(W);
    catch
        WD(n) = [];
    end
   
end

%%
cd(Master.wf_dir)
for n = 501:510%numel(Master)
    load([num2str(Master.evid(n)),'.mat'])
    A = [];
    F = [];
    for m = 1:numel(W)
       sta = get(W(m),'channel');
       if strcmpi(sta(3),'z') && isfield(W(m),'P_DATENUM')
           pt = get(W(m),'P_DATENUM');
           freq = get(W(m),'FREQ');
           w = extract(W(m), 'TIME', pt, pt+20.48/24/60/60);
           w = filt(w,'bp',[1 25]);
           if freq == 100
               nfft = 2048;
           elseif freq == 50
               nfft = 1022;
           end
           [a, f] = pos_fft(W(m),'nfft',nfft,'fr',[0 25]);
           if isempty(A)
               A = a/sum(a);
           else
               A = [A,a/sum(a)];
           end
       end
    end
    figure
    plot(f,median(A'))
    figure
    plot_picks(W)
    pause(2)
    close all
end

%%
warning off
cd('C:\AVO\Deep LP\DLP_wfa')
for n = 1:numel(Master.evid)
    load([num2str(Master.evid(n)),'.mat'])
    W = W(isvertical(W));
    fftA = zeros(1,512);
    p = [];
    for m = 1:numel(W)
        p = get(W(m),'P_DATENUM');
        if ~isempty(p)
            w = extract(W(m),'TIME',p,p+20.48/24/60/60);
            p = [];
            w = filt(w,'hp',.5);
            f = get(w,'freq');
            if round(f) == 50
                [A, F] = pos_fft(w,'nfft',1024,'fr',[0 25],'taper',.025);
                A = [A; 0]; F = [F; 0];
                fftA(m,:) = A(1:512)./nanmean(A(1:512));
            elseif round(f) == 100
                [A, F] = pos_fft(w,'nfft',2048,'fr',[0 25],'taper',.025);
                A = [A; 0]; F = [F; 0];
                fftA(m,:) = A(1:512)./nanmean(A(1:512));
            end
        end
    end
    if sum(fftA(1,:))>0
        [V R] = nanmax(fftA');
        Master.pfmed(n) = nanmedian(F(R));
        [V R] = nanmax(sum(fftA));
        Master.pfstk(n) = F(R);
    else
        Master.pfmed(n) = NaN;
        Master.pfstk(n) = NaN;
    end
    %clear A F pf fftA V R w W
    disp(num2str(n))
end

