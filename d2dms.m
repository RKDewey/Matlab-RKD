function [d,m,s]=d2dms(dd);
% function [d,m,s]=d2dms(dd);
% function to convert decimal degrees to either:
%   [d,m] into degrees, decimal minutes
% or
%   [d,m,s] into degrees, minutes, and decimal seconds
% RKD 09.07
d=fix(dd);
dm=(dd-d)*60;
m=dm;
if nargout==3,
    m=fix(dm);
    s=(dm-m)*60;
end
% fini
