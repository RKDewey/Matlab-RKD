function [xbar,xvar]=online_variance_1D(x)
% function [xbar,xvar]=online_variance_1D(x)
%
% Calculate the nunning mean and variance of data, one new data point at a time.
% Input is simply the next x value
% Output are the running mean and variance
% 
% Global variables of interest: N, xbarN, xvarN
% To re-initialize, empty N >>N=[];
%
% RKD 02/15
global N xbarN xvarN
if isempty(N), N=0; xbarN=0; xvarN=0; end
%
N=N+1;
delta=x-xbarN;
xbarN=xbarN+delta/N;
xvarN=xvarN+delta*(x-xbarN);
%
xbar=xbarN;
if N>1, 
    xvar=xvarN/(N-1);
else
    xvar=NaN;
end
% fini