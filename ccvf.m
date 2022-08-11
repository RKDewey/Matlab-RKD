function xc=ccvf(x,y);
% function xc=ccvf(x,y);
% Pass back the un-normalized cross-covariance function.
% For an auto-covariance function just pass x.
% To normalize: 1) divide by length(x) (biased)
%               2) divide by xc(length(x)) (correlation coefficient)
% This is identical to MATLAB's xcorr(x), but much slower for large x
% RKD 2/97
if nargin == 1, y=x; end
if length(x) ~= length(y), disp(['(x,y) must be same length.']); return; end
n=length(x);
for i=1:n
    j=n-i+1;
    xc(i)=sum(x(1:i).*y(j:n));
end
% continue only if not auto-correlation
if nargin == 2,
  xc=fliplr(xc);  % flipback
  j=1;
  for i=n+1:2*n-1
    j=j+1;
    xc(i)=sum(x(j:n).*y(1:n-j+1));
  end
else
  xc=[xc(1:n-1) fliplr(xc)];
end
% fini

