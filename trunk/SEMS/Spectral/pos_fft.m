function [A F] = pos_fft(w,varargin)

%% DEFAULT PROPERTIES
if (nargin >= 1) && isa(w,'waveform')
   d = get(demean(w),'data');
   l = length(d);
   nfft = 2^(nextpow2(l));
   Ny = get(w,'freq')/2;
   nfr = [0 1];
   smo = 0;
   tap = 0;
else
   error('pos_fft: first argument must be a waveform')
end

%% USER-DEFINED PROPERTIES
if (nargin > 1)
   v = varargin;
   nv = nargin-1;
   if ~rem(nv,2) == 0
      error(['pos_fft: Arguments after wave must appear in ',...
             'property name/val pairs'])
   end
   for n = 1:2:nv-1
      name = lower(v{n});
      val = v{n+1};
      switch name
         case 'nfft'      % Number of elements in Discrete Fourier Tansform
            nfft = val;
         case 'nfr'       % Normalized Frequency Range to return
            nfr = val;    %   [0 1] --> [0 Ny] Hz
         case 'smooth'    % Smooth resulting Amplitudes 
            smo = val; %   using this window size (# of samples)     
         case 'taper'     % Taper using a Hanning window (0 to 1)
            tap = val;  %   smaller value makes for steeper edges  
         otherwise
            error('real_fft: Property name not recognized')
      end
   end
end

%% FFT
x = fftshift(abs(fft(d,nfft)));
if rem(nfft,2)==0 % vector is even
   A = x(length(x)/2:end);
   f1 = Ny/((numel(A)-1)*2+1);
   F = linspace(f1,Ny,length(A))';
elseif rem(nfft,2)==1 % vector is odd
   A = x(ceil(length(x)/2):end); % 0 Hz not returned
   f1 = Ny/length(A);
   F = linspace(f1,Ny,length(A))';
end

%% SMOOTH AND TAPER (IF REQUESTED)
if smo>0
   A = fastsmooth(A,smo);
end
if tap>0
   A = A.*tukeywin(length(A),tap);
end

%% RETURN ONLY FREQS SPECIFIED BY 'nfr'
fr = nfr*Ny;
range = find((F>=fr(1))&(F<=fr(2)));
A = A(range);
F = F(range);