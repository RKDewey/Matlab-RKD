% Script worldbv
% RKD 08/98
m_proj('lambert','long',[-90 -10],'lat',[0 80]);
m_coast('patch',[1 1 1]);
m_elev('contourf',[-7000:100:0]);
m_grid('box','fancy','tickdir','in');
colormap(colmap(64,2));
colorbar('vert');
title('Bathymetry [m]');
print -dpsc2 worldbathy01.psc
return
cmap=colmap(64,2);
figure(1);orient landscape;clf;
m_proj('Mercator','long',[20 380],'lat',[-75 75]);
m_coast('patch',[1 1 1]);
[cbv,hcbv]=m_contourf(longgrid,latgrid,bv);
set(hcbv(:),'EdgeColor','none');
colormap(cmap);
colorbar('vert');
m_grid('box','fancy','tickdir','in');
title('Ocean Bottom Roughness Log_{10}[m^2]');
print -dpsc2 worldbvm.psc
return
Slongs=[-100 0;-75 25;-5 45; 25 145;45 100;145 295;100 290];
Slats= [  8 80;-80  8; 8 80;-80   8; 8  80;-80   0;  0  80];
H=[];
lg=longgrid;
il=find(longgrid > 180);
lg(il)=longgrid(il)-360;
cmap=colmap(64,2);
for L=[],
 figure(1);orient portrait;clf
 m_proj('sinusoidal','long',Slongs(L,:),'lat',Slats(L,:));
 m_coast('patch','g');
 ix=find(lg >= Slongs(L,1) & lg < Slongs(L,2));
 jy=find(latgrid >= Slats(L,1) & latgrid < Slats(L,2));
 [cc,hc]=M_contourf(lg(ix),latgrid(jy),bv(jy,ix));
 m_grid('fontsize',6,'xticklabels',[],'xtick',[-180:30:360],...
    'ytick',[-80:20:80],'yticklabels',[],'linest','-','color',[.9 .9 .9]);
 set(hc(:),'EdgeColor','none');
 m_grid('box','fancy','tickdir','in');
 colormap(cmap);
 colorbar('vert');
 title('Ocean Bottom Roughness Log_{10}[m^2]');
 drawnow
 if L==1,
    print -dpsc2 worldbv.psc
 else
    print -dpsc2 -append worldbv.psc
 end
end;
%
figure(1);orient landscape;clf
for L=1:7,
 m_proj('sinusoidal','long',Slongs(L,:),'lat',Slats(L,:));
 m_coast('patch','g');
 ix=find(lg >= Slongs(L,1) & lg < Slongs(L,2));
 jy=find(latgrid >= Slats(L,1) & latgrid < Slats(L,2));
 [cc,hc]=M_contourf(lg(ix),latgrid(jy),bv(jy,ix));
 H=[H hc'];
 m_grid('fontsize',6,'xticklabels',[],'xtick',[-180:30:360],...
    'ytick',[-80:20:80],'yticklabels',[],'linest','-','color',[.9 .9 .9]);
end;
% The multiple maps trick is useful only with this projection. In order to
% see all the maps we must undo the axis limits set by m_grid calls:
set(gca,'xlimmode','auto','ylimmode','auto');
set(H(:),'EdgeColor','none');
% m_grid('box','fancy','tickdir','in');
colormap(cmap);
colorbar('vert');
print -dpsc2 -append worldbv.psc
% fini