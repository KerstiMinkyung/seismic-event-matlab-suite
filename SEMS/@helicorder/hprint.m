function hprint(hh,varargin)

% hh - helicorder object or handle of helicorder figure

if ishandle(hh)
   fh = hh;
elseif isa(hh,'helicorder')
   fh = build(hh);
else
   error(['@HELICORDER/HPRINT: First Argument is neither helicorder',...
          'object, nor figure handle'])
end

if nargin == 1
   path = 'temp';
end

set(fh,'PaperType','A','PaperOrientation','portrait',...
       'PaperUnits','normalized','PaperPosition',[0,0,1,1])

print(fh, '-djpeg', path) 

uisave(path)