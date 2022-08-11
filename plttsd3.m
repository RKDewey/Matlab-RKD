function axset=plttsd3(z,t,s,d,subplt,tit,Trange,Srange,Drange,xlen)
% function axset=plttsd3(z,t,s,d,subplt,tit,Trange,Srange,Drange,xlen)
% Plots sigma(d), temperature(t) and salinity(s) vs depth (z in -m) on 1 plot.
% Auto scales the t/s axes to show relative contributions to sigma-t.
%Optional subplt, tit, Trange, Srange and Drange, and xlen.
% tit is the title (text string) for the top center of the plot.
% subplt=[rows,cols,fig#] for subplotting
% xlen is the number of tickmarks along the x-axis
% use output for setting other axes: axes('position',axset)
% where acset=[lrx lrz width height]
% calls spvan, pltdat, and minmax(X): comment out pltdat if necessary
% 1.0 RKD 7/94, 1.1 8/94 to calculate in situ ratio=alpha/beta
%
if nargin < 5, subplt=[1 1 1]; end
if nargin < 6, tit='T/S/D plot'; end
fs=10; % font size
if subplt(1)*subplt(2)>4, fs=6; end
z=abs(z);  % make the depths all positive
zmm=minmax(z);
zmin=zmm(1);if zmin<10, zmin=0; end
zmax=zmm(2);
zmean=(zmin+zmax)/2;
zavg=(zmin+zmax)/2;
yhgt1=0.8;     % height of the the full plot
yhgt2=0.65;     % height where data will be plotted (space for two x-axes)
figw=0.7/subplt(2); % new figure width?
figh1=yhgt1/subplt(1);
figh2=yhgt2/subplt(1);
if subplt==[1 1 1],
    clf;
    figl=.2;
else
    figl=0.25/subplt(2)+0.95*(subplt(3)-((fix((subplt(3)-0.001)/subplt(2))+1)-1)*subplt(2)-1)/subplt(2);
end
figb1=(1/subplt(1))*(0.1+subplt(1)-ceil(subplt(3)/subplt(2)));
figb2=(1/subplt(1))*(0.175+subplt(1)-ceil(subplt(3)/subplt(2)));
axes('position',[figl figb1 figw figh1]);
plot1=plot(d,z,'w','linewidth',1);
zlim=get(gca,'YLim');
%set(gca,'YDir','reverse');
hxl=xlabel('\sigma_t','Fontsize',fs,'VerticalAlignment','middle');
set(gca,'XColor','b','Fontsize',fs);
if nargin > 6
  dd=(Drange(2)-Drange(1))/xlen;
  dlim=(Drange(1):dd:Drange(2));
  set(gca,'XLim',[Drange(1) Drange(2)])
  set(gca,'XTick',dlim)
  dtick=get(gca,'XTick');
else
  dtick=get(gca,'XTick');
  set(gca,'XTick',dtick);
end
dlim=get(gca,'XLim');dmn=dlim(1);dmx=dlim(2);
%zlim=get(gca,'YLim');
% set the depth axes limit so that all data fits above shortened T axis

zlim(2)=zlim(2)*(yhgt1/yhgt2);
set(gca,'YLim',zlim);
ztick=get(gca,'YTick');
set(gca,'YTick',ztick);
set(gca,'YColor',[0 0 0]);
set(gca,'YTickLabel',[]);
[m ntick]=size(dtick);
xlen=ntick-1;
% afontsize=get(gca,'FontSize');

if nargin > 6
  tmn=Trange(1);
  tmx=Trange(2);
  delt=xlen*(ceil((tmx-tmn)*10/xlen)/10);
  tmx=tmn+delt;
  smn=Srange(1);
  smx=Srange(2);
  dels=xlen*(ceil((smx-smn)*10/xlen)/10);
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
  [svan1 sigma1]=spvan(smean,tmean+dt,zmean);
  [svan2 sigma2]=spvan(smean,tmean-dt,zmean);
  [svan0 sigma0]=spvan(smean,tmean,zmean);
  alphap=-((sigma1-sigma2)/(dt*2))/(1000+sigma0);
  [svan1 sigma1]=spvan(smean+ds,tmean,zmean);
  [svan2 sigma2]=spvan(smean-ds,tmean,zmean);
  betap=((sigma1-sigma2)/(ds*2))/(1000+sigma0);
  ratio=betap/alphap;
  tmn=floor(tmin);
  tmx=ceil(tmax);
  delt=xlen*(ceil((tmx-tmn)*10/xlen)/10);
  tmx=tmn+delt;
% Make the starting and increment for S nice and round also
  dels=xlen*(ceil((delt/ratio)*10/xlen)/10);
  smn=(floor(smin*10))/10 - 0.1;
  smx=smn+dels;
% Check to see if the S scale based on the T scale is large enough
  if smx < smax
% If not, make the T scale based on the S scale
    smx=(ceil(smax*10))/10;
    dels=xlen*(ceil((smx-smn)*10/xlen)/10);
    smx=smn+dels;
    delt=xlen*(ceil((dels*ratio)*10/xlen)/10);
    tmn=floor(tmin);
    tmx=tmn+delt;
  end
end
ds=dels/xlen;
dt=delt/xlen;
slim=(smn:ds:smx);
tlim=(tmn:dt:tmx);

hold on
set(gca,'NextPlot','add');
axes('position',[figl figb2 figw figh2]);
plot2=plot(t,z,'r');
set(gca,'YDir','reverse');
%zlim=get(gca,'YLim');
set(gca,'YLim',[zmin (yhgt2/yhgt1)*zlim(2)]);
set(gca,'XLim',[tmn tmx]);
set(gca,'XTick',tlim,'Fontsize',fs);
ylabel('Depth (m)','Fontsize',fs);
h=xlabel('Temperature [C]','FontSize',fs);%,'VerticalAlignment','middle');
xyz=get(h,'Position');
set(h,'Position',[xyz(1) xyz(2) xyz(3)]);
set(h,'Units','normalized','Color','r','FontSize',fs);
%tlp=get(h,'Position');
%set(h,'Position',[tlp(1) tlp(2)*0.5 tlp(3)]);
set(gca,'XColor','r','FontSize',fs);

