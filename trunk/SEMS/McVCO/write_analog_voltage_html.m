function write_analog_voltage_html(M,dir)

time{1} = 'week';
time{2} = 'month';
time{3} = '3month';
time{4} = 'year';
time{5} = 'all';

subnets = fieldnames(M);
for t = 1:numel(time)
    T = time{t};
    fid1 = fopen([dir,'\','Analog-network-voltages-',T,'.html'],'w+');
    
    fprintf(fid1,'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">\n')
    fprintf(fid1,'<html>\n')
    fprintf(fid1,'<head>\n')
    fprintf(fid1,'  <meta content="text/html; charset=ISO-8859-1"\n')
    fprintf(fid1,' http-equiv="content-type">\n')
    fprintf(fid1,'  <title>Analog-network-voltages-%s</title>\n',T)
    fprintf(fid1,'  <style>\n')
    fprintf(fid1,'    h1 {text-align: center; font-family: Agency FB;}\n')
    fprintf(fid1,'    h2 {text-align: center; font-family: Agency FB;}\n')
    fprintf(fid1,    'h3 {text-align: center; font-family: Agency FB;}\n')
    fprintf(fid1,'  </style>\n')
    fprintf(fid1,'</head>\n')
    fprintf(fid1,'<body style="width: 1200px;">\n')
    fprintf(fid1,'<div style="text-align: center;">\n')
    fprintf(fid1,'<h2><big>AVO - Analog Network Voltages</big></h2>\n')
    fprintf(fid1,'<hr style="width: 100%%; height: 2px;">\n')
    fprintf(fid1,'<h3>View:  [<a href="Analog-network-voltages-week.html">Week</a>]\n')
    fprintf(fid1,'- [<a href="Analog-network-voltages-month.html">Month</a>]\n')
    fprintf(fid1,'- [<a href="Analog-network-voltages-3month.html">3Month</a>]\n')
    fprintf(fid1,'- [<a href="Analog-network-voltages-year.html">Year</a>]\n')
    fprintf(fid1,'- [<a href="Analog-network-voltages-all.html">Everything!</a>]\n')
    fprintf(fid1,'</h3>\n')
    fprintf(fid1,'<hr style="width: 100%%; height: 2px;">\n')
    fprintf(fid1,'<img src="colorbar.png"; height="600"; width="60"; style="position:fixed; margin-left:600px;">\n')
    fprintf(fid1,'<hr style="width: 100%%; height: 2px;">\n')    
    fprintf(fid1,'</div>\n')
    fprintf(fid1,'<div style="text-align: center; font-family: Agency FB;">\n')
    
    for n = 1:numel(subnets)
        
        SU = subnets{n};
        
        fprintf(fid1,'<h2>\n')
        fprintf(fid1,'  <a href="%s-voltages-%s.html">%s</a>\n',SU,T,upper(SU))
        fprintf(fid1,'</h2>\n')
        fprintf(fid1,'<h2>\n')
        fprintf(fid1,'  <img src="network_voltage_plots/%s-%s.png"\n',SU,T)
        fprintf(fid1,'   alt="%s %s-long analog voltage plot"\n',SU,T)
        fprintf(fid1,'   title="%s %s-long analog voltage plot" align="middle"><br>\n',SU,T)
        fprintf(fid1,'</h2>\n')
        
        stations = fieldnames(M.(SU));
        fid2 = fopen([dir,'\',SU,'-voltages-',T,'.html'],'w+');
        fprintf(fid2,'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">\n')
        fprintf(fid2,'<html>\n')
        fprintf(fid2,'<head>\n')
        fprintf(fid2,'  <meta content="text/html; charset=ISO-8859-1"\n')
        fprintf(fid2,'http-equiv="content-type">\n')
        fprintf(fid2,'  <title>%s-Voltages-%s</title>\n',SU,T)
        fprintf(fid2,'  <style>\n')
        fprintf(fid2,'    h1 {text-align: center; font-family: Agency FB;}\n')
        fprintf(fid2,'    h2 {text-align: center; font-family: Agency FB;}\n')
        fprintf(fid2,'    h3 {text-align: center; font-family: Agency FB;}\n')
        fprintf(fid2,'  </style>\n')
        fprintf(fid2,'</head>\n')
        fprintf(fid2,'<body style="width: 1200px;">\n')
        fprintf(fid2,'<h2><big>Alaska Volcano Observatory - State of Health Monitoring</big></h2>\n')
        fprintf(fid2,'<h2><big>%s Analog Network Voltages</big></h2>\n',SU)
        fprintf(fid2,'<hr style="width: 100%%; height: 2px;">\n')
        fprintf(fid2,'<div style="text-align: center;">\n')
        fprintf(fid2,'<h3><a href="Analog-network-voltages-%s.html">Return to All Networks</a></h3>\n',T)
        fprintf(fid2,'<h3>View:  [<a href="%s-voltages-week.html">Week</a>]\n',SU)
        fprintf(fid2,'- [<a href="%s-voltages-month.html">Month</a>]\n',SU)
        fprintf(fid2,'- [<a href="%s-voltages-3month.html">3Month</a>]\n',SU)
        fprintf(fid2,'- [<a href="%s-voltages-year.html">Year</a>]\n',SU)
        fprintf(fid2,'- [<a href="%s-voltages-all.html">Everything!</a>]</h3>\n',SU)
        fprintf(fid2,'</div>\n')
        fprintf(fid2,'<hr style="width: 100%%; height: 2px;">\n')
        fprintf(fid2,'<div style="text-align: center; font-family: Agency FB;">\n')
        
        count = 1;
        for m = 1:numel(stations)
            ST = stations{m};
            channels = fieldnames(M.(SU).(ST));
            for k = 1:numel(channels)
                CH = channels{k};
                if ~rem(count,2)==0      % ODD
                    fprintf(fid2,'<h2>\n')
                else                     % EVEN
                    fprintf(fid2,'&nbsp;\n')
                    fprintf(fid2,'&nbsp;\n')
                end
                
                fprintf(fid2,'<img src="channel_voltage_plots/%s_%s-%s.png"\n',ST,CH,T)
                fprintf(fid2,'alt="%s:%s %s-long analog voltage plot"\n',ST,CH,T)
                fprintf(fid2,'title="%s:%s %s-long analog voltage plot" align="middle">\n',ST,CH,T)
                
                if rem(count,2)==0       % EVEN
                    fprintf(fid2,'<br>\n')
                    fprintf(fid2,'</h2>\n')
                end    
                count = count+1;
            end
        end
        fprintf(fid2,'</div>\n </body>\n </html>\n')
        fclose(fid2)
    end
fprintf(fid1,'</div>\n </body>\n </html>\n')
fclose(fid1)
end














