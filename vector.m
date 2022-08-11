function [x,y]=vector(alen,angl,coor)
%  function (x,y)=vector(alen,angl,coor)
%  convert vector coordinates from x,y to magnitude and angle (radians) from x.
%  IF coor = 0, then output (x,y) are magnitude and angle (-pi to pi)
%  IF coor = 1, then output (x,y) are orthogonal x and y components
%  IF coor = 2, then output (x,y) are magnitude and compass heading
%  RKD Sept 1995
if coor == 0
   x=sqrt(alen.*alen + angl.*angl);
   y=atan2(angl,alen);
elseif coor == 1
   x=alen.*cos(angl);
   y=alen.*sin(angl);
elseif coor == 2
   x=sqrt(alen.*alen + angl.*angl);
   y=atan2(angl,alen);
   y=y*180/pi;
   y=90-y;
   for i=1:length(y), if y(i) < 0.0, y(i)=y(i)+360; end; end
end
% end
