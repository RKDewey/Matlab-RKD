function pltpsyms(theta0,lat,long,sym)
% function pltpsyms(theta0,lat,long,sym)
% plots symbols at lat,long on a local southern polar
% projection where the latitude and longitude limits
% are set the first call to pltpolar 
% and longitudes are degrees WEST.
% calls Dewey's gcdis.m routine to calculate great circle distances
% RKD Dec 8, 1995 
[rho hdg]=gcdis(89.98,long,lat,long);
x=-rho.*cos(((long*pi/180.0)-theta0(1)));
y=-rho.*sin(((long*pi/180.0)-theta0(1)));
h=plot(x,y,sym);
set(h,'markersize',4);
%