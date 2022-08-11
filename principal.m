function [theta xymm]=principal(X,Y,parm)
% function [thetamaxmin XYMM]=principal(X,Y,[plt dsk mag])
% do a principal component analysis on the vectors 
% defined by (x,y) pairs. theta is the angle associated with
% the maximum variance axis (i.e. answer is symetric).
% thetamamx=[thetamax thetamin];
% Optional: Mean/Major/Minor xymm=[xmean,ymean,xmaj,ymaj,xmin,ymin];
% Note: theta is in degrees as returned by atan2(Y,X)
% plt=0 (default) to NOT plot results, = 1 to plot in Figures 1 and 2
% dsk=0 for no despiking =1 for despike 95% var in 10% segments
% mag=0 for theta in x/y plane, or =1 for magnetic North (assume x=U y=V)
%
% RKD  05/98, 08/03, 01/08

if nargin < 3, 
    plt=0; dsk=0; mag=0; wmean=0;
else
    plt=parm(1);
    dsk=parm(2);
    mag=parm(3);
end
% do a little cleaning first to get rid of spikes which screw variances
thrd=95;iseg=[3 30];
if length(X)>(2*iseg(2)) & dsk==1,
    if plt==1; figure(2); clf; end
    for k=1:2,  % despike twice to clean the data first
        subplot(2,1,1);X=despike(X,thrd,iseg,plt);
        subplot(2,1,2);Y=despike(Y,thrd,iseg,plt);
    end
    X=X(iseg:end-iseg);  % don't use ends, where spikes can persist.
    Y=Y(iseg:end-iseg);
end
%
i=0;
m=length(X);
th=[0:360];  % rotate vectors through 360 degrees, 1 degree increments to find angle with maximum variance
for theta=th,
   i=i+1;
   [Xr,Yr]=vrotate(X,Y,-theta);
%   Xr=X.*cos(-theta*pi/180)-Y.*sin(-theta*pi/180);
%   Yr=X.*sin(-theta*pi/180)+Y.*cos(-theta*pi/180);
   x0=Xr((find(~isnan(Xr))));
   if ~isempty(x0),
     varx(i)=mean((x0-mean(x0)).^2); % variance
   else
     varx(i)=-1;
   end
end
%
if plt==1, figure(1); clf; end
imax=find(varx==max(varx));
imax=imax(1);
vmax=varx(imax);
thetamax=th(imax);
imin=find(varx==min(varx));
imin=imin(1);
vmin=varx(imin);
% now determine which quadrature for maximum variance
[Xr,Yr]=vrotate(X,Y,-thetamax);
%   Xr=X.*cos(-thetamax*pi/180)-Y.*sin(-thetamax*pi/180);
%   Yr=X.*sin(-thetamax*pi/180)+Y.*cos(-thetamax*pi/180);
v1=mean(Xr(find(~isnan(Xr))).^3);
[Xr,Yr]=vrotate(X,Y,-(thetamax+180));
%   Xr=X.*cos(-thetamax*pi/180-pi)-Y.*sin(-thetamax*pi/180-pi);
%   Yr=X.*sin(-thetamax*pi/180-pi)+Y.*cos(-thetamax*pi/180-pi);
v2=mean(Xr(find(~isnan(Xr))).^3);
if v1>v2, 
    thetamax=thetamax;
else
    thetamax=thetamax+180;
end
thetamin=thetamax-90;
% now determine which quadrature for minimum variance
[Xr,Yr]=vrotate(X,Y,-thetamin);
%   Xr=X.*cos(-thetamin*pi/180)-Y.*sin(-thetamin*pi/180);
%   Yr=X.*sin(-thetamin*pi/180)+Y.*cos(-thetamin*pi/180);
v1=mean(Xr(find(~isnan(Xr))).^3);
[Xr,Yr]=vrotate(X,Y,-(thetamin+180));
%   Xr=X.*cos(-thetamin*pi/180-pi)-Y.*sin(-thetamin*pi/180-pi);
%   Yr=X.*sin(-thetamin*pi/180-pi)+Y.*cos(-thetamin*pi/180-pi);
v2=mean(Xr(find(~isnan(Xr))).^3);
if v1<v2, 
    thetamin=thetamin;
