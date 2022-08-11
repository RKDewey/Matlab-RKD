function errbar(x, y, std)
%ERRBAR Plots graph with uneven error bars.
%	ERRBAR(X,Y,E) plots the graph of vector X vs. vector Y with
%	error bars specified by the vector E(:,2).  The vectors X,Y and E must
%	be the same length.
%	The values in E are the scalars (i.e. 0.8,1.2) that define the
%	lower and upper error limits around each data point.
% 1.0   RKD 4/18/94

tee = (max(x(:))-min(x(:)))/100;  % make tee .02 x-distance for error bars
xl = x - tee;
xr = x + tee;
n = size(y,2);

% Plot graph and bars
cax = newplot;
next = lower(get(cax,'NextPlot'));
% build up nan-separated vector for bars
xb = [];
yb = [];
nnan = nan*ones(1,n);
npt=length(y);
for i = 1:npt
    ytop = y(i)*std(i,2);
    ybot = y(i)*std(i,1);
    xb = [xb; x(i); x(i) ; nnan; xl(i);xr(i);nnan ;xl(i);xr(i);nnan];
    yb = [yb; ytop;ybot;nnan;ytop;ytop;nnan;ybot;ybot;nnan];
end

plot(xb,yb,x,y,'-')
