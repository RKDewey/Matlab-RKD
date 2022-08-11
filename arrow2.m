function h1=arrow2(start,stop,scale,width,colr,fil)

%  (h=)ARROW2(start,stop,scale,width,color,fill)  
%  draw line(s)/area with an arrow pointing from start to stop
%  start are the x,y point where the line starts
%  stop are the x,y point where the line stops
%  Optional parameters:
%  h1 output is the handle of last graphic
%  scale factor to scale the vector units to the axis
%  width is the width of the arrow line in plot units (eg 0.05)
%  color is the color to draw the arrow in (m,3)
%  fill exists then fill arrow 
%  It is assumed that the axis limits are already set and equal
%  RKD 24/10/97

if nargin==2
  xl = get(gca,'xlim');
  yl = get(gca,'ylim');
  xd = xl(2)-xl(1);        % this sets the scale for the arrow size
  yd = yl(2)-yl(1);        % thus enabling the arrow to appear in correct 
  scale = (xd + yd) / 2;   % proportion to the current axis
end

hold on
% axis(axis)
[m,n]=size(start);
if nargin > 4,
   [mc,nc]=size(colr);
   if mc<m, colr=ones(m,1)*colr; end
end

xdif = stop(:,1) - start(:,1);
ydif = stop(:,2) - start(:,2);
leng=sqrt(xdif.^2 + ydif.^2);

theta = atan2(ydif,xdif);  % the angle has to point according to the slope
scale=ones(m,1)*scale;
rat=scale*0.7;

for i=1:m
  if nargin < 4,
   xx = [start(i,1), stop(i,1), (stop(i,1)-scale(i)*cos(theta(i)+pi/6)),NaN,stop(i,1),... 
        (stop(i,1)-scale(i)*cos(theta(i)-pi/6))]';
   yy = [start(i,2), stop(i,2), (stop(i,2)-scale(i)*sin(theta(i)+pi/6)),NaN,stop(i,2),... 
         (stop(i,2)-scale(i)*sin(theta(i)-pi/6))]';
   h1(i,:)=plot(xx,yy);
  else
   w2=width/2;
   x2=start(i,1)-w2*sin(theta(i));
   x3=stop(i,1)-rat(i)*cos(theta(i))-w2*sin(theta(i));
   x4=stop(i,1)-scale(i)*cos(theta(i)-pi/6);
   x5=stop(i,1);
   x6=stop(i,1)-scale(i)*cos(theta(i)+pi/6);
   x7=stop(i,1)-rat(i)*cos(theta(i))+w2*sin(theta(i));
   x8=start(i,1)+w2*sin(theta(i));
   y2=start(i,2)+w2*cos(theta(i));
   y3=stop(i,2)-rat(i)*sin(theta(i))+w2*cos(theta(i));
   y4=stop(i,2)-scale(i)*sin(theta(i)-pi/6);
   y5=stop(i,2);
   y6=stop(i,2)-scale(i)*sin(theta(i)+pi/6);
   y7=stop(i,2)-rat(i)*sin(theta(i))-w2*cos(theta(i));
   y8=start(i,2)-w2*cos(theta(i));
   xx=[start(i,1) x2 x3 x4 x5 x6 x7 x8 start(i,1)];
   yy=[start(i,2) y2 y3 y4 y5 y6 y7 y8 start(i,2)];
   if nargin == 4,
      h1(i,:)=plot(xx,yy,'Color',colr(i,:));
   elseif nargin == 5,
      h1(i,:)=plot(xx,yy,'Color',colr(i,:));   
   elseif nargin == 6,
      h1(i,:)=fill(xx,yy,colr(i,:));   
   end
  end
end % for
hold off
% fini