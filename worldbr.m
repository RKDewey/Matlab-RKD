% Script worldbr
% RKD 08/98
%
bvscale=[-0.6:(3.6+0.6)/64:3.6];
%
figure(1);orient portrait;clf;
limits=[-170 0];
m_proj('ortho','long',limits(1),'lat',limits(2));
[c,h]=m_contourf(longgrid,latgrid,bv,bvscale);
pause
set(h(:),'EdgeColor','none');
m_coast('patch',[1 1 1]);
m_grid('box','on','tickdir','in');
cmap=colmap(64,2);
colormap(cmap);
colorbar('vert');
title('Bottom Roughness Log_{10}[m]');
print -dpsc2 worldbr1.psc
%
figure(1);orient portrait;clf;
limits=[-20 0];
m_proj('ortho','long',limits(1),'lat',limits(2));
[c,h]=m_contourf(longgrid,latgrid,bv,bvscale);
set(h(:),'EdgeColor','none');
m_coast('patch',[1 1 1]);
m_grid('box','on','tickdir','in');
cmap=colmap(64,2);
colormap(cmap);
colorbar('vert');
title('Bottom Roughness Log_{10}[m]');
print -dpsc2 worldbr2.psc
%
figure(1);orient portrait;clf;
limits=[80 0];
m_proj('ortho','long',limits(1),'lat',limits(2));
[c,h]=m_contourf(longgrid,latgrid,bv,bvscale);
set(h(:),'EdgeColor','none');
m_coast('patch',[1 1 1]);
m_grid('box','on','tickdir','in');
cmap=colmap(64,2);
colormap(cmap);
colorbar('vert');
title('Bottom Roughness Log_{10}[m]');
print -dpsc2 worldbr3.psc
%%
limits=[0 360 -80 85];
figure(1);orient landscape;clf;
m_proj('Mercator','long',[limits(1) limits(2)],'lat',[limits(3) limits(4)]);
[c,h]=m_contourf(longgrid,latgrid,bv,bvscale);
set(h(:),'EdgeColor','none');
m_coast('patch',[1 1 1]);
m_grid('box','fancy','tickdir','in');
cmap=colmap(64,2);
colormap(cmap);
colorbar('vert');
title('Bottom Roughness Log_{10}[m]');
print -dpsc2 worldbr4.psc
% fini
