function [sx,sy,sz]=spheroid(a,b,N,iplt)
% function [sx,sy,sz]=spheroid(a,b,N,iplt)
% function to calculate (plot if iplt~=[]) surface of
% prolate spheroid with major and minor axes a,b
% With N number of points in sx, sy, and sz.
% RKD 2/96
ab2=(a/b)^2;
xi=sqrt(ab2/(ab2-1));
f=a/xi;
theta=(0:2*pi/(N-1):2*pi);
phi=theta;
eta=cos(theta);
x=a*eta;
B=f*sqrt((xi^2-1)*(1-eta.^2));
y=cos(phi);
z=sin(phi);
sx=vadd(zeros(N,N),x)';
sy=vmult(vadd(zeros(N,N),y)',B)';
sz=vmult(vadd(zeros(N,N),z)',B)';
if nargin==4,surf(sx,sy,sz),colormap(jet),axis([-a a -a a -a a]),view(35,35),end;
% fini
