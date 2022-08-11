function [X,T]=tinterp(x,t,T);
% function [x3,t3]=tinterp(x1,t1,t2);
% Interpolate a time series X1(T1) [both vectors] onto a new timebase T2.
% Uses pinterp algorithm (quadratic curver fitter) to find values of x1,t1
% at the new times specified by t2.
% RKD 11/01
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
      t=flipud(t);
      x=flipud(x);
   end
   iflip=1;
end
indx=find(T>t(1)&T<t(end));
T=T(indx); % this is the new time base
nout=length(T);
% first shift whole time series one
x(2:n+1)=x;
t(2:n+1)=t;
% now add ficticious points to front and back ends.
x(1)=(5*x(2)-4*x(3)+x(4))/2;
x(n+2)=(5*x(n+1)-4*x(n)+x(n-1))/2;
t(1)=(5*t(2)-4*t(3)+t(4))/2;
t(n+2)=(5*t(n+1)-4*t(n)+t(n-1))/2;
%
j=1;
xm=mean(x);tm=mean(t); % things are really helped by removing the means.
for i=2:n
    nt=T(find( T>=t(i) & T<t(i+1) ));
    ni=length(nt);
    w1=(1/(t(i+1)-t(i))).*(t(i+1)-nt);
    w2=(1/(t(i+1)-t(i))).*(nt-t(i));
    tt1=[t(i-1) t(i) t(i+1)];tt1m=mean(tt1);
    xx1=[x(i-1) x(i) x(i+1)];xx1m=mean(xx1);
    tt2=[t(i) t(i+1) t(i+2)];tt2m=mean(tt2);
    xx2=[x(i) x(i+1) x(i+2)];xx2m=mean(xx2);
    X(j:j+ni-1)=(w1.*...
     (polyval(polyfit(tt1-tt1m,xx1-xx1m,2),nt-tt1m)+xx1m))...
     +(w2.*...
     (polyval(polyfit(tt2-tt2m,xx2-xx2m,2),nt-tt2m)+xx2m));
    j=j+ni;
end
if iflip==1, % then flip vectors
   if n==c, % then a column vector
      T=fliplr(T);
      X=fliplr(X);
   else
      T=flipud(T);
      X=flipud(X);
   end
end
warning on
% fini
