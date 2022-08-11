function [pspec,k,f,extra]=ps2d(x,dx,dt,mfft,nfft,avg)
%  [pspec,k,f,extrastuff]=ps2d(x,dx,dt,mfft,nfft) calculates 2D power spectra
%  for the space/time series x, MATICES only(!) 
%  divided into 50% overlap segments if m/nfft large enough. 
%     dx,dt passed for correct scaling and setting frequencies
%     in space units (cm metres: wavelength = cpcm, cpm)
%     in time units (seconds, hours, days: freq = Hz, cph, cpd)
%	Returns:	Complex power spectrum (if x is complex)
%		k and wavenumbers, f are the frequencies.
% Optional input parameters are: 
%     mfft,nfft: length of fft segments, or 8 50% overlapping segments 
%     avg==1 to bin average higher freq/wavelengths (default=0)
% Optional output parameters are: 
%     a structure extra.psrms .M .W .nps .I1 .I2 .NENBW .ENBW  % extra stuff
%
%  Equal to MATLAB's psd*2*dt=psd/f_N  [units^s/freq]. or pwelch
%  Version 1.0 RKD 5/96, 2.0 2/97, 3.0 4/97  3.1 4/12

% chunk and interpolate NaN values in both real and imaginary ts first.
if nargin<6, avg=0; end % no bin averaging
[m,n]=size(x);

if sum(sum(isfinite(x))) < (m*n), % then there are NaNs or Infs
   ms=0;me=0;  % figure out the block of good data
   ns=0;ne=0;
   for i=1:m,
      if sum(isfinite(x(i,:))) > 0,
         if ms==0, ms=i; end
         me=i;
      end
   end
   for j=1:n,
      if sum(isfinite(x(:,j))) > 0,
         if ns==0, ns=j; end
         ne=j;
      end
   end
   %
   disp('Cleaning Matrix of NaNs and Infs. Please Wait...');
   for i=1:me,
      if isreal(x),
         xci=clean(real(x(i,:)),11,3);
       else
         xci=clean(real(x(i,:)),11,3) + clean(imag(x(i,:)),11,3);
      end
      xc(i,:)=xci;
%      if sum(isfinite(xci(ns:ne))) == (ne-ns+1), % then NaNs exist at ends of time series
%         if ms==0, ms=i; end % identify the start and 
%         me=i;  % end complete rows
%      end
   end
   x=xc(ms:me,ns:ne);
   xc=x;
   [m,n]=size(x);
   for i=1:m, % pad the ends of each time series with median
      igood=isfinite(x(i,:));ngood=sum(igood);
      indx=~isfinite(x(i,:));nindx=sum(indx);
      if nindx > 0 & ngood > 0,
         xc(i,indx)=median(x(i,igood))*ones(1,nindx);
      end
   end
   x=xc;
end
xc=x;
% now find new time series length
[m,n]=size(x);
% calculate various spectral parameters
if ~exist('mfft'), 
   mfft=fix(m/4.5);  % divide into 8 50% over-lapping segments
end
if ~exist('nfft'),
   nfft=fix(n/4.5); 
end
M=mfft;N=nfft;
%
npsm=fix(2*m/M) - 1;  % number of 50% overlapping sections/spectra
npsn=fix(2*n/N) - 1;  % number of 50% overlapping sections/spectra
if npsm < 1, npsm = 1; end
if npsn < 1, npsn = 1; end
%
if M > m | npsm == 1, M = m; end
if N > n | npsn == 1, N = n; end
if rem(M,2),
	m2=(M+1)/2;    % M is odd
	else
	m2=M/2;        % M is even
end
if rem(N,2),
	n2=(N+1)/2;    % M is odd
	else
	n2=N/2;        % M is even
