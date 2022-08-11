function [pspec,f]=psc(z,dt,nfft)
%  [pspec,f]=psc(z,dt,nfft) calculates complex spectra
%  for the complex time series z=x+iy, vectors only(!) 
%  divided into 50% overlap segments. f are the frequencies.
%  dt passed for correct scaling and setting frequencies
%     in time units (seconds, hours, days: freq = Hz, cph, cpd)
% Optional input parameters are: 
%     nfft: length of fft segments, 
%           or pass nfft=1 if you want to routine to estimate nfft
% To check spectra, loglog(f,abs(pspec))
%
%  based on RKD ps 5/96, 2.0 2/97, 3.0 4/97
%  10/05
x=real(z);y=imag(z);
x=x(:)';
y=y(:)';
% chunk and interpolate NaN values in both real and imaginary ts first.
if sum(isnan(x)) > 0, x=cleanx(x); end  % cleanx is an RKD routine
if sum(isnan(y)) > 0, y=cleanx(y); end 
% now find new time series length
T=length(x);
% calculate various spectral parameters
if exist('nfft'),  % check to see if user has set fft length
   M=nfft;         % yes...
else
   M=1;            % no... so do next if loop
end
if M == 1,
   n2=2.^(5:13);   % maximum auto spectral length is 8192
   M=n2(max(find(n2<fix(T/5)))); % choose the longest M with at least 5 segments
   if isempty(M),  % if that didn't work, choose less segments
      M=n2(max(find(n2<fix(T)))); % choose the longest M with 1 segments
   end
end
nps=fix(2*T/M) - 1;  % number of 50% overlapping sections/spectra
if nps < 1, nps = 1; end
if M > length(x) | nps == 1, M = length(x); end
if rem(M,2),
	n2=(M+1)/2;    % M is odd
	else
	n2=M/2;        % M is even
end
window=hanning(M)';
I=(sum(window.^2));
W=M/I;               % variance lost by windowing
pspec=(0+sqrt(-1)*0)*ones(1,n2); % initialize vector for +f only
if nargout==3, coh=pspec; PXX=pspec; PYY=pspec; end % initialize coherency vectors
%
for jj=1:nps   % loop for segment, fft, sum and average
    nst=1+(jj-1)*M/2; nen=nst+M-1;indx=fix([nst:nen]);
    XY=fft((window.*(detrend(x(indx))+sqrt(-1)*detrend(y(indx)))),M); % this is complex
    pspec=pspec + XY(2:n2+1);   % sum spectra not including f=0
end
%
pspec=pspec*(2*dt*W/(M*nps));      % scale power spectra 
% if you want c.i. pspec*[plow,phi]=chisqp(95,nps) => a Dewey routine
f=(1:length(pspec))*(1/(M*dt));    % set frequency vector
% fini
