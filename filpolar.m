function filpolar(theta0,lat,long,c)
% function filpolar(theta0,lat,long,color)
% fills the polygon given by lat,long on a local polar
% projection where theta0 and the latitude and longitude plot limits
% are set the first call to pltpolar with lat=[latmin latmax] 
% long=[longmin longmax] and theta0=-999.
% Fills with color [= 'k' for black as default]
% Calls Dewey's gcdis.m routine to calculate great circle distances
% RKD 4/97
if nargin < 4, c='k'; end
% main body to fill polygon defined by lat,long positions.
indx=find(lat > theta0(2) & lat < theta0(3)... 
          & long > theta0(4) & long < theta0(5));
lat0=lat(indx);
long0=long(indx);
L=length(indx);
if L < 3, return; end  % can not fill 2-d polygon
dontfill=0;
if length(lat) ~= length(lat0),  % then boundary of plot has cut off sections
    if abs(lat0(1)-lat0(L)) > 0.1*abs(theta0(3)-theta0(2)) & ...
          abs(long0(1)-long0(L)) > 0.1*abs(theta0(5)-theta0(4)),  
       dontfill=1;  % do not fill diagonals
    end
    l=L;
    if abs(lat0(1)-lat0(L)) <= abs(long0(1)-long0(L)), % then top or bottom
      if abs(lat0(1)-theta0(2)) < abs(lat0(1)-theta0(3)),
         lat1=theta0(2);  % bottom
      else
         lat1=theta0(3);  % top
      end
      if long0(1) < long0(L),
         for long1=long0(L):-0.1:long0(1),
           l=l+1;
           long0(l)=long1;
           lat0(l)=lat1;
         end
      else
         for long1=long0(L):0.1:long0(1),
           l=l+1;
           long0(l)=long1;
           lat0(l)=lat1;
         end
      end
    else  % a side
      if abs(long0(1)-theta0(4)) < abs(long0(1)-theta0(5)),
         long1=theta0(4);  % left side
      else
         long1=theta0(5);  % right side
      end
      if lat0(1) < lat0(L),
         for lat1=lat0(L):-0.1:lat0(1),
            l=l+1;
            long0(l)=long1;
            lat0(l)=lat1;
         end
      else
         for lat1=lat0(L):0.1:lat0(1),
            l=l+1;
            long0(l)=long1;
            lat0(l)=lat1;
         end
      end   
   end
end
if dontfill==0,
  [rho hdg]=gcdis(89.98*ones(size(lat0)),long0,lat0,long0);
  x=rho.*cos(((long0*pi/180.0)-theta0(1)));
  y=rho.*sin(((long0*pi/180.0)-theta0(1)));
  fill(x,y,c); 
end
% fini