function [xn,xmin,xmax]=normalize(x);
% function [xn,xmin,xmax]=normalize(x);
% Normalize a vector from 0 to 1
% xn=(x-min(x))/(max(x)-min(x));
% x=xn*(max(x)-min(x)) + min(x)
% RKD 12/01
xmin=min(x);
xmax=max(x);
xn=(x-xmin)/(xmax-xmin);
% fini