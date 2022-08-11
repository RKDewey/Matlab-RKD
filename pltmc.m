function ax=pltmc(z,x,y,zl,xl,yl,mnp,tit,icmap,idev,units)
% function pltmc(z,x,y,zl,xl,yl,[mp np p],tit,icmap,idev,units) 
% To plot multiple color images on one page,
%    puts the color scale at the right side of the subplot.
%	z = image matrix [columns(y),rows(x)]
%  x = the row/time base, NOTE image assumes uniform!
%	y = column/vertical base (positive depths of bins)
%	zl = data scale [zmin zmax] values for color map
%  xl = X range to plot
%	yl = Y range to plot
%	[mp np p] = number of subplots (m,n,p)
% Optional
%   tit = title for top of subplot, (and x and y labels) strvcat('title,'xlabel','ylabel')
%   icmap= is the idev for colmap(ncol,idev), negative to reverse colormap
%  units = text of the units for the color scale
%  mnp can also include subplot1 contractions
% Output: ax=[ax1 ax2] are the handles from ax=gca;
% Uses external routines colmap.m and pltdat.m
%	1.0 RKD 3/25/94, 2.0 RKD 12/15/94, 2.1 RKD 11/97
if nargin < 11, units='[cm/s]'; end
if nargin < 10, idev=1; end
if nargin < 9, icmap=2; end
if nargin < 8, tit=' '; end
if nargin < 7, mnp=[1 1 1]; end
units=[' ',units];
%
mp=mnp(1);np=mnp(2);p=mnp(3);
mpnp=mp*np;
if length(mnp)<7,
   h=subplot(mp,np,p); % blank out the required plot region
else
   h=subplot1(mp,np,p,mnp(4),mnp(5),mnp(6),mnp(7));
end
sa=get(h,'Position'); % get the position of the plot region
[m,n]=size(z);
fs=14;
if mpnp > 2 & mpnp < 21, 
    fs=10; 
elseif mpnp >= 21, 
    fs=6; 
end
%
ax=[xl(1) xl(2) min(yl) max(yl)];
ix=find(x>=ax(1)&x<=ax(2));
xa=x(ix);
iy=find(y>=ax(3)&y<=ax(4));
ya=y(iy);
ncols=64;
zscal=[zl(1):(zl(2)-zl(1))/(ncols-1):zl(2)];
if mpnp < 21,
   % plot legend first in 5% of subplot region
   subplot('Position',[sa(1)+sa(3)*.95+0.02 sa(2) sa(3)*0.05 sa(4)]);
   imagesc([0 1],zl,zscal',zl);
   title(units,'Fontsize',fs);
   set(gca,'XTickLabel',[],'YDir','normal','FontSize',fs-2,'YaxisLocation','right');
   ax2=gca;
end
% Now plot image in 95 % of plot region 
if mpnp < 21,
   subplot('Position',[sa(1) sa(2) sa(3)*0.95 sa(4)]);
else
   subplot('Position',[sa(1) sa(2) sa(3) sa(4)]);
end
%
imagesc(xa,ya,z(iy,ix),zl);
%
    
if xl(1)>730000, axdate; end % Then time maybe mtime 
if mpnp < 21,
   ylabel('Depth (m)','FontSize',fs);
end
set(gca,'YDir','reverse','XLim',[xl(1) xl(2)],'YLim',[yl(1) yl(2)]);
%axis(ax);
%
if mpnp < 21,
if p == mpnp, % if this is the last subplot
   h=xlabel('Time');set(h,'FontSize',fs);
else
   h=xlabel('Time');set(h,'FontSize',fs);
end
end
set(gca,'FontSize',fs-1);
ax1=gca;
[mt,nt]=size(tit);
h=title(tit(1,:),'FontSize',fs);
if mt > 1, hxt=xlabel(tit(2,:),'FontSize',fs); end
if mt > 2, hxt=ylabel(tit(3,:),'FontSize',fs); end
if mpnp > 2,  % then we may need to shift titles away from axes labels
   tp=get(h,'Position');
   set(h,'Position',[ax(1) ax(3) tp(3)],'HorizontalAlignment','left');
end

%
if icmap ~= 0,
    map=colmap(ncols,icmap);
else
    map=jet(ncols);
end
if icmap > 0,
   colormap(map); 
elseif icmap < 0,
   colormap(flipud(map)); 
end
ax=[ax1 ax2];
%
