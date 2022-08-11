function [bv,dbv]=bvfrq(d,t,s,navg)
% function bvfrq  Function to compute Brunt-Vaisala frequency
%    usage: [bv,dbar]=bvfrq(d,t,s,navg)
%    where:    d = depth (m)
%              t = temperature (deg C)
%              s = salinity (PSS-78)
%              navg = number of points to filter over (>= 1)
%              bv (N) ,dbv = output BV and depth
%-- Output is in cph (R Muench mod of 7 Sep 1993)
%-- Version 1.0  J Gunn - Oct 9, 1989
%                navg is restricted to 20% of number of pts in profile

%  Set default for range to compute slope over
if nargin < 4,
     navg = 1;
     fc = 1;
else
     fc = 1./navg;
end

   r=length(d);
	dbv = .5.*(d(1:r-1)+d(2:r));
	tbar = .5.*(t(1:r-1)+t(2:r));
	sbar = .5.*(s(1:r-1)+s(2:r));
	dede=diff(d);
%
%-- gamma is the adiabatic temperature gradient
%
   gamma=agt(dbv,tbar,sbar);
%
%-- adjust the temperature for adiabatic changes
%
	t10 = t(1:r-1)+gamma.*dede./2;
	t20 = t(2:r)-gamma.*dede./2;
%
%-- Use the specific volume anomaly for greater accuracy (as opposed
%-- to the density
%
%-- Scale to the correct units (cc/gm) and add specific volume V(35,0,0)
%
	[alpha1, sigma] = svan(s(1:r-1),t10,dbv);
     alpha1 = alpha1 .* 1.0e-05 + .97266204;
	[alpha2, sigma] = svan(s(2:r),t20,dbv);
     alpha2 = alpha2 .* 1.0e-05 + .97266204;
	abar = .5.*(alpha2+alpha1);
	adif = .5.*(alpha2-alpha1);
          
%     keyboard
	rhog = 981.*(abar.^(-1));
%
%-- Scale to proper units
%
	e = -1.e-5.*rhog.*rhog.*adif./dede*2;
	bv = sqrt(abs(e)).*sign(e);
%
%-- Return zero if no depth change
%
for k=1:length(bv)
	if dede(k) == 0 
		bv(k)=0.;
	end
end

% low pass filter profile
if navg > 1 & navg < fix(.21.*r), bv = lpflt(bv,1,fc);end
bv=(bv./(2*pi))*3600;
