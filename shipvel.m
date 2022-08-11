function [su,sv]=shipvel(long,lat,time);
% function [su,sv]=shipvel(long,lat,time);
%
% take nav long, lat and time, i.e. from VMDAS ENX, or alternate
% e.g. adcp.nav_slatitude and slongitude and
% make ship velocity east (su) and ship velocity north (su) to be subtracted
% from adcp.east_vel and adcp.north_vel to give referenced velocities.
% RKD 12/07
% long=adcp.nav_slongitude;
% lat=adcp.nav_slatitude;
% time=adcp.nav_mtime;
dt=diff(time)*24*3600;
[nb,nt]=size(time);
for i=2:nt,
    j=i-1;
    [ds,hdg]=gcdist(lat(j),long(j),lat(i),long(i));
    [u,v]=vector(ds*1000,(90-hdg)*pi/180,1);
    U(j)=u/dt(j);
    V(j)=v/dt(j);
end
U(nt)=U(nt-1);
V(nt)=V(nt-1);
if length(U)>14,  % then smooth these a little
   u=flt(U,3);
   v=flt(V,3);
end
for j=1:nb,
    U(j,:)=u;
    V(j,:)=v;
end
su=U;
sv=V;
% fini

function [d,hdg]=gcdist(lat1,lon1,lat2,lon2)
% function [d,hdg]=gcdist(lat1,lon1,lat2,lon2)
% Function to calculate distance in kilometers and heading between two
% positions in latitude and longitude.
% Assumes -90 > lat > 90  and  -180 > long > 180
%    north and east are positive
% Uses law of cosines in spherical coordinates to calculate distance
% calculate conversion constants
raddeg=180/pi;
degrad=1/raddeg;
% convert latitude and longitude to radians
lat1=lat1.*degrad;
lat2=lat2.*degrad;
in1=find(lon1>180);lon1(in1)=lon1(in1)-360;
in2=find(lon2>180);lon2(in2)=lon2(in2)-360;
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
in1=find(dtmp>1.0);dtmp(in1)=1.0;
in2=find(dtmp<-1.0);dtmp(in2)=-1.0;

% convert to meters for earth distance
ad = acos(dtmp);
d=(111.112) .* raddeg .* ad;

% now find heading
hdgcos = (sinlat2-sinlat1.*cos(ad))./(sin(ad).*coslat1 + 1e-20);

% check value to be legal range
in1=find(hdgcos>1.0);hdgcos(in1)=1.0;
in2=find(hdgcos<-1.0);hdgcos(in2)=-1.0;
hdg = acos(hdgcos).*raddeg;

% if longitude is decreasing then heading is between 180 and 360
test = sin(lon2-lon1);
in1=find(test>0.0);
hdg(in1)=360-hdg(in1);
% fini
function [x,y]=vector(alen,angl,coor)
%  function (x,y)=vector(alen,angl,coor)
%  convert vector coordinates from x,y to magnitude and angle (radians) from x.
%  IF coor = 0, then output (x,y) are magnitude and angle
%  IF coor = 1, then output (x,y) are orthogonal x and y components
%  RKD Sept 1995
if coor == 0
   x=sqrt(alen.*alen + angl.*angl);
   y=atan2(angl,alen);
elseif coor == 1
   x=alen.*cos(angl);
   y=alen.*sin(angl);
end
% end
function xf=flt(x,fpts);
%
% function xf=flt(x,fpts) to low pass filter a time series using filtfilt 
%   passed both ways. 
%   Since filtfilt passes both ways already, this ties both ends
%   of the filtered time series to the original ends.
%	x = array
%	fpts = number of points for filter length (odd) i.e. 3,5,7
%	xf = filtered array
% RKD 12/94

% make a mask for the data that are NaN's
mask=ones(size(x));
idx=isnan(x);mask(idx)=idx(find(idx)).*NaN;
idx=isinf(x);mask(idx)=idx(find(idx)).*NaN;
x=x.*mask;
% chop off leading and trailing NaN's but keep track so they can be put back
%    later.
npts=length(x);
idx1=min(find(~isnan(x))); idx2=max(find(~isnan(x)));
lnan=[];
tnan=[];
if idx1>1
     lnan=x(1:idx1-1);
end
if idx2<npts
     tnan=x(idx2+1:npts);
end
x=x(idx1:idx2);

% clean up any interior gaps by linearly interpolating over them
[x,tcln]=cleanx(x,1:length(x));

% calculate filter weights
Wn=fix(1.5*fpts);
b=fir1(Wn,(1/(fpts*2)));
m=length(x);
% set weights for forward and reverse sum
winc=1./(m-1);
wt1= 1:-winc :0 ;
wt2= 0: winc :1 ;

% calculate forward filter time series, save
xf1=zeros(size(x));
xf1=filtfilt(b,1,x);

% flip (invert) time series, filter, and unflip
xi=zeros(size(x));
xf2=zeros(size(x));

% flip time series but check for horizontal or vertical matrix
[r,c]=size(x);
if r>c
     xi=flipud(x);
else
     xi=fliplr(x);
end

xi=filtfilt(b,1,xi);

if r>c
     xf2=flipud(xi);
else
     xf2=fliplr(xi);
end

xf=zeros(size(x));
if r>c
     xf=xf1.*wt2' + xf2.*wt1';
else
     xf=xf1.*wt2 + xf2.*wt1;
end

% reattach leading and trailing Nan's and apply mask for interior gaps
if r>c
     xf=[lnan
         xf
         tnan];
else
     xf=[lnan xf tnan];
end
xf=xf.*mask;
% end
function [tsout,tout]=cleanx(tsin,tin);
%
%  Function [tsout,tout]=cleanx(tsin,tin)
%   or
%  Function [tsout]=cleanx(tsin)
%  Fills in the NaN's in a data set by using linear interpolation,
%
%  4/7/94 RKD - chunk end NaN values first.
% Chunk off NaN values.
n=length(tsin);
if nargin == 1, tin=[1:n]; end
tsout=tsin; tout=tin;
ist=min(find(isnan(tsin)==0));
iend=max(find(isnan(tsin)==0));
if isempty(ist), disp('No good data in this time series (cleanx.m)'); return; end;
if ist ~= 1 | iend ~= n
   newn=iend-ist+1;
   if newn <= 1, return, end;
   tsnew(1:newn)=tsin(ist:iend);
   tnew(1:newn)=tin(ist:iend);
   tsin=tsnew;
   tin=tnew;
end
%
nn  = 0;                                   % counter for NaNs filled
lt = length(tsin);                         % length of input array
%if lt ~= n, fprintf(1,'%5d NaNs truncated from time series\n',(n-lt)); end
nan1 = isnan(tsin);
nnan = sum(nan1);                          % # of NaN's to be replaced
%
% send info to screen
%
% loop through data filling in NaN's
while sum(nan1)>0,
   ii=min(find(nan1==1));
   jj = (ii-1) + ffirsti(tsin(ii:lt)); % find next good point
   kk = jj - ii;                       % number of points to fill
   delx = (tsin(jj)-tsin(ii-1))/(kk+1);
   i=[1:kk];
   tsin(ii-1+i)=tsin(ii-1)+(i*delx);
   nan1 = isnan(tsin);     % recalculate the NaN array
   nn = nn+kk;             % increment summary counter
end
%if nn > 0, fprintf(1,'%5d NaNs were filled\n',nn); end
tsout=tsin;
tout=tin;
% fini
