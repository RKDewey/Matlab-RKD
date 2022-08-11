function pltcadcp(vl,xa,ya,v,ncol)
%
% function pltcadcp(vl,xa,ya,v,ncol) to take adcp velocity matrix in v 
%	and color plot with scales xa, ya
%	v = velocity matrix
%	vl = [vmin vmax] values
%	xa = horizontal axis units
%	ya = vertical axis units
%	ncol = number of color tones used in color scale (i.e. 25)
%
h=uvcmap(120);

colormap(h(1:110,:));
velscle(9,1,9,vl,ncol);
subplot(1.3,1,1);pcolor(xa,ya,v); shading flat; caxis(vl)
ylabel('Depth (m)')

