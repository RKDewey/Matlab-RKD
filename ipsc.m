function [z,t]=ipsc(pspec,f);
% function [z,t]=ipsc(pspec,f);
% 
% Calculate the inverse FFT spectra of complex spectra pspec
%  with frequency base f.
% Return the complex time series z and time base t.
%   (t may need an off-set for absolute time).
% RKD 10/05
z=ifft(pspec);
dt=1/(2*f(end));
t=[dt:dt:length(z)*dt];
% fini