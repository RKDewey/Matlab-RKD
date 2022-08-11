function h=ellipse(xoyo,a,b,plt);
% function h=ellipse([xo,yo],a,b,plt);
% function to draw an ellipse at origin [xo,yo]
% with x dimension a and y dimension b
% if plt=1 (default), plot and return handles, if 0 just return values h=[xd;yd]; 
% RKD 09/03
if nargin<4, plt=1; end
a=abs(a);b=abs(b); % just make sure a and b are positive
t=[0:pi/100:2*pi];
x=a*cos(t) + xoyo(1);
y=b*sin(t) + xoyo(2);
if plt==0,
    h=[x;y];
else
    h=plot(x,y,'k');
end
% fini