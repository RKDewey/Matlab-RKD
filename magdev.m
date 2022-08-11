function md=magdev(mtime);
% function md=magdev(mtime);
% 
% Returns the magnetic deviation in degrees relative to North for Si & SoG
% appropriate for the MATLAB datenum mtime.
%
% RKD 10/07
md = 19 - (9/60)*(mtime - 731398)/365;
% fini