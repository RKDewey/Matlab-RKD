function [z,t]=isc(pspec,f,N);
% function [z,t]=isc(pspec,f,N);
% 
% Calculate the inverse FFT spectra of complex spectra pspec
%  with frequency base f.
% N = length of original time series 
% Return the complex time series z and time base t.
%   (t may need an off-set for absolute time).
% RKD 10/05
z=ifft(pspec);
fs=2*f(end);  % sample rate in Hz
T=N/fs;
dt=T/length(z);
t=[dt:dt:T];
% fini