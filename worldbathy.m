% Script worldbathy
% RKD 08/98
if ~exist('limits'), limits=[-90 10 0 80]; end
if ~exist('depths'), depths=[-7000:100:100 50 10 0]; end
figure(1);orient portrait;clf;
%
limits=[-170 0];
figure(1);orient portrait;clf;
m_proj('ortho','long',limits(1),'lat',limits(2));
[c,h]=m_elev('contourf',depths);
set(h(:),'EdgeColor','none');
m_coast('patch',[1 1 1]);
m_grid('box','on','tickdir','in');
cmap=colmap(64,2);
colormap(cmap);
colorbar('vert');
title('Bathymetry [m]');
print -dpsc2 worldbathy.psc
print
%
figure(1);orient portrait;clf;
limits=[-20 0];
figure(1);orient portrait;clf;
m_proj('ortho','long',limits(1),'lat',limits(2));
[c,h]=m_elev('contourf',depths);
set(h(:),'EdgeColor','none');
m_coast('patch',[1 1 1]);
m_grid('box','on','tickdir','in');
colormap(cmap);
colorbar('vert');
title('Bathymetry [m]');
print -dpsc2 -append worldbathy.psc
print
%
figure(1);orient portrait;clf;
limits=[80 0];
figure(1);orient portrait;clf;
m_proj('ortho','long',limits(1),'lat',limits(2));
[c,h]=m_elev('contourf',depths);
set(h(:),'EdgeColor','none');
m_coast('patch',[1 1 1]);
m_grid('box','on','tickdir','in');
colormap(cmap);
colorbar('vert');
title('Bathymetry [m]');
print -dpsc2 -append worldbathy.psc
print
%%
%
figure(1);orient portrait;clf;
limits=[-170 0];
figure(1);orient portrait;clf;
m_proj('ortho','long',limits(1),'lat',limits(2));
[c,h]=m_contourf('contourf',bv);
set(h(:),'EdgeColor','none');
m_coast('patch',[1 1 1]);
m_grid('box','on','tickdir','in');
cmap=colmap(64,2);
colormap(cmap);
colorbar('vert');
title('Bottom Roughness Log_{10}[m^2]');
print -dpsc2 worldbr.psc
print
%
figure(1);orient portrait;clf;
limits=[-20 0];
figure(1);orient portrait;clf;
m_proj('ortho','long',limits(1),'lat',limits(2));
[c,h]=m_contourf('contourf',bv);
set(h(:),'EdgeColor','none');
m_coast('patch',[1 1 1]);
m_grid('box','on','tickdir','in');
cmap=colmap(64,2);
colormap(cmap);
colorbar('vert');
title('Bottom Roughness Log_{10}[m^2]');
print -dpsc2 worldbr.psc
print
%
figure(1);orient portrait;clf;
limits=[80 0];
figure(1);orient portrait;clf;
m_proj('ortho','long',limits(1),'lat',limits(2));
[c,h]=m_contourf('contourf',bv);
set(h(:),'EdgeColor','none');
m_coast('patch',[1 1 1]);
m_grid('box','on','tickdir','in');
cmap=colmap(64,2);
colormap(cmap);
colorbar('vert');
title('Bottom Roughness Log_{10}[m^2]');
print -dpsc2 worldbr.psc
print

% fini
