function [X,T]=pinterp(x,t,dt)
% [X,T]=pinterp(x,t,dt)
% parametric interpolate data in array x(t) with arbitrary spacing 
% defined by t to new array with new spacing dt.
% Original time step need not be an integer multiple of dt.
% Arrays x and t must be at least 3 elements long, equal length, with no NaNs.
% Based on quadratic continueous fit in CIP article vol8num6 p722
% Note: statistics of X and T will be slightly different than x and t
% Useful when the fit or interpolation needs to be continuous/differentiable
% RKD 1/12/95
%     ALSO SEE interpp.m, interpt.m and interps.m
warning off
[r,c]=size(x);
n=length(x);
if n < 3, return, end
% predetermine the number of final data point expected
iflip=0;
if t(1)>t(n), % then flip vectors
   if n==c, % then a column vector
      t=fliplr(t);
      x=fliplr(x);
   else
      t=flipup(t);
      x=flipud(x);
   end
   iflip=1;
end

T=[t(1):dt:t(n)];
nout=length(T);
% first shift whole time series one
x(2:n+1)=x;
t(2:n+1)=t;
% now add ficticious points to front and back ends, remove later.
x(1)=(5*x(2)-4*x(3)+x(4))/2;
x(n+2)=(5*x(n+1)-4*x(n)+x(n-1))/2;
t(1)=(5*t(2)-4*t(3)+t(4))/2;
t(n+2)=(5*t(n+1)-4*t(n)+t(n-1))/2;
%
j=1;
X(j)=x(2);
for i=2:n
    nt=T(find( T>t(i) & T<=t(i+1) ));
    ni=length(nt);
    w1=(1/(t(i+1)-t(i))).*(t(i+1)-nt);
    w2=(1/(t(i+1)-t(i))).*(nt-t(i));
    X(j+1:j+ni)=(w1.*...
     (polyval(polyfit([t(i-1) t(i) t(i+1)],[x(i-1) x(i) x(i+1)],2),nt)))...
     +(w2.*...
     (polyval(polyfit([t(i) t(i+1) t(i+2)],[x(i) x(i+1) x(i+2)],2),nt)));
    j=j+ni;
end
if iflip==1, % then flip vectors
   if n==c, % then a column vector
      T=fliplr(T);
      X=fliplr(X);
   else
      T=flipup(T);
      X=flipud(X);
   end
end
warning on
%
