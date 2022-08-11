function theta0=pltpolas(theta0,lat,long,linetype)
% function theta0=pltpolas(theta0,lat,long,linetype)
% plots a line of the data in lat,long on a local polar
% projection from the perspective of the southern hemisphere
% where theta0 and the latitude and longitude plot limits
% are set the first call to pltpolar with lat=[latmin latmax] 
% long=[longwest longeast] and theta0=-999. Subsequent calls require
% this plot's theta0 as an input argument.
% Latitudes are in degrees S increasing (+) to the south
% and longitudes are in degress WEST! i.e. [30 -50]=[30W to 50E]
% calls Dewey's gcdis.m routine to calculate great circle distances
% RKD Dec 8, 1995 
first=0;
% if first call, determine the rotation of the central longitude.
if theta0(1) == -999,
   first=1;
   theta0(1)=90.0+(long(1)+long(2))/2.0;
   theta0(1)=theta0(1)*pi/180.0;
   theta0(2:3)=lat;theta0(4:5)=long;
   long2=long(1):-0.2:long(2);
   long3=long(2):0.2:long(1);
   lat2=ones(size(long2))*lat(2);
   lat3=ones(size(long3))*lat(1);
   lat=[lat(1) lat2 lat3];
   long=[long(1) long2 long3];
end;
% main body to plot line at lat,long positions. (every call)
%if first == 0,
%   lat0=lat(find(lat > theta0(2) & lat < theta0(3) ...
%      & long > theta0(4) & long < theta0(5)));
%   long0=long(find(lat > theta0(2) & lat < theta0(3) ...
%      & long > theta0(4) & long < theta0(5)));
%   lat=lat0;
%   long=long0;
%end
% Convert lats and longs into polor coordinates.
[rho hdg]=gcdis(89.98*ones(size(lat)),long,lat,long);
x=-rho.*cos(((long*pi/180.0)-theta0(1)));
y=-rho.*sin(((long*pi/180.0)-theta0(1)));
plot(x,y,linetype);
% Label and fix axes first time through (equal x and y dimensions)
if first == 1,
% set tick marks to be a 2% of plot size, or 20 km.
 hold on
 ax=axis;
 tick=0.02*max(abs(ax(2)-ax(1)),abs(ax(4)-ax(3)));
 if tick < 20, tick=20; end;
 n1=2;
 n2=max(size(long2))+1;
 n3=n2+1;
 n4=max(size(y));
% determine tick angles along left and right sides
 ang0=atan2((y(n4-2)-y(n4)),(x(n4-2)-x(n4)));
 ang1=atan2((y(n3)-y(n3+2)),(x(n3)-x(n3+2)));
 dx=tick*cos([ang0 ang1]);
 dy=tick*sin([ang0 ang1]);
 if abs(lat(2)-lat(1)) >= 10,
    dlat=5;
 else
    dlat=2;
 end;
% determine tick locations for latitude labels
 lat0=(lat(1):dlat:lat(2));
 long0=long(1)*ones(size(lat0));
 [rho0 hdg0]=gcdis(89.98*ones(size(lat0)),long0,lat0,long0);
 x0=-rho0.*cos(((long0*pi/180.0)-theta0(1)));
 y0=-rho0.*sin(((long0*pi/180.0)-theta0(1)));
 long1=long(n2)*ones(size(lat0));
 x1=-rho0.*cos(((long1*pi/180.0)-theta0(1)));
 y1=-rho0.*sin(((long1*pi/180.0)-theta0(1)));
% label latitude tick marks
 for i=1:max(size(lat0))
     llat=int2str(lat0(i));
     plot([x0(i) x0(i)-dx(1)],[y0(i) y0(i)-dy(1)],'w');
     h=text([x0(i)-3.5*dx(1)],[y0(i)-3*dy(1)],llat);
     set(h,'rotation',(ang0*180.0/pi));
     plot([x1(i) x1(i)+dx(2)],[y1(i) y1(i)+dy(2)],'w');
     h=text([x1(i)+2*dx(2)],[y1(i)+1.7*dy(2)],llat);
     set(h,'rotation',(ang1*180.0/pi));
 end;
% determine longitude tick marks
 if abs(long(2)-long(n2)) > 10,
    dlong=-10;
 elseif abs(long(2)-long(n2)) > 5,
    dlong=-2;
 else,
    dlong=-1;
 end;
% determine positions of longitude tick marks, top and bottom
 long0=long(2):dlong:long(n2);
 lat0=lat(2)*ones(size(long0));
 [rho0 hdg0]=gcdis(89.98*ones(size(lat0)),long0,lat0,long0);
 x0=-rho0.*cos(((long0*pi/180.0)-theta0(1)));
 y0=-rho0.*sin(((long0*pi/180.0)-theta0(1)));
 lat1=lat(1)*ones(size(long0));
 [rho1 hdg1]=gcdis(89.98*ones(size(lat1)),long0,lat1,long0);
 x1=-rho1.*cos(((long0*pi/180.0)-theta0(1)));
 y1=-rho1.*sin(((long0*pi/180.0)-theta0(1)));
% determine positions of longitude labels
 rho2=rho1+2.5*tick;
 x2=-rho2.*cos((((long0-dlong/12)*pi/180.0)-theta0(1)));
 y2=-rho2.*sin((((long0-dlong/12)*pi/180.0)-theta0(1)));
 nticks=max(size(long0));
% adjust the angle of the label
 dang=(ang1-ang0)/(nticks-1);
 ang=ang0:dang:ang1;
 dx=-tick*cos(ang-pi/2);
 dy=-tick*sin(ang-pi/2);
 for i=1:nticks
     llong=int2str(abs(long0(i)));
     plot([x0(i) x0(i)+dx(i)],[y0(i) y0(i)+dy(i)],'w');
     plot([x1(i) x1(i)+dx(i)],[y1(i) y1(i)+dy(i)],'w');
     h=text(x2(i),y2(i),llong);
     set(h,'rotation',(ang(i)*180.0/pi));
 end;
 axis('equal');
 axis('off');
 axis(axis);
end;
% fini