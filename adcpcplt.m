function pltcadcp(vl,xa,ya,v)
%
% function to take adcp velocity matrix in v and color plot with scale
%	v = velocity matrix
%	vl = [vmin vmax] values
%	xa = horizontal axis units
%	ya = vertical axis units
%
h=uvcmap(120);
colormap(h(1:110,:));
subplot(1.3,1,1);pcolor(xa,ya,v); shading flat; caxis(vl)
velscle(9,1,9,vl);
