function [theta,phi,XYZr]=principal3D(X,Y,Z,parm);
% function [theta,phi,XYZr]=principal3D(X,Y,Z,[dsk plt mag (output)])
% do a principal component analysis on the 3D vectors 
% defined by (x,y,z) triplets. theta is the angle associated with
% the maximum variance axis in the X-Y plane (longitude) and phi is the Latitude from Z.
% Note: theta/phi are in degrees as returned by atan2(Y,X) and acos(Z,R)
% dsk=0 for no despiking =1 for despike 95% var in 10% segments
% plt=0 (default) to NOT plot results, = 1 to plot in Figures 2 and 3
% mag=0 for theta/phi in x/y/z plane, or =1 for Geographic North/East/UP (assume x=U y=V z=W)
% Optional: output=1, then pass back XYZr=[Xr,Yr,Zr];
%
% RKD  05/98, 08/03, 01/08 08/10

if nargin < 4, 
    dsk=0; plt=0; mag=0; op=0;
else
    dsk=parm(1);
    plt=parm(2);
    mag=parm(3);
    op=0;
end
if nargin > 3 & length(parm) > 3 & nargout > 2,
    op=parm(4);
end
% disp('Rotating velocities/vectors to calculate the principal axes.');
% do a little cleaning first to get rid of spikes which screw variances
thrd=95;iseg=[3 30];
if length(X)>(2*iseg(2)) & dsk==1,
    if plt==1; figure(2); clf; end
    for k=1:2,  % despike twice to clean the data first
        if plt==1, subplot(3,1,1); end
        X=despike(X,thrd,iseg,plt);
        if plt==1, subplot(3,1,2);end
        Y=despike(Y,thrd,iseg,plt);
        if plt==1, subplot(3,1,3);end
        Z=despike(Z,thrd,iseg,plt);
    end
    %X=X(iseg:end-iseg);  % don't use ends, where spikes can persist.
    %Y=Y(iseg:end-iseg);
    %Z=Z(iseg:end-iseg);
    if plt==1, drawnow; end
end
if plt==1, figure(3); clf; end
%
th=[0:0.5:179.5];  % rotate vectors through 180 degrees, 0.5 degree increments to find angle with maximum variance
maxvx=-inf;
i=0;
for theta=th,
   i=i+1;
   [Xr,Yr]=vrotate(X,Y,-theta);
   igd=find(~isnan(Xr));
   if ~isempty(Xr(igd)),
     varx=mean(Xr(igd).^2);
     if plt==1, plot(theta,varx,'b.');hold on; end
     if varx > maxvx,
         maxvx=varx;
         imax=i;
     end
   end
end
theta=th(imax);
[Xr,Yr]=vrotate(X,Y,-theta);
maxvz=-inf;
ph=[0:0.5:179.5];
j=0;
for phi=ph,
   j=j+1;
   [Zr,Xrr]=vrotate(Z,Xr,-phi);
   igd=find(~isnan(Zr));
   if ~isempty(Zr(igd)),
     varz=mean(Zr(igd).^2);
     if plt==1, plot(phi,varz,'r.');hold on; end
     if varz>maxvz,
         maxvz=varz;
         jmax=j;
     end
   end
end
%
phi=ph(jmax);
% to convert to true N: dir=90-theta; in=find(dir<0); dir(in)=dir(in)+360;
if mag==1,
    dir=90-theta(1);
    dn=find(dir<0);
    dir(dn)=dir(dn)+360;
    theta(1)=dir;
end
if op==1,
    [Xr0,Yr]=vrotate(X,Y,-theta(1));
    [Zr,Xr]=vrotate(Z,Xr0,90-phi(1));
    XYZr(1,:)=Xr;
    XYZr(2,:)=Yr;
    XYZr(3,:)=Zr;
end
if plt==1, drawnow; end
%

