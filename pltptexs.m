function pltptexs(theta0,lat,long,txt,fontsize)
% function pltptexs(theta0,lat,long,text,fontsize)
% plots symbols at lat,long on a local southern polar
% projection where the latitude and longitude limits
% are set the first call to pltpolas 
% and longitudes are degrees WEST.
% fontsize is in points (default 8)
% calls Dewey's gcdis.m routine to calculate great circle distances
% RKD Dec 8, 1995 
if nargin == 4, fontsize=8; end
[rho hdg]=gcdis(89.98,long,lat,long);
x=-rho*cos(((long*pi/180.0)-theta0(1)));
y=-rho*sin(((long*pi/180.0)-theta0(1)));
x0=[-rho -rho].*cos(((([long+1 long-1])*pi/180)-theta0(1)));
y0=[-rho -rho].*sin(((([long+1 long-1])*pi/180)-theta0(1)));
ang0=atan2((y0(2)-y0(1)),(x0(2)-x0(1)));
h=text(x,y,txt);
set(h,'fontsize',fontsize,'rotation',(ang0*180/pi));
%