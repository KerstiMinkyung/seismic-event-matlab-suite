function ping_spurr
% PING SPURR STATIONS

cd('C:\Work\SEMS\Ping_Times')
load T
c = size(T.time,1)+1;
for n = 1:numel(T.ip)
    T.time(c,n) = now;
    [status, result] = dos(['ping ',T.ip{n}], '-echo');
    tmp = regexp(result, '(Average = )([\d]*)','tokens');
    if ~isempty(tmp)
       T.pavg(c,n) = str2double(tmp{1,1}{1,2});
    else
       T.pavg(c,n) = nan;
    end
    pause(10)
end
save T.mat T

% % Spurr1_gw = '192.18.16.53';
% % SPCR_rp = '192.18.16.54';
% % SPBG_ep = '192.18.16.55';
% % Spurr2_gw = '192.18.16.56';
% % SPCG_ep = '192.18.16.57';
% % Spurr3_gw = '192.18.16.58';
% % SPCP_rp = '192.18.16.59';
% % SPCN_ep = '192.18.16.60'; 
% % Spurr4_gw = '192.18.16.61';
% % CKTCam_rep = '192.18.16.62';
% % SPCL_rep = '192.18.16.63'; 
% % SPNN_ep = '192.18.16.64'; 
% % Regional1_gw = '192.18.16.65';
% % SLK_ep = '192.18.16.66';
% % SLK_gw = '192.18.16.67';
% % ???? = '192.18.16.68';
% % ???? = '192.18.16.69';
% % ???? = '192.18.16.70';
% % SPCR_nrs = '192.18.16.71';
% % SPBG_nrs = '192.18.16.72';
% % SPCG_nrs = '192.18.16.73';
% % ???? = '192.18.16.74';
% % SLK_Q330 = '192.18.16.75'