end
windowm=hanning(M);
I1m=sum(windowm);
I2m=sum(windowm.^2);
Wm=M/I2m;               % variance lost by windowing
NEMBWm=M*I2m/(I1m^2);
ENBWm=I2m/(dt*I1m^2)
windown=hanning(N)';
I1n=sum(windown);
I2n=sum(windown.^2);
Wn=N/I2n;               % variance lost by windowing
NEMBWn=N*I2n/(I1n^2);
ENBWn=I2n/(dt*I1n^2)
%
pspecm=zeros(m2,n); % initialize vector for +f only
%
clear x
disp('Now looping through each row, then each column, please continue to wait...');
for j=1:n,  % loop through vertical time series, do spatial spectra
   x=xc(:,j);
   for ii=1:npsm   % loop for segment, fft, sum and average
       mst=1+(ii-1)*M/2; % use 50% overlap 
       men=mst+M-1;
       X=fft((windowm.*(detrend(x(mst:men)))),M); % this is complex
       if ii==1, 
          PS=X.*conj(X);
       else
          PS=PS+X.*conj(X);
       end
    end
   pspecm(:,j)=PS(2:m2+1)*(2*dx*Wm/(M*npsm));
end
%
pspec=zeros(m2,n2); % initialize vector for +f only
%
for i=1:m2,  % loop through
   x=pspecm(i,:);
   for jj=1:npsn   % loop for segment, fft, sum and average
       nst=1+(jj-1)*N/2; % use 50% overlap
       nen=nst+N-1;
       X=fft((windown.*(detrend(x(nst:nen)))),N); % this is complex
       if jj==1, 
          PS=X.*conj(X);
       else
          PS=PS+X.*conj(X);
       end
   end
   pspec(i,:)=PS(2:n2+1)*(2*dt*Wn/(N*npsn));   % sum spectra not including f=0
   psrms(i,:)=PS(2:n2+1)*(2/(npsn*I1n^2);
end
%
% if you want c.i. pspec*[plow,phi]=chisqp(95,nps) => a Dewey routine
f=(1:n2)*(1/(N*dt));    % set frequency vector
k=(1:m2)*(1/(M*dx));    % set wavenumber vector
if avg==1,
%
% Now bin average into increasing size frequency/wavelength bins
%
fravg=10^(ceil(min(log10(f)))+0.5);
kravg=10^(ceil(min(log10(k)))+0.5);
favg=0;
kavg=0;
navg=1;
iavg=0;
inew=0;
javg=0;
jnew=0;
pca=zeros(size(pspec(:,1)));
for j=1:n2-1
    if f(j) <= fravg
       javg=javg+1;
       favg=favg+f(j);
       pca=pca+pspec(:,j);
       if javg == navg
          jnew=jnew+1;
          fa(jnew)=favg/navg;
          psa(:,jnew)=pca/navg;
          javg=0;
          favg=0;
	  pca=zeros(size(pspec(:,1)));
       end
    else
       if javg >= 1
         jnew=jnew+1;
         fa(jnew)=favg/javg;
         psa(:,jnew)=pca/javg;
       end
       javg=0;
       favg=0;
       pca=zeros(size(pspec(:,1)));
       navg=navg*2;
       fravg=10^(log10(fravg)+0.5);
    end
end
if javg >= 1
   jnew=jnew+1;
   fa(jnew)=favg/javg;
   psa(:,jnew)=pca/javg;
end
pca=zeros(size(psa(1,:)));
navg=1;
%
for i=1:m2-1
    if k(i) <= kravg
       iavg=iavg+1;
       kavg=kavg+k(i);
       pca=pca+psa(i,:);
       if iavg == navg
          inew=inew+1;
          ka(inew)=kavg/navg;
          ps(inew,:)=pca/navg;
          iavg=0;
          kavg=0;
	  pca=zeros(size(psa(1,:)));
       end
    else
       if iavg >= 1
         inew=inew+1;
         ka(inew)=kavg/iavg;
         ps(inew,:)=pca/iavg;
       end
       iavg=0;
       kavg=0;
       pca=zeros(size(psa(1,:)));
       navg=navg*2;
       kravg=10^(log10(kravg)+0.5);
    end
end
if iavg >= 1
   inew=inew+1;
   ka(inew)=kavg/iavg;
   ps(inew,:)=pca/iavg;
end
%
pspec=ps;
f=fa;k=ka;
end % end bin averaging
surf(log10(k),log10(f),log10(pspec)');rotate3d on;
ylabel('Log_{10} Frequency [cph]');xlabel('Log_{10} Wavenumber [cpm]');
zlabel('Log_{10} Power Spectrum');
% fini
