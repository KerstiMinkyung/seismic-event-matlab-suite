
% Broadband ZPK - work in progress
% Gurlap CMD-6TD

Fs = 50;
p_hz = [-23.65e-3 +i*23.65e-3, -23.65e-3 -i*23.65e-3,...
        -393.011 -7.4904,...
        -53.5979 -i*21.7494, -53.5979 +i*21.7494];   
z_hz = [-5.03207, 0, 0];
k_hz = 1.983e6;
z = z_hz/Fs*2*pi;
p = p_hz/Fs*2*pi;
k = k_hz/Fs*2*pi;
[b,a] = zp2tf(z',p',k);
zplane(z,p)
freqz(b,a)

 
 