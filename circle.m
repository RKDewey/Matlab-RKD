function h=circle(xoyo,r);
% function h=circle([xo,yo],r);
% function to draw a circle at origin [xo,yo] with radius r
% returns plot line handle for external modification
% RKD 09/03
r=abs(r); % just make sure radius is positive
t=[0:pi/100:2*pi];
z=r*exp(sqrt(-1)*t);
x=real(z) + xoyo(1);
y=imag(z) + xoyo(2);
h=plot(x,y,'k');
% fini