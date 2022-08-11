function [rv,rvt]=runvar2(x,n,t);
% function [rv,rvt]=runvar2(x,n,t);
% running variance of x, blocked into n length segments.
% Optional
%   input t as time stamp
%   output rvt as new time stamp
N=length(x);
I=fix(N/n);
N=I*n; % new length of input
X=reshape(x(1:N),n,I);
rv=var(X);
if nargin>2,
   T=reshape(t(1:N),n,I);
   rvt=mean(T);
end
% fini