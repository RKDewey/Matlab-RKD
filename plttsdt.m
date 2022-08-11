function [a,h]=plttsdt(time,T,S,D,P,tit)
% function [a,h]=plttsdt(time,T,S,D,P,tit)
% function to plot TSD on scaled single plot
% time is mtime
% T is temperature
% S is salinity
% D is density or sigmat
% P is the average pressure [m or db]

% RKD 12/07
clf;
if nargin<6, tit='T/S/D Plot'; end
dmm=minmax(D);
dd=dmm(2)-dmm(1);
tmm=minmax(T);
dt=tmm(2)-tmm(1);
smm=minmax(S);
ds=smm(2)-smm(1);
% Scale T & S to show relative contributions to sigma_t/density
  tmin=tmm(1);tmax=tmm(2);
  smin=smm(1);smax=smm(2);
  tmean=(tmm(1)+tmm(2))/2;
  smean=(smm(1)+smm(2))/2;
  dt0=0.2;
  ds0=0.2;
  [svan1 sigma1]=spvan(smean,tmean+dt0,P);
  [svan2 sigma2]=spvan(smean,tmean-dt0,P);
  [svan0 sigma0]=spvan(smean,tmean,P);
  alphap=-((sigma1-sigma2)/(dt0*2))/(1000+sigma0);
  [svan1 sigma1]=spvan(smean+ds0,tmean,P);
  [svan2 sigma2]=spvan(smean-ds0,tmean,P);
  betap=((sigma1-sigma2)/(ds0*2))/(1000+sigma0);
  ratio=betap/alphap;
%
g=[0 .6 0];
%
ph3=plot(time,0.25+(D-dmm(1))/dd,time,(S-smm(1))/ds,time,(T-tmm(1))/(ratio*dt));
set(ph3(2),'Color',g);
axis tight
grid on
%
ap=get(gca,'Position');
set(gca,'Position',[ap(1)*1.3 ap(2) ap(3)*0.95 ap(4)]);
set(gca,'YTickLabel',[]);
XTick=get(gca,'XTick');
dx=XTick(end)-XTick(1);
YTick=get(gca,'YTick'); % these are the normalized values of the tick marks
% i.e. [0 .2 .4 .6 .8 1 1.2]
set(gca,'Clipping','off');
%
TTick=YTick(1:2)*(ratio*dt)+tmm(1);
for t=1:length(TTick),
    h=text(XTick(1)-0.2*dx,YTick(t),num2str(TTick(t),3));
    set(h,'Color','r','Clipping','off');
end
h=text(XTick(1)-0.225*dx,(YTick(1)+YTick(2))/2,'Temperature [C]');
set(h,'Color','r','Rotation',90,'HorizontalAlignment','center','FontWeight','bold');
%
DTick=(YTick-0.25)*dd+dmm(1);
for t=3:length(DTick),
    h=text(XTick(1)-0.2*dx,YTick(t),num2str(DTick(t),3));
    set(h,'Color','b','Clipping','off');
end
h=text(XTick(1)-0.225*dx,YTick(2+fix(length(YTick)/2)),'Density \sigma_t');
set(h,'Color','b','Rotation',90,'HorizontalAlignment','center','FontWeight','bold');
%
STick=YTick*ds+smm(1);
for t=2:length(STick),
    h=text(XTick(end)+0.17*dx,YTick(t),num2str(STick(t),3));
    set(h,'Color',g,'Clipping','off');
end
h=text(XTick(end)+0.22*dx,YTick(1+fix(length(YTick)/2)),'Salinity [psu]');
set(h,'Color',g,'Rotation',90,'HorizontalAlignment','center','FontWeight','bold');
%
axdate(13);
title(tit);
% fini
