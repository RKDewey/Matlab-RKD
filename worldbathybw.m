% Script worldbathybw
% RKD 08/98
if ~exist('limits'), limits=[-90 10 0 80]; end
%if ~exist('depths'), depths=[-7000:200:200 100 50 0]; end
if ~exist('depths'), depths=[-0.8:0.2:3.6]; end
load d:\data\ghgt4\bathyvar
figure(1);clf;
%
limits=[-170 0];
dx=.28;dy=0.28;
set(gcf,'PaperPosition',[.25 1.5 8 8]); % make the figure square
ax1=axes('Position',[0.01 .1 dx dy]);hold on
m_proj('ortho','long',limits(1),'lat',limits(2));
%[c,h]=m_elev('contourf',depths);
%set(h(:),'EdgeColor','none');
[c,h]=m_contourf(longgrid,latgrid,bv,depths);
set(h(:),'LineStyle','none');
m_coast('patch',[1 1 1]);
set(gca,'visible','off');
%m_grid('box','on','tickdir','in');
cmap=flipud(colmap(length(depths)+1,1,1));
colormap(cmap);
%colorbar('vert');
%title('Bathymetry [m]');
%print -dpsc2 worldbathy.psc
%print
%
%figure(1);orient portrait;clf;

limits=[-20 0];
ax2=axes('Position',[0.01+dx+0.02 .1 dx dy]);hold on
m_proj('ortho','long',limits(1),'lat',limits(2));
%[c,h]=m_elev('contourf',depths);
%set(h(:),'EdgeColor','none');
[c,h]=m_contourf(longgrid,latgrid,bv,depths);
set(h(:),'LineStyle','none');
m_coast('patch',[1 1 1]);
set(gca,'visible','off');
%m_grid('box','on','tickdir','in');
colormap(cmap);
%colorbar('vert');
%title('Bathymetry [m]');
%print -dpsc2 -append worldbathy.psc
%print
%
%figure(1);orient portrait;clf;

limits=[80 0];
ax3=axes('Position',[0.01+(dx+0.02)*2 .1 dx dy]);hold on
m_proj('ortho','long',limits(1),'lat',limits(2));
%[c,h]=m_elev('contourf',depths);
%set(h(:),'EdgeColor','none');
[c,h]=m_contourf(longgrid,latgrid,bv,depths);
set(h(:),'LineStyle','none');
m_coast('patch',[1 1 1]);
set(gca,'visible','off');
%m_grid('box','on','tickdir','in');
colormap(cmap);
hcb=colorbar('vert');set(hcb,'Position',[0.91 0.1 0.03 dy]);
set(ax3,'Position',[0.01+(dx+0.02)*2 .1 dx dx]); %reset axis size
%title('Bathymetry [m]');
%print -dpsc2 -append worldbathy.psc
%print
cd d:\data
%
print -dps2 bathyvbw.ps
print -deps2 bathyvbw.eps
%
print -f1
clear all
exit
% fini

