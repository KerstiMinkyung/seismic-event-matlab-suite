
function scat2img(X,Y,varargin)

% SCAT2IMG: Scatter plot 

%% CHECK X AND Y INPUTS
if nargin < 2
   error('scat2img: Not enough input arguments, X and Y vectors required.')
elseif length(X)~=length(Y)
   error('scat2img: X and Y vectors must be of equal length.')
elseif isnumeric(X)~=1 || isnumeric(X)~=1
   error('scat2img: X and Y vectors must be numeric.')  
end

%% DEFAULT PROPERTIES
xsize = 800;   % Number of columns in image
ysize = 600;   % Number of rows in image
xlim = [min(X) max(X)];
ylim = [min(Y) max(Y)];
gamma = 0;
mask = 0;
win = 8;

%% USER-DEFINED PROPERTIES
if (nargin > 2)
   v = varargin;
   nv = nargin-2;
   if ~rem(nv,2) == 0
      error(['scat2img: Arguments after X and Y vectors must appear in',...
             ' property name/val pairs'])
   end
   for n = 1:2:nv-1
      name = lower(v{n});
      val = v{n+1};
      switch name
         case 'xlim'
            xlim = val;
         case 'ylim'    
            ylim = val;
         case 'xsize'
            xsize = val;
         case 'ysize'    
            ysize = val;   
         case 'size'    
            xsize = val(1);  
            ysize = val(2);
         case 'gamma'    
            gamma = val;
         case 'mask'    
            mask = val;            
         case 'smooth'    
            win = val;            
         otherwise
            error('scat2img: Property name not recognized')
      end
   end
end

%% TRIM DATA OUTSIDE XLIM & YLIM
keep = find(X<=xlim(2) & X>=xlim(1) & Y<=ylim(2) & Y>=ylim(1));
X = X(keep); Y = Y(keep);

%%
dx = (xlim(2)-xlim(1))/xsize;
dy = (ylim(2)-ylim(1))/ysize;

xx = xlim(1):dx:xlim(2);
yy = ylim(1):dy:ylim(2);

tmp = X-min(X);
Xg = floor(tmp/max(tmp)*xsize)+1;

tmp = Y-min(Y);
Yg = floor(tmp/max(tmp)*ysize)+1;
clear tmp
img = zeros(ysize,xsize);

for n=1:numel(Yg)
   try img(Yg(n),Xg(n)) = img(Yg(n),Xg(n))+1; catch end
end

%% SMOOTH IMG
gw= exp( -((1:win-win/2)/(win/5)).^2)'; % Create Gaussian Window Length=win
img = conv2(img, gw); img = img';       % Smooth vertically
img = conv2(img, gw); img = img';       % Smooth horizontally

%% SCALE
inf = -20-10*gamma; % inf is the lowest possible value in img, by incresing 
                    % gamma, inf decreases, and the range of values in img 
                    % becomes broader, i.e. image becomes brighter
cut = -20+10*mask;  % cut is the transparency threshold, by incresing mask, 
                    % cut increases, and less of the image is displayed.
                    % cut should be greater or equal to inf
M=max(max(img));
warning off
img = 10*log10(img/M);
warning on

%% PLOT SCATTER, THEN OVERLAY IMG
figure, hold on
scatter(X,Y,'MarkerEdgeColor',[0 0 0],'Marker','.')
H = imagesc(xx,yy,img,[inf,0]);
set(H,'alphadata',img > cut)
set(gca,'YDir','normal') 
colormap(hot)
set(gca,'xlim',xlim)
set(gca,'ylim',ylim)



