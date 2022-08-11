function imagesclogy(x,y,z,clim)
% function imagesclogy(x,y,z,clim)
%
% Re-amp the data in matrix z with x-axis vector x and y-axis vector y
% so that the y-axis is now in log10, like a semilogy plot.
% the data must be re-mapped into new pixels in xl, since the y-axis bins are now stretched.

% RKD 10/10
pcolor(x,y,z);
shading interp;
set(gca,'YScale','log','CLim',clim);
% fini