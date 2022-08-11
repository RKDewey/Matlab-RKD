function [su,sv,latuv,longuv,time]=shipspeed(lat,long,jd)
%
% function [su,sv,latuv,longuv,time]=shipspeed(lat,long,jd)
% 
% Calculate the ship speed given a time series of lats and longs
%           where jd is assumed to be a time stamp in julian days.
% Output: su and sv are east and north ship speeds in m/s
% Note: this version assumes Longs are +westward, Lats +northward !!
% 1.0 RKD 11/97
long=-long;
dt=diff(jd)*24*3600;  % time difference time series in s
ii=[1:length(dt)];
time=jd(ii)+dt/(24*3600);
dlong=diff(long);
dlat=diff(lat);
longuv=-long(ii)+dlong/2;
latuv=lat(ii)+dlat/2;
i=ii+1;
%
dx=gcdist(long(i),lat(i)+dlat/2,long(ii),lat(i)+dlat/2)*1000;
dy=gcdist(long(i)+dlong/2,lat(i),long(i)+dlong/2,lat(ii))*1000;
%
su=dx.*sign(dlong)./dt;
sv=dy.*sign(dlat)./dt;
%
% clip if speed is greater than 14 knots
speed=sqrt(su.^2 + sv.^2);
ilrg=find(speed/0.55 > 14);
if ~isempty(ilrg),
   su(ilrg)=su(ilrg).*NaN;
   sv(ilrg)=sv(ilrg).*NaN;
   [su,to]=cleanx(su,time);
   [sv,to]=cleanx(sv,time);
end
% fini