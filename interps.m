function [Xi,ti]=interps(X,t,dt)
% [Xi,ti]=interps(X,t,dt)
% interpolates data in array X(t) with spacing defined by t to new 
% array with spacing dt. First new data value at point dt.
% arrays must be at least 3 elements long, with no NaNs
% RKD 5/9/94
%     ALSO SEE pinterp.m, interpt.m and interpp.m
n=length(X);
if n < 3, return, end
ti=[t(1)+dt/2:dt:t(end)-dt/2];
Xi=spline(t,X,ti);
%
