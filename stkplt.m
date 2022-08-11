function sf=stkplt(x,y,u,v,limits,sf)
% 
% function stkplt
%    purpose:  plot vectors over a x,y grid
%    usage:    sf=stkplt(x,y,u,v,limits,sf)
%    where:    x,y = positions of vectors u,v
%              limits = limits of axes
%              sf = 2-element scale factor to relate vector magnitude to
%                    x,y scales (allows setting same scale plot to plot).
%
%    written for MATLAB version 4.0

%    Version 1.0 created 2/14/94 JT Gunn
%    Version 1.1 scales plots by 'paperposition' object property.

% compute scaling parameters for map
if nargin==5
     mag=max(sqrt(u.^2+v.^2));
     dx=limits(2)-limits(1);
     dy=limits(4)-limits(3);
     pp=get(gcf,'paperposition');
     pp(4)=5.68; pp(3)=3.32;     
     ratio=(pp(4)./pp(3)).*1.05;   % ratio of y to x axis (empirical)
     sfx=(dx./(10))./mag;
     sfy=(dy./(10.*ratio))./mag;
     sf=[sfx sfy];
elseif nargin ~= 6
     help stkplt
     error('Incorrect number of input values - 5 required')
end

axis(limits);
npts=length(u);
plot(x(1),y(1)); hold on;

for k=1:npts
     plot(x(k),y(k),'.r'); 
     plot([x(k) x(k)+u(k).*sf(1)],[y(k) y(k)+v(k).*sf(2)],'-g')
end

% put a velocity scale arrow in lower right side of plot
%    force to be a multiple of ten

mspd=mean(sqrt(u.^2+v.^2));
vscle=ceil(mspd./10).*10;
xscle=limits(1) + .2.*dx;
yscle=limits(3) + .1.*dy;
plot(xscle,yscle,'.r');
plot([xscle xscle + vscle.*sf(1)], [yscle yscle],'-g');
capt=[num2str(vscle) ' cm/s'];
text(xscle,yscle+0.05.*dy,capt);
hold off