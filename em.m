function em(x,N)
% functoin em(x,N)
% plot the multi-Gaussian distribution for data x, with N peaks
% Uses peakfit
% RKD 05/12
x=x(:);
M=length(x);
K=ceil(M/100)*10;
[y,b]=hist(x,K);clf
xy=[b' y'];
db=ceil(max(b)-min(b));
peakfit(xy,mean(b),db,N);
%