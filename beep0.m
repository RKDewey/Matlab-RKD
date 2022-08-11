function beep0(f)
% function beep0(f)
% make a 1 second beep at frequency f (default=440Hz)
if nargin < 1, f=440; end
x=10*sin(0:pi/8:f*2*pi);
sound(x,length(x));
%