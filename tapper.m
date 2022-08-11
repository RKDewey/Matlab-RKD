function X=tapper(x,perc);
% function X=tapper(x,perc);
% Cosine tapper the end perc percent of the time series x
% default perc=20%
% RKD 7/02
if nargin<2, perc=20; end
lt=length(x)*perc/100;
da=pi/lt;
a=[0:da:pi];
tapper=(-(cos(a)-1))/2;
X=x;
X(1:length(a))=X(1:length(a)).*tapper;
X((end-length(a)+1):end)=X((end-length(a)+1):end).*fliplr(tapper);
% fini