function [vup,vdown]=pltudspc(U,V,dt,npts,imax,slope,frange,prange)
% function [vup,vdown]=pltudspc(U,V,dt,npts,imax,[rise run nx ny],frange,prange)
% Calculate/plot the average directinoal spectra for ADCP matrices U and V
%	U (east/west) velocity matrix [U(1,:) is shallowest]
%	V (north/south) velocity matrix
%	dt = time scale in cph (i.e. =1/60 for one minute data)
%  npts = the length of the time series segments to estiamte ps over
%  imax is the maximum velocity bin to process
%Optional: npts = number of points in power spectrum (default = 256)
%	slope = the slope of a loglog line to plot (see psslope)
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

for ii=1:imax-2,
   if ii==1,
      [pscw2,psacw2,M,T,f,psuv2]=rotspec(U(ii,:),V(ii,:),dt,nps);
   end
   [pscw1,psacw1,M,T,f,psuv1]=rotspec(U(ii+2,:),V(ii+2,:),dt,nps);   
   if ii==1,
      n2=fix(M/2)+1;
      I=sum(hanning(M).^2);
      scale=dt/I;
      pscwa=pscw1;
      psacwa=psacw1;
      psup=ones(size(f))*0;
      psdn=psup;
      idcup=psup;idcdn=psup;
      idaup=psup;idadn=psup;
   end
   pscwa=pscwa+pscw2;
   psacwa=psacwa+psacw2;
   
   psuv1acw=psuv1(2:n2); 
   ps0=fliplr(psuv1);
   psuv1cw=ps0(1:n2-1);
   psuv2acw=psuv2(2:n2);
   ps0=fliplr(psuv2);
   psuv2cw=ps0(1:n2-1);
   
   pscw=(pscw1+pscw2)/2;
   psacw=(psacw1+psacw2)/2;
   
   pscw2=pscw1;
   psacw2=psacw1;
   psuv1=psuv2;

	phaseacw1=(atan2(imag(psuv1acw),real(psuv1acw)));
	phaseacw2=(atan2(imag(psuv2acw),real(psuv2acw)));
	dphaseacw=unw(phaseacw2-phaseacw1);
	phasecw1=(atan2(imag(psuv1cw),real(psuv1cw)));
	phasecw2=(atan2(imag(psuv2cw),real(psuv2cw)));
   dphasecw=unw(phasecw2-phasecw1);
   
   idcwup=find(dphasecw < 0);
   idcup(idcwup)=idcup(idcwup)+1;
   idcwdn=find(dphasecw > 0);
   idcdn(idcwdn)=idcdn(idcwdn)+1;
   idacwup=find(dphasecw > 0);
   idaup(idacwup)=idaup(idacwup)+1;
   idacwdn=find(dphasecw < 0);
   idadn(idacwdn)=idadn(idacwdn)+1;
   
   psup(idcwup)=psup(idcwup)+pscw(idcwup);
   psup(idacwup)=psup(idacwup)+psacw(idacwup);
   psdn(idcwdn)=psdn(idcwdn)+pscw(idcwdn);
   psdn(idacwdn)=psdn(idacwdn)+psacw(idacwdn);
   
   if ii==1,
      adpcw=dphasecw;
      adpacw=dphaseacw;
   else
      adpcw=adpcw + dphasecw;
      adpacw=adpacw + dphaseacw;
   end
end
pscw=pscwa/imax;
psacw=psacwa/imax;
dphasecw=adpcw/(imax-1);
dphaseacw=adpacw/(imax-1);

id1=find(idcup>0 & idaup<1);
id2=find(idaup>0 & idcup<1);
id12=find(idcup>0 & idaup > 0);
id3=find(idcup<1 & idaup<1);
psup(id1)=psup(id1)./idcup(id1);
psup(id2)=psup(id2)./idaup(id2);
psup(id12)=psup(id12)./(idcup(id12)+idaup(id12));
psup(id3)=NaN;

id1=find(idcdn>0 & idadn<1);
id2=find(idadn>0 & idcdn<1);
id12=find(idcdn>0 & idadn > 0);
id3=find(idcdn<1 & idadn<1);
psdn(id1)=psdn(id1)./idcdn(id1);
psdn(id2)=psdn(id2)./idadn(id2);
psdn(id12)=psdn(id12)./(idcdn(id12)+idadn(id12));
psdn(id3)=NaN;
            
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

vup=sum(psup)*f(1);
vdown=sum(psdn)*f(1);

