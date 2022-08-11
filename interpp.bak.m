function [X,T]=interpp(x,t,dt)
% [X,T]=interpp(x,t,dtn)
% linear interpolates data in array x(t) with spacing defined by t to new 
% array with new spacing dtn smaller than old spacing dt.
% arrays must be at least 3 elements long, with no NaNs
% RKD 5/9/94, redone 2/97
n=length(x);
if n < 3, return, end
% predetermine the number of final data point expected
nout=(n*(t(n)-t(1))/(n-1))/dt
%
T=(t(1):dt:t(1)+nout*dt);
X(1)=x(1);
for i=2:nout
    i1=max(find(t<T(i))); i2=i1+1;
    dt1=T(i)-t(i1);dt2=t(i2)-t(i1);
    X(i)=x(i1) + (x(i2)-x(i1))*(dt1/dt2);
end
length(X)
% fini
