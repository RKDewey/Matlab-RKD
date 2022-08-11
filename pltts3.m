function pltts3(tit,z,t,s,subplt,Trange,Srange,Drange,xlen)
% function pltts3(title,z,t,s,subplt,Trange,Srange,Drange,xlen)
% Plots sigma, temperature(t) and salinity(s) vs depth (z in -m) on 1 plot.
% 	subplt=[mp,np,p] are the sunplot indicies #rows, #col, #this plot 
%	title=text string of title for top of plot.
% Optional: Trange, Srange, Drange, xlen
% Auto scales the t/s axes to show relative contributions to sigma-t
% Trange, Srange and Drange are not passed.
% Optional parameters are [Trange, Srange, Drange, xlen] which the user can pass
% to fix the relative T/S/D scaling for a given set of CTD profiles (keeping 
% axes lables constant between multiple calls to plttsd3) with xlen divisions.
% Trange=[tmin tmax], Srange=[smin smax], where ranges are big enough.
% calls spvan, pltdat, and minmax(X)
% 1.0 RKD 7/94, 1.1 8/94 to calculate in situ ratio=alpha/beta
[zmin zmax]=minmax(z);
zmean=(zmin+zmax)/2;
zavg=(zmin+zmax)/2;
yhgt1=0.75;
yhgt2=0.675;
figw=0.6/subplt(2);
figh1=yhgt1/subplt(1);
figh2=yhgt2/subplt(1);
figl=0.25/subplt(2)+(subplt(3)-((fix((subplt(3)-0.001)/subplt(2))+1)-1)*subplt(2)-1)/subplt(2);
figb1=(1/subplt(1))*(0.1+subplt(1)-ceil(subplt(3)/subplt(2)));
figb2=(1/subplt(1))*(0.175+subplt(1)-ceil(subplt(3)/subplt(2)));
axes('position',[figl figb1 figw figh1])
[mt,nt]=size(t);
npts=max(mt,nt);
for iden=1:npts
  [svan0 d(iden)]=spvan(s(iden),t(iden),z(iden));
end
plot(d,z,'b')
if zavg > 0 set(gca,'YDir','reverse'), end
xlabel('Sigma-t (solid)')
set(gca,'XColor','b')
if nargin == 10
    dd=(Drange(2)-Drange(1))/xlen;
    dlim=(Drange(1):dd:Drange(2));
    set(gca,'XLim',[Drange(1) Drange(2)])
    set(gca,'XTick',dlim)
    dtick=get(gca,'XTick');
else
    dtick=get(gca,'XTick');
    set(gca,'XTick',dtick);
end
zlim=get(gca,'YLim');
% set the depth axes limit so that all data fits above T axis
zlim(2)=zlim(2)*(yhgt1/yhgt2);
set(gca,'YLim',zlim);
ztick=get(gca,'YTick');
set(gca,'YTick',ztick);
set(gca,'YColor',[0 0 0]);
set(gca,'YTickLabels',[]);
[m ntick]=size(dtick);
xlen=ntick-1;
afontsize=get(gca,'FontSize');
pltdat
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
%
% Scale T/S to show relative contributions to density, 
%	where 1/ratio=heat expansion/salty contraction
%
  [tmin tmax]=minmax(t);
  [smin smax]=minmax(s);
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
set(gca,'NextPlot','new')
axes('position',[figl figb2 figw figh2])
plot(t,z,'r--')
if zavg > 0 set(gca,'YDir','reverse'), end
%zlim=get(gca,'YLim');
if zavg < 0
  set(gca,'YLim',[(yhgt2/yhgt1)*zlim(1) 0])
else
  set(gca,'YLim',[0 (yhgt2/yhgt1)*zlim(2)])
end
set(gca,'XLim',[tmn tmx])
set(gca,'XTick',tlim)
ylabel('Depth (m)')
xlabel('Temperature (dashed)')
set(gca,'XColor','r')

set(gca,'NextPlot','new')
axes('position',[figl figb2 figw figh2])
plot(s,z,'g:')
if zavg > 0 set(gca,'YDir','reverse'), end
if zavg < 0
  set(gca,'YLim',[(yhgt2/yhgt1).*zlim(1) 0])
else
  set(gca,'YLim',[0 (yhgt2/yhgt1).*zlim(2)])
end
set(gca,'YTickLabels',[])
set(gca,'XLim',[smn smx])
set(gca,'XTick',slim)
set(gca,'XTickLabels',[])
% Note initial text position is in units of salinity and depth (ppt,meters)
% then switch to normalized units (axes are 1X1 normalized units)
stitz=50;
if zavg > 0 stitz=-50; end
slabz=25;
if zavg > 0 slabz=-25; end
h=text((smx-smn)/2-0.5+smn,stitz,'Salinity (dotted)');
set(h,'Color','g')
set(h,'Units','normalized')
set(h,'Position',[0.5/subplt(2) 1.1 0])
h=text((smx-smn)/2-0.5+smn,stitz,tit);
set(h,'Color','w')
set(h,'Units','normalized')
set(h,'Position',[0.45/subplt(2) 1.2 0])
snum=smn-ds;
dst=1.0/(ntick-1);
spos=-0.05-dst;
nsticks=ntick;
for nst=1:nsticks
    snum=snum+ds;
    spos=spos+dst;
    slab=sprintf('%4.1f',snum);
    h=text(snum-0.1,slabz,slab);
    set(h,'Color','g')
    set(h,'units','normalized')
    set(h,'Position',[spos 1.05 0])
end
if subplt(1) > 1, hold on, end;
if subplt(2) > 1, hold on, end;
% end of plttsd3
