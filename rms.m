function rmsx=rms(x,running)
% function rmsx=rms(x,running)
% calculates the rms (root mean square) of x
% is robust to NaNs.
% if running is passed (i.e. 1), then x is running rms
%   rmsx=sqrt((x-flt(x,21)).^2)
% RKD 1/97
nnan=~isnan(x);
if nargin<2,
  xx=abs(x(nnan)).^2;
  rmsx=sqrt(mean(xx));
else
  rmsx=ones(size(x))*NaN;
  rmsx(nnan)=sqrt((x(nnan)-flt(x(nnan),max(fix(length(x)/50+1),21))).^2);
end
% fini