else
    thetamin=thetamin+180;
end
if thetamax < 0,
    thetamax=thetamax+360;
elseif thetamax > 360,
    thetamax=thetamax-360;
end
if thetamin < 0,
    thetamin=thetamin+360;
elseif thetamin > 360,
    thetamin=thetamin-360;
end
%
[xx,yy]=vector(sqrt(varx),th*(pi/180),1);
[x1,y1]=vector(sqrt(vmax),thetamax*(pi/180),1);
[x2,y2]=vector(sqrt(vmin),thetamin*(pi/180),1);
xm=mean(X);ym=mean(Y);
gr=[0 0.6 0];
if plt==1,
    subplot(2,2,1)
    compass(X,Y,'b');   % plot original vectors
    XL=get(gca,'XLim');YL=get(gca,'YLim');xl=XL(2);yl=YL(2);
    tha=text(0.7*xl,1*yl,['[',num2str(xm,4),',',num2str(ym,4),'] Mean']);set(tha,'Color','k');
    [spdm,dirm]=vector(xm,ym,0);
    dirm=dirm*180/pi;
    if dirm<0, dirm=dirm+360; end
    tha=text(0.7*xl,0.85*yl,['[',num2str(spdm,4),',',num2str(dirm,4),'] Mag/Dir']);set(tha,'Color','k');    
%
	subplot(2,2,2);
    compass(xx,yy,'b'); % plot variance for each angle
	hold on
	h(1)=compass(x1,y1,'r'); % plot in red the vector associated with maximum variance
    XL=get(gca,'XLim');YL=get(gca,'YLim');xl=XL(2);yl=YL(2);
    tha=text(0.7*xl,1*yl,['[',num2str(x1,4),',',num2str(y1,4),'] Major']);set(tha,'Color','r');
	h(2)=compass(x2,y2); % plot in green the vector associated with minimum variance
    set(h(:),'LineWidth',2);set(h(2),'Color',gr);
    tha=text(0.7*xl,0.85*yl,['[',num2str(x2,4),',',num2str(y2,4),'] Minor']);set(tha,'Color',gr);
%
	subplot(2,1,2);
	plot(th,varx,'b',thetamax,vmax,'r+',thetamin,vmin,'g+');
	axis([th(1) th(end) 0 vmax(1)*1.05]);
	xlabel('Theta (degrees)');ylabel('Variance');
    title(['Maximum Variance (PC1 eigenvector): ',num2str(thetamax),'^\circ',...
        '  Minimum Variance (PC2 eigenvector): ',num2str(thetamin),'^\circ']);
	grid;drawnow;
    hold off
%
    figure(3);clf; hold on
    plot(X,Y,'o');
    title('Scatter Plot [x,y])');
    ah=arrow([0,0],[xm,ym]);set(ah,'FaceColor','k');
    t=[0:360]*pi/180;
    xe=sqrt(vmax)*cos(t);
    ye=sqrt(vmin)*sin(t);
    [xer,yer]=vrotate(xe,ye,thetamax);
    plot(xer+xm,yer+ym,'k'); grid on
    ah=arrow([xm,ym],[x1+xm,y1+ym]);set(ah,'FaceColor','r');
    ah=arrow([xm,ym],[x2+xm,y2+ym]);set(ah,'FaceColor','g');
    axis equal
end
theta=[thetamax thetamin];
% to convert to true N: dir=90-theta; in=find(dir<0); dir(in)=dir(in)+360;
if mag==1,
    dir=90-theta;
    dn=find(dir<0);
    dir(dn)=dir(dn)+360;
    theta=dir;
end
xymm=[xm,ym,x1,y1,x2,y2];
%

