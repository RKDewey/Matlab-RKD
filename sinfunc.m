function f = sinfunc(a,y,t,w)
% function f = sinfuc(a,y,t,w)
% function to approximate a seasonal variation as
% y(t) = a(1) + a(2)*sin(wt+a(3))
% f = sum((y(t)-(a(1)+a(2)*sin(wt+a(3)))^2)
% to be called by fmins to find least squares fit for estimate of a(1-3) 
% y is vector of n y values
% a is vector of sought coefficients
% t is vector of times
% w is scalar omega, the natural frequency associated with the period 2pi/T 
% 1.0 RKD 11/94
n=length(y);
sum=0;
for i=1:n
    sum = sum + (y(i) - (a(1) + a(2)*sin(w*t(i) + a(3))))^2;
end
f = sum;
