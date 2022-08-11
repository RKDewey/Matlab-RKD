function [vcw,vacw]=pltarspc(U,V,z,dt,zmax,npts,slope,frange,prange,vrange)
% function [vcw,vacw]=pltarspc(U,V,z,dt,zmax,npts,[rise run],frange,prange,vrange)
% Calculate/plot the average rotary spectrafor ADCP matrice U and V
%	U = U (east/west) velocity matrix 
%	V = V (north/south) velocity matrix
%	z = positive depth array corresponding to U and V matrices
%	dt = time scale in cph (i.e. =1/60 for one minute data)
%	zmax = the maximum valid depth for good data (exclude noisy data)
%Optional: npts = number of points in power spectrum (default = 256)
%	slope = the slope of a loglog line to plot (i.e. -2)
%	frange, prange = loglog axis ranges for freq and spectrum amplitude
%	vrange = frequency range (cph) to calculate variance between
%	vcw,vacw = variances in vrange for clockwise and anticlockwise spectra
%	External routines rotspec.m, chisqp.m, pltdat.m
% For an ADCP time series of U_x and V_y, anti-clockwise rotation in a TS
% implies upward propagating phase and therefore downward propagating energy.
% RKD 4/18/94 modified into function 12/19/94
[m,n]=size(U);
[mz,nz]=size(z);
% Make sure U,V and z are shallow/first = top/left = (1,1)
z=abs(z);
if z(1) > z(2)
   if mz > 1
      z=flipud(z);
   elseif nz > 1
      z=fliplr(z);
   end
   U=flipud(U);
   V=flipud(V);
end
% Use spectra length = 256, unless time series is short, else one spectrum
if nargin < 6, npts=256; end
if n > npts
     nps=fix(n/npts)*2 - 1;
  else
     nps=1;
end
if nargin < 7, slope=0; end
mstop=min(find(z > zmax)) - 1;
nvar=0;
if nargin == 10
  varcw=0;varacw=0;
end
%
for j=1:mstop
    u=U(j,:);
    v=V(j,:);
    [pscw,psacw,M]=rotspec(u,v,dt,nps);
    nvar=nvar+1;
    if j == 1
      T=(M/2)*(nps+1);
      n2=fix(M/2)+1;
      n2m1=n2-1;
      apscw=pscw;
      apsacw=psacw;
    else
      apscw=apscw(1:n2m1)+pscw(1:n2m1);
      apsacw=apsacw(1:n2m1)+psacw(1:n2m1);
    end
    if nargin == 10
       dfreq=1.0/(M*dt);
		 f=dfreq*(1:n2-1);
       ifindv=find(f >= vrange(1) & f <= vrange(2));
       cwv=sum(pscw(ifindv))*dfreq;
       acwv=sum(psacw(ifindv))*dfreq;
       varcw=varcw+cwv;
       varacw=varacw+acwv;
    end
end
if nargout == 2 & nargin == 10
   vcw=varcw/nvar;
   vacw=varacw/nvar;
end
% Scaling and # degrees of freedom uses same notation as Jenkins and Watts

I=sum(hanning(M).^2);
ndof=(2*T/I)*(nvar-1);
[plow,phi]=chisqp(ndof,95);
%
pscw=apscw/nvar;
psacw=apsacw/nvar;
%
tott=M*dt;
dfreq=1.0/tott;
f=dfreq*(1:n2-1);
%
psmin=min([log10(pscw) log10(psacw)]);
psmax=max([log10(pscw) log10(psacw)]);
%
if nargin < 8, frange=[floor(min(log10(f))) ceil(max(log10(f)))]; end
if nargin < 9, prange=[floor(psmin) ceil(psmax)]; end
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
ty21=10^(prange(1)+2*dy+0.1); 
ty22=10^(prange(1)+1.2*dy+0.1);
flab=10.^(frange(1)+[dx 2*dx-0.05]);
line1=ones(2,1).*10.^(prange(1)+2.05*dy+0.1);
line2=ones(2,1).*10.^(prange(1)+1.25*dy+0.1);
%
h=loglog(fa,pscwa,'b',fa,psacwa,'--r'...%,fl,line,'k' ...
      ,fa,cfl,'g',fa,cf,'--g',fa,cfh,'g' ...
      ,flab,line2,'--r',flab,line1,'b');
set(h(3:5),'Color',[0 .6 0]);
text(tx1,ty1,'95%','Fontsize',fs2);
text(tx2,ty22,'AC','Fontsize',fs2);
text(tx2,ty21,'CW','Fontsize',fs2);
text(tx2,ty3,'Phase','Fontsize',fs2);
if nargout == 2,
   text(tx3,ty22,num2str(vacw,3),'Fontsize',fs2);
   text(tx3,ty21,num2str(vcw,3),'Fontsize',fs2);
   text(tx3,ty3,'Var','Fontsize',fs2); 
end
%
axis([10.^frange 10.^prange]);
axis manual;
if fs < 10, % then this is a subplot
%   xtickl=str2num(get(gca,'XTickLabel'));
   xtick=10.^[frange(1):1:frange(2)];
   set(gca,'XTick',xtick);
   set(gca,'XLim',[10.^frange]);
   set(gca,'XTickLabel',num2str(log10(xtick)'));
   set(gca,'XTickLabelMode','auto');
%   ytickl=str2num(get(gca,'YTickLabel'));
   ytick=10.^[prange(1):1:prange(2)];
   set(gca,'YTick',ytick);
   set(gca,'YLim',[10.^prange]);
   set(gca,'YTickLabel',num2str(log10(ytick)'));
   set(gca,'YTickLabelMode','auto');
end
%
psslope(slope(1),slope(2),slope(3),slope(4));
%
set(gca,'Fontsize',fs);
if pos(2) < 0.15 | pos(4) > 0.3,
   xlabel('Frequency [cph]');
end
if pos(1) < 0.15 | pos(3) > 0.3,
   ylabel('Power [(cm/s)^2/cph]');
end
if pos(2) < 0.15 & (pos(1)+pos(3))>0.8, pltdat; end
%
