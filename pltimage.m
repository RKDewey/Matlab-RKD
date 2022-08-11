function pltimage(z,xa,ya,zl,xl,yl,mp,np,p,xtit,ytit,tit,icmap)
%function pltimage(z,xa,ya,zl,xl,yl,mp,np,p,xtit,ytit,tit,icmap)
% Plot multiple color images on one page, puts the scale at bottom of page.
%	z = data matrix
%     xa,ya= vectors of axes units in x and y directions
%	zl = data scale [zmin,zmax] values for color map
%	xl = x axis limits to plot (xmin xmax)
%     yl = y axis limits tp plot (ymin,ymax)
%	mp,np,p = number of subplots (m,n,p)
%	xtit,ytit,tit = axes and plot titles
%     icmap=|1| for colormap(jet) OR = |2| for uv-spectrum(JGunn) 
%	OR icmap=|3| for grey scale (Postscript) OR 4 2-sided grey
%	NEGATIVE icmap to invert color/grey scale
% Uses external routines colmap.m and pltdat.m
%	1.0 RKD 1/9/95

ipltdat=0;
if p == mp, ipltdat = 1; end
% make sure there is a small amount of space at bottom of page for scale
if (mp - fix(mp)) == 0
   mp=mp+0.35;
end
[m,n]=size(z);
ax=[xl(1) xl(2) yl(1) yl(2)];
% Use only colors/gray values 2 thru 61, leaving 1 for brown=land
zscal=(2:61);
% scale the data from 2-61
zsc=(((z-zl(1))./(zl(2)-zl(1)))*59)+2;
%
subplot(15,1.5,22.26);image(zl,[0 1],zscal);
set(gca,'YTickLabels',[]);
%
subplot(mp,np,p);image(xa,ya,zsc);
set(gca,'YDir','normal');
title(tit);axis(ax);
xlabel(xtit);ylabel(ytit);set(gca,'FontSize',8);
if ipltdat == 1, pltdat; end
%
if abs(icmap) == 1
% jet has 64 colors (up to red, flip by icmap=-1).
    map=eval('jet');
elseif abs(icmap) == 2
% a more uniform uv-spectrum with green (JGunn) set to 64 values by RKD.
    map=colmap;
elseif abs(icmap) == 3
% 'gray' scale (flip by calling icmap=-3)
    grey0=[(1/5+0.8/60):0.8/60:1];
    map=[grey0',grey0',grey0'];
elseif abs(icmap) == 4
% 2-sided grey scale (60), dark grey at high (+/-) amplitudes
    grey1=[[(1/5+0.8/30):0.8/30:(1-0.8/30)] [1:-0.8/30:1/5]];
    map=[grey1',grey1',grey1'];
end
if icmap > 0
   colormap(map); 
else 
   colormap(flipud(map)); 
end
%
