function curverad(x,y,rad,angle,arrow,ext,lt)

% function curverad(x,y,rad,angle,arrow,ext,lt)
%       eg curverad(1,2,5,  [0 90],1)
%
% plots arc, starting at (x,y) of radius rad between angle(1) and angle(2)
%       optional call to pltarrow.m to plot arrow at end of arc segment
%
% parameters
%       x                         - x value for   start of arc segment
%       y                         - y value for   start of arc segment
%	rad                       - radius of curvature of arc segment
%       angle [angle(1) angle(2)] - begin and end angles (degrees) of arc
%                                       (0: North, 90: East)
% optional parameter
%       arrow [0 or 1] - 0: no arrow, 1: plot arrow          default = 0
%       ext   [number] - length of extension (none if 0)     default = 0
%       lt = line thickness (default 1)
%
% Michael Ott
% 09 Oct 1996

if nargin < 7
	lt = 1;
end
if nargin < 6
	ext = 0;
end
if nargin < 5
	arrow = 0;
end

ang = linspace(angle(1),angle(2),1000) * pi/180;

X = x - rad*sin(ang(1)) + rad*sin(ang);
Y = y - rad*cos(ang(1)) + rad*cos(ang);

if ext == 0
	X2 = [X(900) X(1000)];
	Y2 = [Y(900) Y(1000)];
else
	X = [X X(1000)+ext*cos(ang(1000))];
	Y = [Y Y(1000)+ext*sin(ang(1000))];
	X2 = [X(1000) X(1001)];
	Y2 = [Y(1000) Y(1001)];
end

plot(X,Y,'LineWidth',lt)
if arrow == 1
	h=pltarrow(X2,Y2,20,0.3);
    set(h(:),'LineWidth',lt);
end
