function [xc,stats]=runccor(X,Y,dt,iplot);
%    function [xc,stats]=runccor(X,Y,dt,iplot);
%
%    purpose:  Calculates cross correlation between 2 time series
%              for the period from t1 to t2. The number of independent 
%              observations and 95% CL are calculated and displayed on the 
%              plot. Time base is forced to be within range of actual data.
%
%    usage:    [xc,stats]=runccor(X,Y,dt)  or runccor(X,dt) for auto
%    where:    X = 2 col matrix [time;data]' with time (col 1) and data (col 2)
%              Y = 2 (optoinal) col matrix with time (col 1) and data/template (col 2)
%              dt=[t1 t2] = start and end times to correlate 
%                           consistent with time base of X,Y
%               iplot=1 to plot the original time series and correlations
%               (default no plot iplot=0)
%              xc = [tc xc] cross correlation array (2) and time lag 
%                           values (1)
%              stats=[rsig nio tau]
%              rsig = 95% confidence level
%              nio = number of independent observations
%              tau = integral time scale
%
%    Version:  1.0   JT Gunn 4/7/92
%              1.1  cross correlation is returned
%                   plotting is in separate routine
%              1.2  ITS is calculated as intergral to first zero crossover

% First find autocorrelation for each time series. This is used for nio
% calculation. Also calculate a time base for each.

% Assumes that the sample rate is the same for both X and Y (if not, make
% it so)

noy=0; % assume this is a cross correlation between X and Y
if nargin==2,  % then auto-correlation runcorr(X,dt)
   dt=Y;
   noy=1; % then this is an X auto-correlation
   Y=X; % just for now make a copy of X (easier than checking each step)
end
if ~exist('iplot','var'), iplot=0; end
%    Pull out x and y vectors and their time bases
x=X(:,2); % the x times series - data
tx=X(:,1); % the x time stamps
y=Y(:,2); % the y time series - data
ty=Y(:,1); % the y time stamps

% Find the common time base
t1=dt(1);t2=dt(2);
t1=max([min(tx) min(ty) t1]);
t2=min([max(tx) max(ty) t2]);
DT=t2-t1; % duration of the time series in real time units
% truncate to common time range
idx1=min(find(tx>=t1));idx2=max(find(tx<=t2));
x=x(idx1:idx2);tx=tx(idx1:idx2);%    then for y
idy1=min(find(ty>=t1));idy2=max(find(ty<=t2));
y=y(idy1:idy2);ty=ty(idy1:idy2);

% clean up and detrend X 
[xts,xt]=cleanx(x,tx); % cleanx trims and interpolates NaNs
xts=detrend(xts);
X=[xt';xts']';
% clean up and detrend Y
[yts,yt]=cleanx(y,ty);
yts=detrend(yts);
Y=[yt';yts']';
%
if iplot==1,
    figure(1);clf
    plot(xt,xts,'b',yt,yts,'r');axis tight
    title('X (blue) and Y (red)');
    if exist('pltdat.m','file') pltdat; end
end

% Calculate the auto and cross correlations
xcx=xcorr(X(:,2),X(:,2),'coeff');
ycy=xcorr(Y(:,2),Y(:,2),'coeff');
xcy=xcorr(X(:,2),Y(:,2),'coeff');

% calculate the lag times
ntx = (t2-t1).*2;
dtx=ntx./(length(xcx)-1); 
tx=(-ntx/2:dtx:ntx/2)'; % lag times
Tx=length(tx);
ty=tx;Ty=Tx;txy=tx;Txy=Tx; % the lag time bases should all be the same

% save the correlations for returning either x-corr or cross-corr
xc=[tx';xcx']';
if noy==0, xc=[tx';xcy']'; end % if this is a cross-sorrelation, save xcy

% now calcualte some stats for confidence intervals
% find first zero crossover going postive from zero for each auto-correlation
%    crossover is in number of points
% (if not a cross corr (Y=X), then these will be the same)
x0=fix(length(xcx)/2+1);
x1=min(find(xcx(x0:length(xcx))<=0)); % find first zero crossing xcx
y0=fix(length(ycy)/2+1);
y1=min(find(ycy(y0:length(ycy))<=0)); % find first zero crossing ycy
%xy0=fix(length(xcy)/2+1); % old
%xy1=min(find(xcy(xy0:length(xcy))<=0)); % find first zero crossing xcy
xyp=find(xcy==max(xcy)); % index to the peak (max) correlation
xy1=max(find(xcy(1:xyp)<=0)); % find last zero crossing -lag
xy2=min(find(xcy(xyp:end)<=0))+(xyp-1); % find first zero crossing +lag

%store curve to first crossover in temporary array
px=xcx(x0:x0+x1); tpx=tx(x0:x0+x1);
py=ycy(y0:y0+y1); tpy=ty(y0:y0+y1);
%pxy=xcy(xy0:xy0+xy1); tpxy=txy(xy0:xy0+xy1); %old
pxy=xcy(xy1:xy2); tpxy=txy(xy1:xy2); % the entire peak from -lag to +lag
lpxy=length(pxy); % length of the "peak" portion of the correlation

% integrate each auto-correlation from 0 to 1st crossover to get ITS
% NOTE that ITS is in real time units (not unit indices)
xtau=max(cumsum((px(1:length(px)-1)+diff(px)./2).*diff(tpx)));
ytau=max(cumsum((py(1:length(py)-1)+diff(py)./2).*diff(tpy)));
%xytau=max(cumsum((pxy(1:length(pxy)-1)+diff(pxy)./2).*diff(tpxy))); % old
% NEW now integrate over -lag to +lag about peak then divide by 2
xytau=max(cumsum((pxy(1:length(pxy)-1)+diff(pxy)./2).*diff(tpxy)))/2;

% keep the minimum ITS
tau=xtau; % for an autocorrelation
if noy==0, tau=xytau; end; % for cross correlation, use xytau

% calculate number of independent obs (nio) using the duration of the
% time seies and the ITS
nio=DT/tau; 

if iplot==1,
    figure(2);clf;plot(tpx,px,tpy,py,tpxy-tpxy(ceil(lpxy/2)),pxy);
    text(tpx(end),px(end)+0.02,['ITS_x: ',num2str(xtau,3)]);
    text(tpx(end),px(end)+0.06,['NIO_x :',num2str(DT/xtau,4)]);
    % now we need to re-centre the entire peak back to 
    text(tpxy(end)-tpxy(ceil(lpxy/2)),pxy(end)-0.03,['ITS_{xy}: ',num2str(xytau,3)]);
    text(tpxy(end)-tpxy(ceil(lpxy/2)),pxy(end)-0.07,['NIO_{xy}: ',num2str(DT/xytau,4)]);
    grid on;
    title('Auto and Cross-Correlations out to fist Zero Crossing');
    if exist('pltdat.m','file') pltdat; end
end

% calculate confidence interval at 95% significance level
if nio<= 3.0  % must have at least 3 nio for covariance
     rsig=1.0;
else
     r1=exp(2.0*1.96./sqrt(nio-3));  % 1.96 for 95% c.i. 
     rsig=(r1-1.0)./(r1+1.0);   % from Bendat and Piersol 4Ed page 101 equ (4.61)
end
stats=[rsig nio tau];
return
