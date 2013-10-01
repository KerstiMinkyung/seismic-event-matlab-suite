%% ping timer
pt = timer('BusyMode', 'queue', 'ExecutionMode', 'fixedRate',...
           'Period', 1800, 'TimerFcn', 'ping_spurr');
start(pt)