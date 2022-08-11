function [theta,h]=arc(xyz0,xyz10,xyz20,p,a2)
% function [theta,h]=arc(xyz0,xyz1,xyz2,p,a2)
% Plot an 3D arc between two vectors defined by end points 
% xyz1 and xyz2 relative to vertex xyz0, with radius p. 
% All xyz are common coordinates [x y z]
% the angle between vectors is passed back as theta
% and optionally, the plot3(x,y,z) handle h
% Optional Input: a2=1 is chose to other (outside) arc
% RKD Jan 1996, fixed 5/98
if nargin<5, a2=0; end
hold on
xyz1=xyz10-xyz0; % make vector relative to vertex as origin
len1=sqrt(xyz1(1)^2 + xyz1(2)^2 + xyz1(3)^2); % calculate vector length
xyz1=(p/len1)*xyz1; % make new unit size vector
xyz2=xyz20-xyz0;
len2=sqrt(xyz2(1)^2 + xyz2(2)^2 + xyz2(3)^2);
xyz2=(p/len2)*xyz2;
theta=-acos(((xyz1(1)*xyz2(1) + xyz1(2)*xyz2(2) + xyz1(3)*xyz2(3))/(p*p)));

%plot3(xyz1(1),xyz1(2),xyz1(3),'o');
%plot3(xyz2(1),xyz2(2),xyz2(3),'o');
% see CRC page 257
xp=xyz1; % define local x axis
xyz2=xyz2*sqrt(2*pi); % make sure we won't have zero size vectors
zp=[xyz1(2)*xyz2(3)-xyz1(3)*xyz2(2) xyz1(3)*xyz2(1)-xyz1(1)*xyz2(3) ...
    xyz1(1)*xyz2(2)-xyz1(2)*xyz2(1)]; % local z axis perp to both xyz1 and xyz2
yp=[xp(2)*zp(3)-xp(3)*zp(2) xp(3)*zp(1)-xp(1)*zp(3) xp(1)*zp(2)-xp(2)*zp(1)]; % local y axis
zp=zp*(p/sqrt(zp(1)^2 + zp(2)^2 + zp(3)^2)); % now make them all p long
yp=yp*(p/sqrt(yp(1)^2 + yp(2)^2 + yp(3)^2));

lambda=[xp(1) yp(1) zp(1)];
mu=[xp(2) yp(2) zp(2)];
nu=[xp(3) yp(3) zp(3)];
dt=theta/180;
A=[2*pi+theta:dt:theta];
x=lambda(1)*cos(A) + lambda(2)*sin(A) + xyz0(1);
y=mu(1)*cos(A) + mu(2)*sin(A) + xyz0(2);
z=nu(1)*cos(A) + nu(2)*sin(A) + xyz0(3);
if a2==0,
    I=find(A<=0);
else
    I=find(A>=0);
end
h=plot3(x(I),y(I),z(I),'k');
plot3([x(I(1)) xyz0(1)],[y(I(1)) xyz0(2)],[x(I(1)) xyz0(3)],'k');
plot3([x(I(end)) xyz0(1)],[y(I(end)) xyz0(2)],[x(I(end)) xyz0(3)],'k');
theta=abs(theta);
% fini 




