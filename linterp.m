function [X,Y]=linterp(x,y,dx);
% [X,Y]=linterp(x,y,dx);
% Linear interpolation between original points given in (x,y) to
% a new base [x(1):dx:x(2) x(2)+dx:dx:x(3) ...x(end-1)+dx:dx:x(end)]
% output [X,Y] will have the original end points
% Original x data spacing need not be even, nor monotonic
% RKD 04/03
%     Also see pinterp interpp interps tinterp
N=length(x);
X=x(1);Y=y(1);
for i=1:(N-1),
   ii=i+1;
   p=polyfit([x(i) x(ii)],[y(i) y(ii)],1);
   DX=dx;
   if x(ii)<x(i), DX=-dx; end   % in case the x is not monotonic
   xx=[x(i)+DX:DX:x(ii)];
   yy=polyval(p,xx);
   X=[X xx];Y=[Y yy];
end
X(end)=x(end);Y(end)=y(end);
% fini