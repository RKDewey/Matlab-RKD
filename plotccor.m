function plotccor(xc,stats,ttext,iauto,zoomfct,ts,DT)
% function plotccor(xc,stats,ttext,iauto,zoomfct,timescale,DT)
%
%       purpose:        Produce plot of cross correlation between two
%                       time series. Requires runccor output xc and stats
%       usage: plotccor(xc,stats,ttext,iauto)
%       where: xc = [tc xc] cross correlation from runccor (2 col)
%              stats=[rsig nio tau]
%                    rsig = confidence level
%                    nio = number of independent observations
%                    tau = integral time scale
%              text = plot title
%           optional:
%              iauto = 1 for one-sided auto-correlation plots
%                       (default = 0, two sided cross correlation)
%              zoomfct: zoom(zoomfct) to zoom in (i.e. 2)
%              timescale: assume time in seconds, or set timescale factor 
%                       to convert day time units to seconds (24*60*60)
%                       to convert hours to seconds (60*60)
%              DT is the time series start and end times [t1 t2]
%       Version 1.0     JT Gunn 4/13/92
%       Version 2.0     RK Dewey 2/5/96
%       Version 3.0     RKD 12/8/21 (along with updated runccor)
% Note: +lags mean y leeds (peaks before) x, -lags y trails (peaks after) x.
%       Always shift x to align peaks, either + to left or - to right.

% plot up results in figure(3) [runccor generates figures 1 & 2]
figure(3);clf
% set optional input parameters
if nargin < 4, iauto=0; end
if nargin < 5, zoomfct=1; end
if nargin < 6, ts=1; end
if nargin < 7, DT=[0 xc(end,1)]; end
% pull out correlation and lag vectors, and stats
txc=xc(:,1);
xc=xc(:,2);
t1=txc(1);t2=txc(end);
rsig=stats(1);nio=stats(2);tau=stats(3);

% set up axis
axis([min(txc) max(txc) -1.0 1.0]);
plot(txc,xc); grid; 
if iauto==1,
    ylabel('Autocorrelation');
else
    ylabel('Cross Correlation');
end
if ts==(24*60*60),
    xlabel('Time Lag (days)');
elseif ts==(60*60),
    xlabel('Time Lag (hours)');
else
    xlabel('Time Lag (seconds)');
end
title(ttext);
if iauto==1,
    XLim=get(gca,'XLim');
    set(gca,'XLim',[0 XLim(2)]);
end
hold on
% plot confidence intervals based on integral time scale (tau)
dt=mean(diff(txc));
n2=(length(xc)-1)/2; % mid-point
rnio=[0:dt:(dt*n2) (n2*dt-dt):-dt:0];
rnio=rnio/tau; % now the NIO is a vector, symetrical about zero lag
irsig=find(rnio>3.005); % for correlations, there must be at least 3 observations
rsig=ones(size(rnio)); % set up empty c.i. vector
r1=(exp(2./sqrt(rnio(irsig)-3.0))).^1.96; % from Bendat and Piersol (4.61 or 4.65)
rsig(irsig)=(r1-1.0)./(r1+1.0); % invert B&P equation 4.61
plot(txc,rsig,'--b',txc,-rsig,'--b') % pot the upper and lower c.i.
axis tight; 
zoom(zoomfct);
a=axis;
grid on
% print info in corner of plot
maxx = max(xc);
maxpos = find(xc==max(xc));
maxtim = txc(maxpos);
minx = min(xc);
minpos = find(xc==min(xc));
mintim = txc(minpos);
%
dx=(a(2)-a(1))/50.;
dy=(a(4)-a(3))/40.;
% find where to plot the 95% c.i. label
XTick=get(gca,'Xtick');
ici=min(find(txc(:,1)>XTick(1)));
xci=txc(ici)+dx/2;yci=rsig(ici)+dy/2;
text(xci,yci,'95% c.i.');
% plot the findings
if ts==(60*60),
    text(a(1)+dx,a(3)+5*dy,['Max: ',num2str(maxx(1),3),' at ',num2str(maxtim(1)/ts,3),' hr']);
    text(a(1)+dx,a(3)+4*dy,['Min: ',num2str(minx(1),3),' at ',num2str(mintim(1)/ts,3),' hr']);
else
    text(a(1)+dx,a(3)+5*dy,['Max: ',num2str(maxx(1),3),' at ',num2str(maxtim(1)*ts,3),' s']);
    text(a(1)+dx,a(3)+4*dy,['Min: ',num2str(minx(1),3),' at ',num2str(mintim(1)*ts,3),' s']);
end
if ts==(24*3600),
    text(a(1)+dx,a(3)+3*dy,['Start: ',datestr(DT(1)),' End: ',datestr(DT(2))]);
elseif ts==(60*60),
    text(a(1)+dx,a(3)+3*dy,['Start: ',num2str(DT(1)/ts,3),' End: ',num2str(DT(2)/ts,3)]);
else
    text(a(1)+dx,a(3)+3*dy,['Start: ',num2str(DT(1),3),' End: ',num2str(DT(2),3)]);
end
text(a(1)+dx,a(3)+2*dy,['NIO: ',num2str(nio,4)]);
if ts==(24*3600),
    text(a(1)+dx,a(3)+dy,['ITS = ',num2str(tau,3),' days']);
elseif ts==(60*60),
    text(a(1)+dx,a(3)+dy,['ITS = ',num2str(tau/ts,3),' hr']);
else
    text(a(1)+dx,a(3)+dy,['ITS = ',num2str(tau,3),' s']);
end
if exist('pltdat.m','file'), pltdat; end % plot today's time/date on the plot
% fini