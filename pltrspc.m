function [vup,vdown]=pltrspc(U,V,dt,npts,slope,frange,prange)
% function [vup,vdown]=pltrspc(U,V,dt,npts,[rise run],frange,prange)
% Calculate/plot the rotary spectra for ADCP matrices U and V
%	U = [U1;U2] (east/west) velocity matrix 
%	V = [V1;V2] (north/south) velocity matrix
%	dt = time scale in cph (i.e. =1/60 for one minute data)
%  npts = the length of the time series segments to estiamte ps over.
%Optional: npts = number of points in power spectrum (default = 256)
%	slope = the slope of a loglog line to plot (i.e. [-2 1] or [-5 3])
%	frange, prange = loglog axis ranges for freq and spectrum amplitude
%  [vup,vdown] = variance of total upward/downward energies
%
%	External routines rotspec.m, chisqp.m, pltdat.m, ps.m
% RKD 10/98
[m,n]=size(U);
if nargin < 5, slope=[0 0 0 0]; end
% Make sure U,V and z are shallow/first = top/left = (1,1)
% Use spectra length = 256, unless time series is short, else one spectrum
if nargin < 6, npts=256; end
if n > npts
     nps=fix(n/npts)*2 - 1;
  else
     nps=1;
end
%

[pscw1,psacw1,M,T,f,psuv1]=rotspec(U(1,:),V(1,:),dt,nps);
[pscw2,psacw2,M,T,f,psuv2]=rotspec(U(2,:),V(2,:),dt,nps);

n2=fix(M/2)+1;
I=sum(hanning(M).^2);
scale=dt/I;

psuv1acw=psuv1(2:n2); 
ps0=fliplr(psuv1);
psuv1cw=ps0(1:n2-1);
psuv2acw=psuv2(2:n2);
ps0=fliplr(psuv2);
psuv2cw=ps0(1:n2-1);

%figure(2);clf
%loglog(f,(psuv1acw.*conj(psuv1acw))*scale,f,psacw1,f,(psuv2cw.*conj(psuv2cw))*scale,f,pscw2);

pscw=(pscw1+pscw2)/2; % average both levels
psacw=(psacw1+psacw2)/2;

ipcw=min(find(max(pscw)==pscw));
ipacw=min(find(max(psacw)==psacw));

phaseacw1=(atan2(imag(psuv1acw),real(psuv1acw)));
phaseacw2=(atan2(imag(psuv2acw),real(psuv2acw)));
dphaseacw=unw(phaseacw2-phaseacw1);
%indx1=find(dphaseacw > pi);
%indx2=find(dphaseacw < -pi);
%dphaseacw(indx1)=dphaseacw(indx1)-2*pi;
%dphaseacw(indx2)=dphaseacw(indx2)+2*pi;
%dphaseacw=atan2((real(psuv1acw).*imag(psuv2acw)-imag(psuv1acw).*real(psuv2acw)),...
%                (real(psuv1acw).*real(psuv2acw)+imag(psuv1acw).*imag(psuv2acw)));
             
phasecw1=(atan2(imag(psuv1cw),real(psuv1cw)));
phasecw2=(atan2(imag(psuv2cw),real(psuv2cw)));
dphasecw=unw(phasecw2-phasecw1);
%indx1=find(dphasecw > pi);
%indx2=find(dphasecw < -pi);
%dphasecw(indx1)=dphasecw(indx1)-2*pi;
%dphasecw(indx2)=dphasecw(indx2)+2*pi;
%dphasecw=atan2((real(psuv1cw).*imag(psuv2cw)-imag(psuv1cw).*real(psuv2cw)),...
%               (real(psuv1cw).*real(psuv2cw)+imag(psuv1cw).*imag(psuv2cw)));
            
% Scaling and # degrees of freedom uses same notation as Jenkins and Watts
ndof=(2*T/I);
[plow,phi]=chisqp(ndof,95);
%
%
psmin=min([log10(pscw) log10(psacw)]);
psmax=max([log10(pscw) log10(psacw)]);
%
if nargin < 6, frange=[floor(min(log10(f))) ceil(max(log10(f)))]; end
if nargin < 7, prange=[floor(psmin) ceil(psmax)]; end
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
pminc=1.3*(10^prange(1));
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
if iavg >= 1
   inew=inew+1;
   fa(inew)=favg/iavg;
   pscwa(inew)=pca/iavg;
   psacwa(inew)=paca/iavg;
   cf(inew)=cmid;
   cfl(inew)=cmid*plow;
   cfh(inew)=cmid*phi;
end
%
figure(1);
pos=get(gca,'Position');
if pos(3) < 0.5 | pos(4) < 0.5, % then this is a subplot, shrink fonts.
   fs=((min([pos(3) pos(4)]))^(0.25))*12;
else
   fs=10;
end
fs2=fs*0.8;
%
dx=fdec/10;dy=pdec/10;
fl=[10^(frange(1)+1) 10^(frange(1)+1.5)];
tx1=10^(frange(1)+0.05); ty1=cmid;
tx2=10^(frange(1)+0.05); 
tx3=10^(frange(1)+2*dx);
ty3=10^(prange(1)+3*dy +0.1);
cwl=3.5;acwl=3;
ty21=10^(prange(1)+cwl*dy+0.1); 
ty22=10^(prange(1)+acwl*dy+0.1);
flab=10.^(frange(1)+[dx:((2*dx-0.05)-dx)/(length(fa)-1):2*dx-0.05]);
line1=ones(size(flab)).*10.^(prange(1)+cwl*dy+0.1);
line2=ones(size(flab)).*10.^(prange(1)+acwl*dy+0.1);
%
nf=length(f);
[ax,h1,h2]=plotyy([fa;fa;fa;fa;fa;flab;flab]',[pscwa;psacwa;cfl;cf;cfh;line2;line1]',...
   [f(1:nf-1);f(1:nf-1);f(1:nf-1)]',[dphasecw(1:nf-1);dphaseacw(1:nf-1);[1:(nf-1)]*0]','loglog','semilogx');
set(h1(1),'Color','b','LineWidth',1.5);
set(h1(2),'LineStyle','--','Color','r','LineWidth',1.5);
set(h1([3 5]),'Color','g');
set(h1(4),'LineStyle','--','Color','g');
set(h1(6),'LineStyle','--','Color','r');
set(h1(7),'Color','b');
text(tx1,ty1,'95%','Fontsize',fs2);
text(tx2,ty22,'AC','Fontsize',fs2);
text(tx2,ty21,'CW','Fontsize',fs2);

set(h2(1),'Color','b');
set(h2(2),'LineStyle','--','Color','r');
set(h2(3),'Color','k');
set(ax(1),'XLim',[10.^frange],'YLim',[10.^prange]);
%
set(ax(2),'Ylim',[-pi pi]);%
ax2ylh=get(ax(2),'YLabel');
set(ax2ylh,'String','Phase Difference [rad]');
%
if abs(slope(1)) > 0,
   psslope(slope(1),slope(2),slope(3),slope(4));
end
%
set(ax,'Fontsize',fs);
if pos(2) < 0.15 | pos(4) > 0.3,
   xlabel('Frequency [cph]');
end
if pos(1) < 0.15 | pos(3) > 0.3,
   ylabel('Power [(cm/s)^2/cph]');
end

vup=0;vdown=0;

if pos(2) < 0.15 & (pos(1)+pos(3))>0.8, pltdat; end
%
