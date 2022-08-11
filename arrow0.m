function h=arrow0(x0,y0,alen,angl,ahl,coor)
% function handles=arrow0(x0,y0,alen,angl,ahead,coor)
% Function to draw a simple arrow/vector with length ALEN
%  and angle ANGL with arrowhead length ahead IF coor is = 0, 
%  otherwise IF coor=1 assume alen and angl are the x and y coordinates 
%  of the vector to be added to x0 and y0. Convert x and y to alen and 
%  angl using routine vector.m or angle(z)
%  RKD Sept 1995
%
if coor == 1
   [x,y]=vector(alen,angl,0); 
   alen=x;
   angl=y;
end
ara=0.27;
%if alen < (ahl*2) & coor == 0, 
%   ahl=alen*0.5; 
%end
x2=x0+alen*cos(angl);
y2=y0+alen*sin(angl);
thet=atan2((x2-x0),(y2-y0));
tha=thet-ara;
x3=x2-(ahl*sin(tha));
y3=y2-(ahl*cos(tha));
h(1)=line([x0 x2],[y0 y2]);
h(2)=line([x2 x3],[y2 y3]);
tha=tha+(2*ara);
x3=x2-(ahl*sin(tha));
y3=y2-(ahl*cos(tha));
h(3)=line([x2 x3],[y2 y3]);
%end
