function CM = stacc2master(EM)

%%
sd = 'C:\AVO\DeepQuake\Station_XCorr';
SD = dir(sd);
SD(1:2) = []; % Get rid of '.' and '..'

nid = numel(EM.evid);
CM.nsta = zeros(nid);
CM.cccum = zeros(nid);
CM.cc070cnt = zeros(nid);

for n = 1:numel(SD)
    clc, disp(num2str(n)), pause(.01)
    id = SD(n).name;
    load(fullfile(sd,id));
    [ID,iW,iM] = intersect(get(W,'evid'),EM.evid);
    nw = numel(W);
    cc = get(C,'corr');
    for m = 1:nw-1
        CM.nsta(iM(m),iM(m+1:end)) = ...
        CM.nsta(iM(m),iM(m+1:end)) + 1;
    
        CM.cccum(iM(m),iM(m+1:end)) = ...
        CM.cccum(iM(m),iM(m+1:end)) + cc(m,m+1:end);
    
        CM.cc070cnt(iM(m),iM(m+1:end)) = ...
        CM.cc070cnt(iM(m),iM(m+1:end)) + round(cc(m,m+1:end)-.2);
    end
end
CM.nsta = CM.nsta + CM.nsta';
CM.cccum = CM.cccum + CM.cccum';
CM.cc070cnt = CM.cc070cnt + CM.cc070cnt';
CM.ccmean = CM.cccum./CM.nsta;