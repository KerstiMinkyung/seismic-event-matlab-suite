function sst_out = add_sst(sst_1,sst_2,varargin)
%ADD_SST: 
%
%USAGE: sst_out = add_sst(sst_1,sst_2)
%       sst_out = add_sst(sst_1,sst_2,mode) 
%
%INPUTS: sst_1 -->
%        sst_2 -->
%        mode  -->
%
%OUTPUTS: sst_out -->


%%
method = 0; % default method, don't merge new sst
if nargin < 2
   error('ADD_SST: Too few input arguments')
elseif nargin > 3
   error('ADD_SST: Too many input arguments')
elseif nargin == 3
   switch lower(varargin{1})
      case 'merge'
         method = 1; % merge new sst
   end
end

%%
s1 = size(sst_1,1);
s2 = size(sst_2,1);
if s1==0 && s2==0
   sst_out = []; return
elseif s1==0 && s2>0
   sst_out = sst_2; return
elseif s2==0 && s1>0
   sst_out = sst_1; return
else 
   if s1 >= s2
      % Good to go
   elseif s2 > s1 % Swap sst_1 and sst_2 variables
      sst_temp = sst_1; stemp = s1;
      sst_1 = sst_2; s1 = s2;
      sst_2 = sst_temp; s2 = stemp;  
   end
   
   for n = 1:s2
      x = sst_2(n,:);
      [N P] = search_sst(x(1),sst_1);
      if N == 1 && P == 0
         sst_1 = [x; sst_1];
      elseif N == 1 && P == 1
         sst_1 = [sst_1(1,:); x; sst_1(2:end,:)];
      elseif N == s1 && P == 1
         sst_1 = [sst_1; x];
      elseif N == s1+1 && P == 0
         sst_1 = [sst_1; x];
      elseif P == 0
         sst_1 = [sst_1(1:N-1,:); x; sst_1(N:end,:)];
      elseif P == 1
         sst_1 = [sst_1(1:N,:); x; sst_1(N+1:end,:)];
      end
      s1 = size(sst_1,1);
   end
   if method == 1
   sst_1 = merge_sst(sst_1);
   end
end

sst_out = sst_1;