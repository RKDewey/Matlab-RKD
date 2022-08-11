function pltmcuv(v,z,t,vl,zl,mp,np,p,tit,icmap,idev)
% function pltmcuv(v,z,t,vl,zl,mp,np,p,tit,icmap,idev) 
% To plot multiple color adcp velocity images on one page,
%    puts the color velocity scale at the bottom of the page.
%	v = velocity matrix [bins,time]
%	z = vertical axis units (positive depths of bins)
%  t = the time base or range (ie [0 12] for hours), assumes uniform!
%	vl = velocity scale [vmin vmax] values for color map
%	zl = depth range to plot (positive, i.e. [20 300])
%	x-axis scale is determined by the "profile" number in the matrix v
%	mp,np,p = number of subplots (m,n,p)
% Optional
%   tit = title for top of subplot
%   icmap=|1| for colormap(jet) OR = |2| (default) for uv-spectrum(JGunn) 
%	OR icmap=|3| for grey scale (Postscript) OR 4 2-sided grey
%	NEGATIVE icmap to invert color/grey scale
%   idev = 1 for (SVGA) screen, 2 for Color Postscript Laser Printers
% Uses external routines colmap.m and pltdat.m
%	1.0 RKD 3/25/94, 2.0 RKD 12/15/94
if nargin < 11, idev=1; end
if nargin < 10, icmap=2; end
if nargin < 9, tit=' '; end
%
%
mpnp=mp*np;
del=0;% if np>1, del=0.04; end
%if p == 1, clf; end
% make sure there is a small amount of space at bottom of page for scale
%if (mp - fix(mp)) == 0
%   mp=mp+0.35;
%end
h=subplot(mp,np,p);
sa=get(h,'Position');
[m,n]=size(v);
if length(t) == 2,
   xa=[t(1):(t(2)-t(1))/n:t(2)];
 else
   xa=t;
end
ya=abs(z);
ax=[t(1) t(length(t)) abs(zl(1)) abs(zl(2))];
% note: below I set YDir axis to "reverse" which assumes positive 
% depths downwards.
% Use only the first ncols-1 colors/gray values.
ncols=128;
if abs(icmap) == 1, ncols=64; end
vscal=(0:ncols-1);
% scale the velocity data from 0-ncols-1
vsc=((v-vl(1))./(vl(2)-vl(1)))*(ncols-1);
% plot legend first
subplot('Position',[sa(1)+sa(3)*.95+0.02 sa(2) sa(3)*0.05 sa(4)]);
%if mpnp == 1,
%      subplot1(20,1.5,26.75,1,1,3,0.0)
%   else
%      subplot1(29,1.5,43.25,1,1,3,0.0)
%end
image([0 1],vl,vscal');
title('[cm/s]','Fontsize',8);
set(gca,'XTickLabel',[],'YDir','normal','FontSize',8,'YaxisLocation','right');
%
%xa1=[min(xa):(max(xa)-min(xa))/n:max(xa)];
%ya1=[min(ya):(max(ya)-min(ya))/m:max(ya)];
%[xa2,ya2,vsc2]=griddata(xa,ya,vsc,xa1,ya1');
%
subplot('Position',[sa(1) sa(2) sa(3)*0.95 sa(4)]);
image(xa,ya,vsc);set(gca,'YDir','reverse');
h=title(tit);set(h,'FontSize',10);axis(ax);
h=ylabel('Depth (m)');set(h,'FontSize',10);
ypos=get(h,'Position');set(h,'Position',[ypos(1)+del ypos(2) ypos(3)]);
if p == mpnp, 
   h=xlabel('Time');set(h,'FontSize',10);
   pltdat;  % remove if you want to plot anything else after this.
else
   h=xlabel('Time');set(h,'FontSize',10);
end
set(gca,'FontSize',8);
%
if abs(icmap) == 1
% jet has 64 colors (up to red, flip by icmap=-1).
    map=eval('jet');
elseif abs(icmap) == 2
% a more uniform uv-spectrum with green (JGunn) set to 64 values by RKD.
   if idev == 1, 
      map=colmap(ncols,1);
   else
      map=colmap(ncols,2);
   end
elseif abs(icmap) == 3
   % 'gray' scale (flip by calling icmap=-3)
   map=colmap(ncols,1,1);
%    grey0=[(1/5+0.8/60):0.8/60:1];
%    map=[grey0',grey0',grey0'];
 elseif abs(icmap) == 4
%    nc2=ncols/2;
    % 2-sided grey scale (60), dark grey at high (+/-) amplitudes
    map=colmap(ncols,1,2);
%    grey1=[[(1/5+0.8/nc2):0.8/nc2:(1-0.8/nc2)] [1:-0.8/nc2:1/5]];
%    map=[grey1',grey1',grey1'];
%    [mc,nc]=size(map);
%    map(mc,:)=1.0; % so NaN's are white, not black
end
if icmap > 0
   colormap(map); 
else 
   colormap(flipud(map)); 
end
%
