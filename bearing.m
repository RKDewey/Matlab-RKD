function angle=bearing(heading,coor)
% function angle=bearing(heading,coor)
% Converts a north bearing (0-360) in degrees, + clockwise
% to an X-Y angle in radians from the X axis in radians, + counter-clockwise
% Optional: coor=0 (default) from compass bearing to trigonometric angle
%           coor=1 from trigonometric angle to compass bearing
% RKD 11/14
if nargin==1, coor=0; end
if coor==0,
   angle=(90-heading)*pi/180;
   if (angle*180/pi)<=-180, angle=angle+2*pi; end
else
   angle=(pi/2-heading)*180/pi;
   if angle<0, angle=angle+360; end
end
% fini