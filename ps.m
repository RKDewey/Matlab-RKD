function [pspec,f,coh,extra]=ps(x,dt,nfft,y)
%  [pspec,f,coh,extra]=ps(x,dt,nfft,y) calculates power (cross) spectral density
%  for the time series x (and optionally y), vectors only(!) 
%  divided into 50% overlap segments, Hanning windowed. f are the frequencies.
%  dt passed for correct scaling and setting frequencies
%     in time units (seconds, hours, days: freq = Hz, cph, cpd)
% Optional input parameters are: 
%     y: (then output is cross spectra)
%     nfft: length of fft segments, 
%           or pass nfft=1 if you want to routine to estimate nfft
% Optional output parameters are: 
%     coh = |Pxy|./sqrt(Pxx.*Pyy);  % the corherency funtion
%     structure: extra.psrms .M .W .nps .I1 .I2 .NENBW .ENBW  % extra stuff
%
%  Equal to MATLAB's psd*2*dt=psd/f_N  [units^2/freq], now pwelch(x,hanning(M));
%  Version 1.0 RKD 5/96, v2.0 2/97, v3.0 4/97, v3.1 4/12
%  Good references are Bendat and Peirsol, and 
%        the piece by Heinzel, Rudiger, and Schilling (GH_FFT.pdf)
x=x(:)';
iy=0;
if exist('y'), 
    iy=1; 
    y=y(:)'; 
else
    y=[];
end  % only do cross stuff if y exists.
if exist('nfft'),  % check to see if user has set fft length
   M=nfft;         % yes...
else
   M=fix(length(x)/4.5);   % no... then use 8 overlapping segments
% this next block is old code, finding nearest 2^n length to optimize fft
% for really long (1e8) time series, choose a nfft=2^n
%   n2=2.^(5:16);   % maximum auto spectral length is 65536
%   M=n2(max(find(n2<fix(2*T/3)))); % choose the longest M with at least 3 segments
%   if isempty(M),  % if that didn't work, choose less segments
%      M=n2(max(find(n2<fix(T)))); % choose the longest M with 1 segments
%   end
end
if iy==1 & (length(y)/1.9) < M,
   disp(' You must segment dataset in order to get none-one coherencies.');
end
% chunk and interpolate NaN values in both real and imaginary ts first.
if sum(isnan(x)) > 0, x=cleanx(x); end  % cleanx is an RKD routine
if iy==1, 
    if sum(isnan(y)) > 0, y=cleanx(y); end; 
end
% now find new time series length
T=length(x);
if iy == 1,
   Ty=length(y);
   if Ty ~= T, 
      disp(['Cleaned X and Y vectors not same length.']);
      return
   end
end
% calculate various spectral parameters
nps=fix(2*T/M) - 1;  % number of 50% overlapping sections/spectra
if nps < 1, nps = 1; end
if M > length(x) | nps == 1, M = length(x); end
if rem(M,2),
	n2=(M+1)/2;    % M is odd
	else
	n2=M/2;        % M is even
end
window=hanning(M)';  % or pick some other window shape
I1=sum(window);     % the sum of the window weights (also S1)
I2=(sum(window.^2));  % determine the power of this window (also S2)
W=M/I2;      % then this is the variance lost by windowing, aka coherent power gain
NENBW=M*I2/(I1^2);    % the normalized equivalent noise bandwidth
ENBW=I2/(dt*I1^2);    % the effective noise bandwidth
pspec=(0+sqrt(-1)*0)*ones(1,n2); % initialize vector for +f only
coh=pspec; PXX=pspec; PYY=pspec; % initialize coherency vectors
%
for jj=1:nps   % loop for segment, fft, sum and average
    nst=fix(1+(jj-1)*M/2);
    nen=nst+M-1;
    indx=[nst:nen];
    X=fft((window.*(detrend(x(indx)))),M); % this is complex FFT/DFT
    if iy==1,                    % this loop only if cross spectra/coh
       Y=fft((window.*(detrend(y(indx)))),M); % this is complex
       PS=Y.*conj(X);      % calculate the cross spectra [see B&P (9.3)]
    else
       PS=X.*conj(X);      % or just the auto-spectra, this is not complex
    end
    if iy == 1,  % in addition, calculate Pxx and Pyy for coherency 
       Pxx=X.*conj(X);
       Pyy=Y.*conj(Y);
    end
    pspec=pspec + PS(2:n2+1);   % sum spectra not including f=0
    if iy==1,
       PXX=PXX + Pxx(2:n2+1);   % Must sum the spectra before calculating
       PYY=PYY + Pyy(2:n2+1);   % the coherency function, otherwise coh=1.0
    end
end
%
if iy==1,
   coh = abs(pspec)./sqrt(PXX.*PYY);   % calculate coherency function
else
   coh = [];
end
%
psrms=pspec*(2/(nps*I1^2));   % in case this is of interest
pspec=pspec*(2*dt*W/(M*nps));    % scaled power spectra, also psrms/ENBW
% if you want c.i. pspec*[plow,phi]=chisqp(95,nps) => a Dewey routine
f=[(1:length(pspec))*(1/(M*dt))]';    % set frequency vector
pspec=pspec(:);f=f(:);
if nargout > 3,
   extra=struct('psrms',psrms(:),'M',M,'W',W,'nps',nps,'I1',I1,'I2',I2,'NENBW',NENBW,'ENBW',ENBW);
end 
% fini
