
%%
path = fullfile('C:','Documents and Settings','dketner','Desktop',...
   'RED_Events','STA_LTA_Daily','REF','CORR');
for n = 1:32
   load(fullfile(path,['B',num2str(n,'%03.0f'),'.mat']))
   plot(c,'corr');
   set(gcf,'PaperType','B','PaperOrientation','portrait',...
      'PaperUnits','normalized','PaperPosition',[0,0,1,.55])
   print(gcf, '-dpng', fullfile(path,['B',num2str(n,'%03.0f')]))
   clear c
end
