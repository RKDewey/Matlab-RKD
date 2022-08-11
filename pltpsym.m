function pltpsym(theta0,lat,long,sym,ss)
% function pltpsym(theta0,lat,long,sym,ssize)
% plots symbols at lat,long on a local polar
% with scale factor ssize (default ssize=2)
% lat, long, ss must be same size (or ss=constant)
% projection where the latitude and longitude limits
% are set the first call to pltpolar 
% and longitudes are always in EAST. (east=360-west)
% calls Dewey's gcdis.m routine to calculate great circle distances
% RKD Dec 8, 1995 
if nargin < 5, ss=2; end
if length(ss) == 1, ss=ones(size(lat))*ss; end
idx=find(lat > theta0(2) & lat < theta0(3) ...
            & long > theta0(4) & long < theta0(5));
lat0=lat(idx);
long0=long(idx);
ss0=ss(idx);
if length(lat0) >= 1,
   [rho hdg]=gcdis(89.98,long0,lat0,long0);
   x=rho.*cos(((long0*pi/180.0)-theta0(1)));
   y=rho.*sin(((long0*pi/180.0)-theta0(1)));
   for i=1:length(x)
       h=plot(x(i),y(i),sym);
       set(h,'markersize',ss(i));
   end
end
%