function [d,hdg]=gcdis(lat1,lon1,lat2,lon2)
% Function to calculate distance in kilometers and heading between two
% positions in latitude and longitude.
% Assumes -90 > lat > 90  and  -180 > long > 180
%    north and east are positive
% Usage: [d,hdg] = nvgtn(lat1,lon1,lat2,lon2)
% Uses law of cosines in spherical coordinates to calculate distance
% calculate conversion constants
raddeg=180/pi;
degrad=1/raddeg;
% convert latitude and longitude to radians
lat1=lat1.*degrad;
lat2=lat2.*degrad;
lon1=-lon1.*degrad;
lon2=-lon2.*degrad;
% calculate some basic functions
coslat1=cos(lat1);
sinlat1=sin(lat1);
coslat2=cos(lat2);
sinlat2=sin(lat2);
%calculate distance on unit sphere
dtmp=cos(lon1-lon2);
dtmp=sinlat1.*sinlat2 + coslat1.*coslat2.*dtmp;

% check for invalid values due to roundoff errors
for i = 1:length(dtmp)
if dtmp(i) > 1. 
     dtmp(i) = 1.;
end
if dtmp(i) < -1.
     dtmp(i) = -1.;
end
end

% convert to meters for earth distance
ad = acos(dtmp);
d=(111.112) .* raddeg .* ad;

% now find heading
hdgcos = (sinlat2-sinlat1.*cos(ad))./(sin(ad).*coslat1);

% check value to be legal range
for i=1:length(hdgcos)
     if hdgcos(i) > 1. 
          hdgcos(i) = 1.;
     end
     if hdgcos(i) < -1.
          hdgcos(i) = -1.;
     end
end
hdg = acos(hdgcos).*raddeg;

% if longitude is decreasing then heading is between 180 and 360
test = sin(lon2-lon1);
for i=1:length(test)
if (test(i) > 0.0)
     hdg(i) = 360 - hdg(i);
end
end
