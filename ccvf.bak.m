function xc=ccvf(x,y);
% function xc=ccvf(x,y);
% pass back the un-normalized cross-covariance function
% for an auto-covariance function just pass x.
% to normalize: 1) divide by length(x) (biased)
%               2) divide by xc(length(x)) (correlation coefficient)
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

