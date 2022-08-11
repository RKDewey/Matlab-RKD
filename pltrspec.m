function pltrspec(pscw,psacw,M,T,dt,slope,frange,prange,fvar,vp)
%  PLTRSPEC(pscw,psacw,M,T,dt,slope,frange,prange,fvar,vp) plots rotary spectrum from fft(z)
%  for the complex time series z=x+iy, divided into nps 50% overlap segments.
%  These spectra can be calculated by [pscw,psacw,M,T]=rotspec(x,y,dt,nps);
%  dt is in the units for plotting of cycles per time (cps, cph, cpd)
%  Optional: slope=[rise,run(,xst,yst)], to plot a line of slope=slope [-5,3]=-5/3
%       frange can be pre-set ([log(fmin) log(fmax)]) for multiple plots
%       prange [log(psmin) log(psmax)].
%       if frange OR prange =[], sets internally
%       fvar=[flow fhigh] a frequency band to integrate variance over
%       vp = 0 (default) or 1 (variance perserving *f)
%   *  Scales the Fourier coefficients with dt so that ordinate
%	 properly indicates the units X^2/Hz, X^2/cph, X^2/cpd etc.
%   *  Axis labels and title are not written.
%   *  Draws a line of slope = rise/run (or none if =[0,0])
%  Note: Negative Frequency (phase) spectral part=clockwise component
%        For clockwise phase, phase is propagating downward, energy upward
%  Uses routines: rotspec, cleanx,, ffirsti, chisqp
%  Version 1.0  rkd 4/4/94: I use to have a memo that talks about rotary spectra.
if nargin < 10, vp=0; end 
%
clf
%
tott=M*dt;
dfreq=1.0/tott;
n2=fix(M/2)+1;
f=dfreq*(1:n2-1);
%
psmin=min([log10(pscw) log10(psacw)]);
psmax=max([log10(pscw) log10(psacw)]);
% calculate number of degrees of freedom in original spectrum
I=sum(hanning(M).^2);
ndof=2*T/I;
if ~exist('prange'),
 prange=[floor(psmin) ceil(psmax)];
end
if ~exist('frange'),
 frange=[floor(min(log10(f))) ceil(max(log10(f)))];
end
pminc=(10^prange(1))*1.5;
pdec=prange(2)-prange(1); fdec=frange(2)-frange(1);
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
ci=95.0;
[plow,phi]=chisqp(ndof,ci);
if (phi-plow) < 0.2, 
   ci=99; 
   [plow,phi]=chisqp(ndof,ci);
end
cmid=pminc/plow;
pmaxc=cmid*phi;
for i=1:n2-1
    if f(i) <= fravg
       iavg=iavg+1;
       favg=favg+f(i);
       pca=pca+pscw(i);
       paca=paca+psacw(i);
       if iavg == navg
          inew=inew+1;
          fa(inew)=favg/navg;
          pscwa(inew)=pca/navg;
          psacwa(inew)=paca/navg;
          cf(inew)=cmid;
          cfl(inew)=cmid*plow;
          cfh(inew)=cmid*phi;
          iavg=0;
          favg=0;
          pca=0;
          paca=0;
       end
    else
       if iavg >= 1
         inew=inew+1;
         fa(inew)=favg/iavg;
         pscwa(inew)=pca/iavg;
         psacwa(inew)=paca/iavg;
         cf(inew)=cmid;
         cfl(inew)=cmid*plow;
         cfh(inew)=cmid*phi;
       end
       iavg=0;
       favg=0;
       pca=0;
       paca=0;
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
   pscwa(inew)=pca/iavg;
   psacwa(inew)=paca/iavg;
   cf(inew)=cmid;
   cfl(inew)=cmid*plow;
   cfh(inew)=cmid*phi;
end
if vp == 1,
   pscwa=pscwa.*fa;
   psacwa=psacwa.*fa;
end
%
flab(1)=0.15.*10^frange(2);
flab(2)=0.3.*10^frange(2);
%
fl=([10^(frange(1)+1) 10^(frange(1)+1.5)]);
tx1=1.05*10^(frange(1)); ty1=cmid;
tx2=10^(frange(2)-0.5); 
ty21=10^(prange(2)-.5); ty22=10^(prange(2)-.3);
line1=ones(2,1).*10.^(prange(2)-.5);
line2=ones(2,1).*10.^(prange(2)-.3);
%
varcw=[];
if exist('fvar'),
   if (fvar(2)-fvar(1))>0,
      df=f(2)-f(1);
      findx=find(f >= fvar(1) & f <= fvar(2));
      varcw=df*sum(pscw(findx));
      varacw=df*sum(psacw(findx));
   end
end
%
loglog(fa,pscwa,'k',fa,psacwa,'--k'...
      ,fa,cfl,'b',fa,cf,'--b',fa,cfh,'b' ...
      ,flab,line1,'--k',flab,line2,'k');
hold on
text(tx1,ty1,[num2str(ci,'%2.0f'),'%'],'Fontsize',10);
text(tx2,ty21,'ACW','FontSize',10);text(tx2,ty22,'CW','FontSize',10);
text(tx2,10^(prange(2)-0.1),'Phase','FontSize',10);
if ~isempty(varcw),
   loglog(fvar,(10^prange(1))*1.1,'bv');
   text(10^(frange(2)-0.25),10^(prange(2)-0.1),'Var','FontSize',10);
   text(10^(frange(2)-0.25),ty22,num2str(varcw,'%4.1f'),'FontSize',10);
   text(10^(frange(2)-0.25),ty21,num2str(varacw,'%4.1f'),'FontSize',10);
end
%
axis([10.^frange 10.^prange]);
if exist('slope'),
   if slope(1) ~= 0,
      if length(slope)==2,
         psslope(slope(1),slope(2),1,3);
      elseif length(slope)==4,
         psslope(slope(1),slope(2),slope(3),slope(4));
      end
   end
end
xlabel('Frequency [cph]');ylabel('Power Spectral Level [(cm/s)^2/cph]');
% fini
