function [pspec,f]=ps(x,dt)
%  [pspec,f]=ps(x,dt) calculates power spectrum 
%  for the time series x, divided into 50% overlap segments.
%  dt passed for correct scaling and setting frequencies
%  Equal to MATLAB's psd*2*dt  [units^s/freq].
%  Version 1.0 RKD 5/96, 2.0 2/97 (choose m=2**k)
x=x(:)';
% chunk and interpolate NaN values in both real and imaginary ts first.
if sum(isnan(x)) > 0, x=cleanx(x); end  % cleanx is an RKD routine
% now find new time series length
T=length(x);
% calculate various spectral parameters
n2=2.^(7:13);  % maximum spectral length is 8192
M=n2(max(find(n2<fix(T/5)))); % choose the longest M with at least 5 segments
nps=fix(2*T/M) - 1;  % number of 50% overlapping sections/spectra
window=hanning(M)';
I=(sum(window.^2));
W=M/I;               % variance lost by windowing
n2=(M/2)+1;          % number of points in spectra
pspec=zeros(1,n2-1); % initialize vector for +f only
                     % see how he uses the spanner!
for jj=1:nps
    nst=1+(jj-1)*M/2; nen=nst+M-1;
    XY=fft((window.*(detrend(x(nst:nen))))); % this is complex
    PS=XY.*conj(XY);                         % this is not complex
    pspec=pspec + 2*PS(2:n2);                % sum spectra
end
%
pspec=pspec*(dt*W/(M*nps));        % scale power spectra 
f=(1:length(pspec))*(1/(M*dt));    % set frequency vector
%
