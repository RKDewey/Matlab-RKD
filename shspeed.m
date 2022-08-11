function [su,sv]=shspeed(Sspd,Shdg,ifilt,itype,time)
%  Usage: [su,sv]=shspeed(Sspd,Shdg,ifilt,itype,time)
%	  ship speed (Sspd) in knots (=51.4 cm/s) and Shdg (deg +clkwise from N)
%		if itype=1 (default)
%  or Sspd=Long Shdg=Lat if itype=2
%	  ifilt = filter length in odd number of pionts (default 9)
%         su=east-west ship speed speed
%         sv=north-south ship speed speed
%  If itpye=2 (i.e. lat and long), then need time base (assumed Julian)
%	1.0  RKD  3/24/94
%
if nargin < 3, ifilt=9; end
if nargin < 4, itype=1; end
if itype==1,
	% ship speed converted to cm/s from knots
	ssp=Sspd*51.4; % convert into cm/s
else
   long=Sspd;lat=Shdg;
   j=0;
   for i=2:length(lat),
      j=j+1;
      [dis,hdg]=gcdist(lat(i-1),long(i-1),lat(i),long(i)); % in m
      d(j)=dis*100;Shdg(j)=hdg;
   end
   dt=diff(time)*24*3600; % time difference in s
   ssp=d/dt;
end
dir=(90-Shdg)*pi/180;
% Now make a row arrays with the east and north ship velocities
su=cos(dir).*ssp;
sv=sin(dir).*ssp;
su(1)=su(2);
sv(1)=sv(2);
if ifilt>2,
  	su=flt(su,ifilt);
  	sv=flt(sv,ifilt);
end
%
