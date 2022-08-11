function stick(x,y,s)
%  Stick vector plot.
%	STICK(Z) draws a graph that displays the angle and magnitude
%	of the complex elements of Z as arrows emanating from equally
%	spaced points along a horizontal axis.
%
%	STICK(X,Y) is equivalent to STICK(X+i*Y).  It displays the
%	stick plot for the angles and magnitudes of the elements of
%	matrices X and Y.
%
%	STICK(Z,'S') and STICK(X,Y,'S') use line style 'S' where
%	'S' is any legal linetype as described under the PLOT command.
%
%	See also COMPASS, ROSE, and QUIVER.

%	G.Lagerloef  5/21/91

%	Modified from Matlab FEATHER utility, developed by
%	Charles R. Denham, MathWorks 3-20-89
%	Copyright (c) 1989 by the MathWorks, Inc.

%	STICK does not draw arrowheads, and incorporates flexible
%	scaling so that angles are properly represented.

xx = [0 1]';
yy = [0 0].';
arrow = xx + yy.*sqrt(-1);

if nargin == 2
   if isstr(y)
      s = y;
      y = imag(x); x = real(x);
     else
      s = 'r-';
   end
  elseif nargin == 1
   s = 'r-';
   y = imag(x); x = real(x);
end

x = x(:);
y = y(:);
if length(x) ~= length(y)
   error('X and Y must be same length.');
end
[m,n] = size(x);

z = (x + y.*sqrt(-1)).';
mz = 1.5.*max(max(abs(z)));

%   mx ~ m + 2*(m*.3/mz) to allow for vector length on axis scale
mx = m.*(1 + 0.6./mz);

%  rescale x
x=x.*mx.*(.3)./mz;

%  calculate necessary axis length 
z = (x + y.*sqrt(-1)).';
a = arrow * z + ones(2,1)*(1:m);
xmin=min([0 x(1)]);
xmax=max(max(abs(a)));

%  rescale x again
x = x.*(xmax-xmin)./mx;

z = (x + y.*sqrt(-1)).';
a = arrow * z + ones(2,1)*(1:m);
axis([xmin xmax -mz mz]);
plot(real(a), imag(a), s, [xmin xmax], [0 0], 'w-');
axis('normal'), axis;
