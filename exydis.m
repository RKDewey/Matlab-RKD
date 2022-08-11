function [d]=edis(lat1,lon1,lat2,lon2)
% Function to calculate distance in meters between two positions in
% latitude and longitude.
%
% Usage: d = edis(lat1,lon1,lat2,lon2)
%
% Uses law of cosines in spherical coordinates to calculate distance
%
raddeg=180/pi;
degrad=1/raddeg;
lat1=lat1.*degrad;
lat2=lat2.*degrad;
lon1=lon1.*degrad;
lon2=lon2.*degrad;
coslat1=cos(lat1);
sinlat1=sin(lat1);
coslat2=cos(lat2);
sinlat2=sin(lat2);
dtmp=cos(lon1-lon2);
dtmp=sinlat1.*sinlat2 + coslat1.*coslat2.*dtmp;
for i = 1:length(dtmp)
if dtmp(i) > 1. 
     dtmp(i) = 1.;
end
if dtmp(i) < -1.
     dtmp(i) = -1.;
end
end
d=(111112) * raddeg .* acos(dtmp);