set(gca,'NextPlot','add');
axes('position',[figl figb2 figw figh2]);
if nargout == 1, axset=[figl figb2 figw figh2]; end
T=((t-tmn)/(tmx-tmn))*(smx-smn)+smn;
D=((d-dmn)/(dmx-dmn))*(smx-smn)+smn;
plot3=plot(D,z,'b',T,z,'r',s,z,'g');
grid on;
%set(plot3(1),'Linewidth',2);
grn=[0 .6 0]; % darker green
set(plot3(3),'Color',grn);  
set(gca,'YDir','reverse');
set(gca,'YLim',[zmin (yhgt2/yhgt1).*zlim(2)]);
%
set(gca,'YTickLabel',[])
set(gca,'XLim',[smn smx])
set(gca,'XTick',slim)
set(gca,'XTickLabel',[])
% Note initial text position is in units of salinity and depth (ppt,meters)
% then switch to normalized units (axes are 1X1 normalized units)
slabz=-25;
h=xlabel('Salinity [PSU]');
set(h,'Color',grn,'Fontsize',fs);
set(h,'Units','normalized');sal=get(h,'Position');
set(h,'VerticalAlignment','baseline');
set(h,'Position',[sal(1) 1.06 sal(3)])
%set(h,'HorizontalAlignment','center');
h=text(0,0,tit);
set(h,'Color','k','FontSize',fs)
set(h,'Units','normalized')
set(h,'Position',[0.5 1.14 0])
set(h,'HorizontalAlignment','center');
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
% end of plttsd3