favg=0;
pca=0;paca=0;
dpca=0;dpaca=0;
pscwa=[];psacwa=[];
dpcwa=[];dpacwa=[];
psupa=[];psdna=[];
pupa=0;pdna=0;
navg=1;
iavg=0;inew=0;
uavg=0;davg=0;
pminc=1.3*(10^prange(1));
cmid=pminc/plow;
pmaxc=cmid*phi;
for i=1:n2-1
    if f(i) <= fravg
       iavg=iavg+1;
       favg=favg+f(i);
       pca=pca+pscw(i);
       paca=paca+psacw(i);
       dpca=dpca+dphasecw(i);
       dpaca=dpaca+dphaseacw(i);
       if ~isnan(psup(i)), pupa=pupa+psup(i); uavg=uavg+1; end
       if ~isnan(psdn(i)), pdna=pdna+psdn(i); davg=davg+1; end
       if iavg == navg
          inew=inew+1;
          fa(inew)=favg/navg;
          pscwa(inew)=pca/navg;
          psacwa(inew)=paca/navg;
          dpcwa(inew)=dpca/navg;
          dpacwa(inew)=dpaca/navg;
          if uavg>0, 
             psupa(inew)=pupa/uavg;
          else
             psupa(inew)=NaN;
          end
          if davg>0, 
             psdna(inew)=pdna/davg;
          else
             psdna(inew)=NaN;
          end
          uavg=0;davg=0;
          cf(inew)=cmid;
          cfl(inew)=cmid*plow;
          cfh(inew)=cmid*phi;
          iavg=0;
          favg=0;
          pca=0;paca=0;
          dpca=0;dpaca=0;
          pupa=0;pdna=0;
       end
    else
       if iavg >= 1
         inew=inew+1;
         fa(inew)=favg/iavg;
         pscwa(inew)=pca/iavg;
         psacwa(inew)=paca/iavg;
         dpcwa(inew)=dpca/iavg;
         dpacwa(inew)=dpaca/iavg;
          if uavg>0, 
             psupa(inew)=pupa/uavg;
          else
             psupa(inew)=NaN;
          end
          if davg>0, 
             psdna(inew)=pdna/davg;
          else
             psdna(inew)=NaN;
          end
          uavg=0;davg=0;
         cf(inew)=cmid;
         cfl(inew)=cmid*plow;
         cfh(inew)=cmid*phi;
      end
      uavg=0;davg=0;
       iavg=0;
       favg=0;
       pca=0;paca=0;
       dpca=0;dpaca=0;
       pupa=0;pdna=0;
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
   dpcwa(inew)=dpca/iavg;
   dpacwa(inew)=dpaca/iavg;
   if uavg>0, 
      psupa(inew)=pupa/uavg;
    else
      psupa(inew)=NaN;
   end
   if davg>0, 
      psdna(inew)=pdna/davg;
    else
      psdna(inew)=NaN;
   end
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
tx3=10^(frange(1)+3*dx);
ty3=10^(prange(1)+3*dy +0.1);
cwl=1.5;acwl=1;
ty21=10^(prange(1)+cwl*dy); 
ty22=10^(prange(1)+acwl*dy);
flab=10.^(frange(1)+[1.5*dx:((2*dx-0.05)-dx)/(length(fa)-1):2.5*dx-0.05]);
line1=ones(size(flab)).*10.^(prange(1)+cwl*dy);
line2=ones(size(flab)).*10.^(prange(1)+acwl*dy);
%
nf=length(fa);
%
%[ax,h1,h2]=plotyy([fa;fa;fa;fa;fa;flab;flab]',[pscwa;psacwa;cfl;cf;cfh;line2;line1]',...
%   [fa;fa;fa]',[dpcwa;dpacwa;[1:nf]*0]','loglog','semilogx');
h1=loglog(fa,psupa,fa,psdna,flab,line2,flab,line1);
%
set(h1(1),'Color','b','LineWidth',1);
set(h1(2),'LineStyle','--','Color','r','LineWidth',1);
%set(h1([3 5]),'Color','g');
%set(h1(4),'LineStyle','--','Color','g');
%set(h1(6),'LineStyle','--','Color','r');
%set(h1(7),'Color','b');
set(h1(3),'LineStyle','--','Color','r','LineWidth',1);
set(h1(4),'Color','b','LineWidth',1);
%text(tx1,ty1,'95%','Fontsize',fs2);
%text(tx2,ty22,'AC','Fontsize',fs2);
%text(tx2,ty21,'CW','Fontsize',fs2);
text(tx2,ty22,'Down','Fontsize',fs2);
text(tx2,ty21,'Up','Fontsize',fs2);
text(tx3,ty22,num2str(vdown,3),'Fontsize',fs2);
text(tx3,ty21,num2str(vup,3),'Fontsize',fs2);

%set(h2(1),'Color','b');
%set(h2(2),'LineStyle','--','Color','r');
%set(h2(3),'Color','k');
%set(ax(1),'XLim',[10.^frange],'YLim',[10.^prange]);
set(gca,'XLim',[10.^frange],'YLim',[10.^prange]);
xl=get(gca,'XLim');
xt=10.^[log10(xl(1)):1:log10(xl(2))];
set(gca,'XTick',xt,'XTickLabel',num2str(log10(xt)),'XTickLabelMode','auto','XTickMode','auto','XScale','log');
yl=get(gca,'YLim');
yt=10.^[log10(yl(1)):1:log10(yl(2))];
set(gca,'YTick',yt,'YTickLabel',num2str(log10(yt)),'YTickLabelMode','auto','YTIckMode','auto','YScale','log');
%set(ax,'Fontsize',fs);
set(gca,'Fontsize',fs);
%
%set(ax(2),'Ylim',[-pi pi]);%
%ax2ylh=get(ax(2),'YLabel');
%set(ax2ylh,'String','Phase Difference [rad]');
%
if abs(slope(1)) > 0,
   psslope(slope(1),slope(2),slope(3),slope(4));
end
%
if pos(2) < 0.15 | pos(4) > 0.3,
   xlabel('Frequency [cph]');
end
if pos(1) < 0.15 | pos(3) > 0.3,
   ylabel('Power [(cm/s)^2/cph]');
end
if pos(2) < 0.15 & (pos(1)+pos(3))>0.8, pltdat; end
%
