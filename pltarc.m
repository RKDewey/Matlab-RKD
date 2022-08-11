function theta=pltarc(xyz0,xyz10,xyz20,p,N)
% function theta=arc(xyz0,xyz1,xyz2,p,N)
% Plot an arc between two vectors defined by end points xyz1 and xyz2
% relative to vertex xyz0, with radius p. All common coordinates [x y z]
% the angle between vectors is passed back as theta (can not = 180 !)
% RKD Jan 1996
xyz1=xyz10-xyz0; % make vector relative to vertex as origin
len1=sqrt(xyz1(1)^2 + xyz1(2)^2 + xyz1(3)^2); % calculate vector length
xyz1=xyz1*p/len1; % make new unit size vector
xyz2=xyz20-xyz0;
len2=sqrt(xyz2(1)^2 + xyz2(2)^2 + xyz2(3)^2);
xyz2=xyz2*p/len2;
xp=xyz1;
zp=[xyz1(2)*xyz2(3)-xyz1(3)*xyz2(2) xyz1(3)*xyz2(1)-xyz1(1)*xyz2(3) ...
    xyz1(1)*xyz2(2)-xyz1(2)*xyz2(1)];
len3=sqrt(zp(1)^2 + zp(2)^2 + zp(3)^2);
zp=zp*p/len3;
yp=[xp(2)*zp(3)-xp(3)*zp(2) xp(3)*zp(1)-xp(1)*zp(3) xp(1)*zp(2)-xp(2)*zp(1)];
len4=sqrt(yp(1)^2 + yp(2)^2 + yp(3)^2);
yp=yp*p/len4;
theta=-acos((xyz1(1)*xyz2(1) + xyz1(2)*xyz2(2) + xyz1(3)*xyz2(3))/(p*p));
if abs(theta) > 1e-5,
  lambda=[xp(1) yp(1) zp(1)];
  mu=[xp(2) yp(2) zp(2)];
  nu=[xp(3) yp(3) zp(3)];
  dt=theta/N;
  x=lambda(1)*cos(0:dt:theta) + lambda(2)*sin(0:dt:theta) + xyz0(1);
  y=mu(1)*cos(0:dt:theta) + mu(2)*sin(0:dt:theta) + xyz0(2);
  z=nu(1)*cos(0:dt:theta) + nu(2)*sin(0:dt:theta) + xyz0(3);
  h=line(x,y,z);set(h,'Color','w');
  h=line([x(1) xyz0(1) x(length(x))],[y(1) xyz0(2) y(length(y))],...
       [z(1) xyz0(3) z(length(z))]);set(h,'Color','w');
end
% fini 




