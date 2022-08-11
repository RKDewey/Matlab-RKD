function axset=plttsdt(time,t,s,d,P,subplt,tit,Trange,Srange,Drange,ylen)
% function axset=plttsdt(time,t,s,d,P,subplt,tit,Trange,Srange,Drange,ylen)
% Plots sigma(d), temperature(t) and salinity(s) at pres=P vs time (in mtime) on 1 plot.
% Auto scales the t/s axes to show relative contributions to sigma-t.
%Optional subplt, tit, Trange, Srange and Drange, and xlen.
% tit is the title (text string) for the top center of the plot.
% subplt=[rows,cols,fig#] for subplotting
% ylen is the number of tickmarks along the x-axis
% use output for setting other axes: axes('position',axset)
% where acset=[lrx lrz width height]
% calls spvan, pltdat, and minmax(X): comment out pltdat if necessary
% Based on plttsd3 1.0 RKD 7/94, 1.1 8/94 to calculate in situ ratio=alpha/beta
% RKD 12/07
if nargin < 6, subplt=[1 1 1]; end
if nargin < 7, tit='T/S/D Plot'; end
fs=10; % font size
if subplt(1)*subplt(2)>4, fs=6; end
zmm=minmax(time);
zmin=zmm(1);zmax=zmm(2);
zmean=(zmin+zmax)/2;
zavg=(zmin+zmax)/2;
xhgt1=0.8;     % length of the the full plot
xhgt2=0.7;     % length where data will be plotted (space for two x-axes)
figw=0.85/subplt(2); % new figure width?
figh1=xhgt1/subplt(1);
figh2=xhgt2/subplt(1);
if subplt==[1 1 1],
    clf;
    figl=.1;
else
    figl=0.2/subplt(2)+0.95*(subplt(3)-((fix((subplt(3)-0.001)/subplt(2))+1)-1)*subplt(2)-1)/subplt(2);
end
figb1=(1/subplt(1))*(0.1+subplt(1)-ceil(subplt(3)/subplt(2)));
figb2=(1/subplt(1))*(0.175+subplt(1)-ceil(subplt(3)/subplt(2)));
axes('position',[figl figb1 figw figh1]);
plot1=plot(time,d,'w','linewidth',1);
zlim=get(gca,'XLim');
%set(gca,'YDir','reverse');
hy1=ylabel('\sigma_t','Fontsize',fs,'VerticalAlignment','middle');
set(gca,'YColor','b','Fontsize',fs);
if nargin > 7
  dd=(Drange(2)-Drange(1))/ylen;
  dlim=(Drange(1):dd:Drange(2));
  set(gca,'YLim',[Drange(1) Drange(2)])
  set(gca,'YTick',dlim)
  dtick=get(gca,'YTick');
else
  dtick=get(gca,'YTick');
  set(gca,'YTick',dtick);
end
dlim=get(gca,'YLim');dmn=dlim(1);dmx=dlim(2);
%zlim=get(gca,'YLim');
% set the time axes limit so that all data fits in shortened T axis
zlim(2)=zlim(2)*(xhgt1/xhgt2);
set(gca,'XLim',zlim);
ztick=get(gca,'XTick');
%set(gca,'XTick',ztick);
%set(gca,'XColor',[0 0 0]);
set(gca,'XTickLabel',[]);
[m ntick]=size(ztick);
ylen=ntick-1;
% afontsize=get(gca,'FontSize');

if nargin > 7
  tmn=Trange(1);
  tmx=Trange(2);
  delt=ylen*(ceil((tmx-tmn)*10/ylen)/10);
  tmx=tmn+delt;
  smn=Srange(1);
  smx=Srange(2);
  dels=ylen*(ceil((smx-smn)*10/ylen)/10);
  smx=smn+dels;
else
% If the scalar ranges are not passed, then 
% scale T/S to show relative contributions to density, 
%	where 1/ratio=heat expansion/salty contraction
%
  tmm=minmax(t);tmin=tmm(1);tmax=tmm(2);
  smm=minmax(s);smin=smm(1);smax=smm(2);
  tmean=(tmin+tmax)/2;
  smean=(smin+smax)/2;
  dt=0.2;
  ds=0.2;
  [svan1 sigma1]=spvan(smean,tmean+dt,P);
  [svan2 sigma2]=spvan(smean,tmean-dt,P);
  [svan0 sigma0]=spvan(smean,tmean,P);
  alphap=-((sigma1-sigma2)/(dt*2))/(1000+sigma0);
  [svan1 sigma1]=spvan(smean+ds,tmean,P);
  [svan2 sigma2]=spvan(smean-ds,tmean,P);
  betap=((sigma1-sigma2)/(ds*2))/(1000+sigma0);
  ratio=betap/alphap;
  tmn=floor(tmin);
  tmx=ceil(tmax);
  delt=ylen*(ceil((tmx-tmn)*10/ylen)/10);
  tmx=tmn+delt;
% Make the starting and increment for S nice and round also
  dels=ylen*(ceil((delt/ratio)*10/ylen)/10);
  smn=(floor(smin*10))/10 - 0.1;
  smx=smn+dels;
% Check to see if the S scale based on the T scale is large enough
  if smx < smax
% If not, make the T scale based on the S scale
    smx=(ceil(smax*10))/10;
    dels=ylen*(ceil((smx-smn)*10/ylen)/10);
    smx=smn+dels;
    delt=ylen*(ceil((dels*ratio)*10/ylen)/10);
    tmn=floor(tmin);
    tmx=tmn+delt;
  end
end
ds=dels/ylen;
dt=delt/ylen;
slim=(smn:ds:smx);
tlim=(tmn:dt:tmx);

hold on
set(gca,'NextPlot','add');
axes('position',[figl figb2 figw figh2]);
plot2=plot(time,t,'r');
set(gca,'XLim',[zmin (xhgt2/xhgt1)*zlim(2)]);
set(gca,'YLim',[tmn tmx]);
set(gca,'YTick',tlim,'Fontsize',fs);
xlabel('Date/Time','Fontsize',fs);
h1=ylabel('Temperature [C]','FontSize',fs);%,'VerticalAlignment','middle');
xyz=get(h1,'Position');
set(h1,'Position',[xyz(1)*.6 xyz(2) xyz(3)]);
set(h1,'Units','normalized','Color','r','FontSize',fs);
%tlp=get(h,'Position');
%set(h,'Position',[tlp(1) tlp(2)*0.5 tlp(3)]);
set(gca,'YColor','r','FontSize',fs);
%
set(gca,'NextPlot','add');
axes('position',[figl figb2 figw figh2]);
if nargout == 1, axset=[figl figb2 figw figh2]; end
T=((t-tmn)/(tmx-tmn))*(smx-smn)+smn;
D=((d-dmn)/(dmx-dmn))*(smx-smn)+smn;
plot3=plot(time,D,'b',time,T,'r',time,s,'g');
grid on;
%set(plot3(1),'Linewidth',2);
grn=[0 .6 0]; % darker green
set(plot3(3),'Color',grn);  
% set(gca,'YDir','reverse');
set(gca,'XLim',[zmin (xhgt2/xhgt1).*zlim(2)]);
%
%set(gca,'XTickLabel',[])
%set(gca,'XLim',[smn smx])
%set(gca,'XTick',slim)
set(gca,'XTickLabel',[])
axdate(ntick);
% Note initial text position is in units of salinity and depth (ppt,meters)
% then switch to normalized units (axes are 1X1 normalized units)
slabz=-25;
h2=ylabel('Salinity [PSU]');
set(h2,'Color',grn,'Fontsize',fs);
set(h2,'Units','normalized');sal=get(h2,'Position');
set(h2,'VerticalAlignment','baseline');
set(h2,'Position',[sal(1) 1.06 sal(3)])
%set(h,'HorizontalAlignment','center');
h4=text(0,0,tit);
set(h4,'Color','k','FontSize',fs)
set(h4,'Units','normalized')
%set(h4,'Position',[0.5 1.14 0])
set(h4,'HorizontalAlignment','center');
snum=smn-ds;
dst=1.0/(ntick-1);
spos=-dst;
nsticks=ntick;
for nst=1:nsticks
    snum=snum+ds;
    spos=spos+dst;
    slab=sprintf('%4.1f',snum);
    if (fix(snum) == snum & fix(ds)==ds), slab=sprintf('%2.0f',snum); end;
    h=text(snum-0.1,slabz,slab);
    set(h,'Color',grn,'Fontsize',fs)
    set(h,'units','normalized')
    set(h,'Position',[spos 1.03 0])
    set(h,'HorizontalAlignment','center');
end
if subplt(1) > 1, hold on, end;
if subplt(2) > 1, hold on, end;
% end of plttsdt
