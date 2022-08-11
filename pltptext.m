function pltptext(theta0,lat,long,txt,fontsize)
% function pltpsym(theta0,lat,long,text,fontsize)
% plots text at lat,long on a local polar
% projection where the latitude and longitude limits
% are set the first call to pltpolar 
% and longitudes are always in EAST. (east=360-west)
% fontsize is in points (i.e. 8)
% calls Dewey's gcdis.m routine to calculate great circle distances
% RKD Dec 8, 1995 
if nargin < 5, fontsize=8; end
idx=find(lat > theta0(2) & lat < theta0(3) ...
            & long > theta0(4) & long < theta0(5));
if length(idx) >= 1,
   [rho hdg]=gcdis(89.98,long(idx),lat(idx),long(idx));
   x=rho.*cos(((long(idx)*pi/180.0)-theta0(1)));
   y=rho.*sin(((long(idx)*pi/180.0)-theta0(1)));
   x0=[rho rho].*cos(((([long(idx)-1 long(idx)+1])*pi/180)-theta0(1)));
   y0=[rho rho].*sin(((([long(idx)-1 long(idx)+1])*pi/180)-theta0(1)));
   for i=1:length(idx),
     ang0=atan2((y0(i,2)-y0(i,1)),(x0(i,2)-x0(i,1)));
     h=text(x(i),y(i),char(txt(idx(i),:)));
     set(h,'fontsize',fontsize,'rotation',(ang0*180/pi));
   end
end
%