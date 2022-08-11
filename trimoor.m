function [xm,ym]=trimoor(x0,x,y0,y,r,depth);
% [xm,ym]=trimoor(Longd,longm,Latd,latm,ranges,depths);
% Find a Mooring using triangulation/cross of circles
% Longd and Latd are single valued Long/Lat degrees.
% Enter the Longm [minutes only] and Latm [minutes only] 
% and ranges [m] obtained using an acoustic ranging device.
% Optional: depths are the water depths, assuming device is on bottom.
% The locating "cicles" will then be plotted. 
% Click with the mouse on the centre of the overlap region.
% Press "Enter" to return the coordinates of the mooring
% RKD 06/2001
if nargin<6, depth=0; end
% clf;
[n,m]=size(x);
lat=x0(1)+y/60;
long=y0(1)+x/60;
kpdlon=gcdist(lat(1),long(1),lat(1),long(1)+1);
kpdlat=gcdist(lat(1),long(1),lat(1)+1,long(1));
mpmlon=kpdlon*1000/60; % minutes per meter
mpmlat=kpdlat*1000/60;
h=sqrt(r.^2 - depth.^2);
h0=h./mpmlat;
plot(x,y,'o');
hold on;
for i=1:n,
   dy=[-h0(i):0.00001:h0(i)];
   dx=sqrt(h0(i).^2 - dy.^2);
   X=[x(i)+dx x(i)-dx];
   Y=[y(i)+dy y(i)-dy];
   plot(X,Y,'k');
end
xlabel('Minutes Longitude West');ylabel('Minutes Latitude North');
title('Mooring Range Survey: 0.1 minutes Latitude = 185 m');
set(gca,'PlotBoxAspectRatioMode','manual');
% 
disp('Now use mouse to click on estimated mooring location, then Enter.');
[xm,ym]=ginput;
disp(' Longitude      Latitude');
for i=1:length(xm),
   disp([num2str(x0(1),3),' ',num2str(xm(i)),'     ',num2str(y0(1),2),' ',num2str(ym(i))]);
end
xm=x0+xm/60;ym=y0+ym/60;
%

   

   