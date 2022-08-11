function [pspec,f,coh,ci]=psplt(x,dt,nfft,slope,fign,y,coquad)
%  [pspec,f,coh,ci]=psplt(x,dt,nfft,slope,fign,y,coquad) calculates power (cross) spectra
%  for the time series x (and optionally y), vectors only(!) 
%  divided into 50% overlap segments. f are the frequencies.
%  dt passed for correct scaling and setting frequencies
%     in time units (seconds, hours, days: freq = Hz, cph, cpd)
% Calls Dewey's ps.m routine.
% Optional input parameters are: 
%     fign = figure number (default 1) and subplot [1 2 1 2]
%     y: (then output is cross spectra) or y=[]
%     nfft: length of fft segments, 
%           or pass nfft=1 if you want to routine to estimate nfft
%     slope = [#,#], then plot spectrum on loglog plot with slope = #/# or []
%     coquad = 1, then plot co and quad spectra
% Optional output parameters are: 
%     coh = |Pxy|./sqrt(Pxx.*Pyy);  % the corherency funtion
% For multiple plots with same axes: type: >global prange [-5 -1] frange [-4 1]
% Output:
%  pspec.raw=psect;
%  f.raw.f;
%  pspec.avg=psa;
%  f.avg=fa;
%  ci.f=fa;
%  ci.cfm=cf;
%  ci.cfl=cfl;
%  ci.cfh=cfh;

%
%  Equal to MATLAB's psd*2*dt=psd/f_N  [units^s/freq].
%  Version 1.0 RKD 5/96, 2.0 2/97, 3.0 4/97
global prange frange
if nargin < 3,
   [pspec,f,coh]=ps(x,dt);
   slope=[];
elseif nargin == 3 | nargin == 4,
   [pspec,f,coh]=ps(x,dt,nfft);
   fign=1;
elseif nargin >= 5 & ~exist('y'),
   [pspec,f,coh]=ps(x,dt,nfft);   
elseif nargin >= 5 & ~isempty(y),
   [pspec,f,coh]=ps(x,dt,nfft,y);
end
if ~exist('coquad'), coquad=0; end
T=length(x);
if exist('nfft'),  % check to see if user has set fft length
   M=nfft;         % yes...
else
   M=1;            % no... so do next if loop
end
if M == 1 | T >= 2*M,
   n2=2.^(5:16);   % maximum auto spectral length is 65536
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
%
psmin=min(log10(abs(pspec)));
psmax=max(log10(abs(pspec)));
% calculate number of degrees of freedom in original spectrum
I=sum(hanning(M).^2);
ndof=2*T/I;
if isempty(prange),
 prange=[floor(psmin) ceil(psmax)];
end
if isempty(frange),
 frange=[floor(min(log10(f))) ceil(max(log10(f)))];
end
pminc=(10^prange(1))*1.5;
pdec=prange(2)-prange(1); 
fdec=frange(2)-frange(1);
ndecad=max([pdec fdec]);
%
% Now bin average into increasing size frequency bins
%
fravg=10^(ceil(min(log10(f)))+0.5);
favg=0;
pca=0;
paca=0;
navg=1;
iavg=0;
inew=0;
[plow,phi]=chisqp(ndof,95.);
cmid=pminc/plow;
pmaxc=cmid*phi;
for i=1:n2-1
    if f(i) <= fravg
       iavg=iavg+1;
       favg=favg+f(i);
       pca=pca+pspec(i);
       if iavg == navg
          inew=inew+1;
          fa(inew)=favg/navg;
          psa(inew)=pca/navg;
          cf(inew)=cmid;
          cfl(inew)=cmid*plow;
          cfh(inew)=cmid*phi;
          iavg=0;
          favg=0;
          pca=0;
       end
    else
       if iavg >= 1
         inew=inew+1;
         fa(inew)=favg/iavg;
         psa(inew)=pca/iavg;
         cf(inew)=cmid;
         cfl(inew)=cmid*plow;
         cfh(inew)=cmid*phi;
       end
       iavg=0;
       favg=0;
       pca=0;
       navg=navg*2;
       ndof=ndof*2;
       [plow,phi]=chisqp(ndof,95.);
       fravg=10^(log10(fravg)+0.5);
    end
end
% calculate confidence intervals (hi=cfh and low=cfl)
if iavg >= 1
   inew=inew+1;
   fa(inew)=favg/iavg;
   psa(inew)=pca/iavg;
   cf(inew)=cmid;
   cfl(inew)=cmid*plow;
   cfh(inew)=cmid*phi;
end
pspec.raw=pspec;
f.raw=f;
pspec.avg=psa;
f.avg=fa;
ci.f=fa;
ci.cfm=cf;
ci.cfl=cfl;
ci.cfh=cfh;
%
flab(1)=0.1.*10^frange(2);
flab(2)=0.3.*10^frange(2);
%
fl=([10^(frange(1)+1) 10^(frange(1)+1.5)]);
tx1=10^(frange(1)+0.1); ty1=cmid;
line1=ones(2,1).*10.^(prange(2)-.35);
line2=ones(2,1).*10.^(prange(2)-.15);
%
figure(fign(1));
if length(fign)==1, 
    clf;
else
    subplot(fign(2),fign(3),fign(4));
end
if coquad == 0,
   loglog(fa,abs(psa),'k',fa,cfl,'g',fa,cf,'--g',fa,cfh,'g');
   text(tx1,ty1,'95%'),
   axis([10.^frange 10.^prange]);
   h=gca;
   YTick=get(h,'YTick');
   XTick=get(h,'XTick');
   if ~isempty(slope),
      psslope(slope(1),slope(2),length(XTick),length(YTick)-1);
   end
   apxy=get(gca,'Position');
   if apxy(4)>0.3,
      ylabel('Power Spectral Density [units^2/freq]');
   else
      ylabel('PS Density [units^2/freq]');
   end
else
   copsa=real(psa);
   qupsa=-imag(psa);
   semilogx(fa,copsa.*fa,'b',fa,qupsa.*fa,'r'); % Plot variance preserving 
   title('Co-Spectrum(b)/Quad-Spectrum(r)')
   apxy=get(gca,'Position');
   if apxy(4)>0.3,
      ylabel('Variance Preserving Power Spectra Density');
   else
      ylabel('Variance Preserving PSD');
   end
   varco=sum(real(pspec.raw))*(fa(2)-fa(1));
   varqu=sum(-imag(pspec.raw))*(fa(2)-fa(1));
   YTick=get(gca,'YTick');
   yl=length(YTick);
   XTick=get(gca,'XTick');
   xl=length(XTick);
   text(XTick(xl-1),(YTick(yl)-0.3*(YTick(yl)-YTick(yl-1))),['Var_{co}=',num2str(varco)]);
   text(XTick(xl-1),(YTick(yl)-0.6*(YTick(yl)-YTick(yl-1))),['Var_{quad}=',num2str(varqu)]);
end
xlabel('Frequency');
%
% fini
