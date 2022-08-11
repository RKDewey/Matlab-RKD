function [S] = postovel(X)
% Usage: [S] = postovel(X)
% function to expand a time (days), latitude and longitude array to include
% arrays of distance (m), heading (deg T), u (east/west) velocity (cm/s)
% and v (north/south) velocity (cm/s). Input array is expanded to 4 more
% columns to accommadate the new variables.
%
% Since the new arrays are actually first difference calculations the
% first element(row) is set to NaN for each.
raddeg = 180/pi;
degrad = 1/raddeg;

% find the length
[r,c]=size(X);

% calculate distance (m) and heading (deg T)
[d,h] = nvgtn(X(1:r-1,2),X(1:r-1,3),X(2:r,2),X(2:r,3));

% calculate resultant speed (converted to cm/s)
spd = (d ./ (X(2:r,1)-X(1:r-1,1))) .* (100/86400);

% convert to velocity components
u = spd .* sin(h.*degrad);
v = spd .* cos(h.*degrad);

% combine into one array for output
S = [X [NaN [spd]']' [NaN [h]']' [NaN [u]']' [NaN [v]']' ];