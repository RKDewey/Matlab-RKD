function earth(ilong,az,el)
%EARTHTOP View Earth's topography in 3D only
% earth(ilong,az,el) where az=rotation (long) and el is elavation (lat)
%	and ilong is the number of grids in 180 degrees (i.e. 24)
%	Copyright (c) 1984-94 by The MathWorks, Inc.
% RKD 8/18/94
if nargin < 1,
   ilong=36;
   az=167;
   el=66;
end
echo off
disp('The topography data used in this demo is available from')
disp('the National Geophysical Data Center, NOAA,')
disp('US Department of Commerce under data announcement 88-MGG-02.')
load topo
% clf reset
colormap(topomap1);
[x,y,z] = sphere(ilong);
cla,axis auto, ...
surface(x,y,z,'FaceColor','texture','Cdata',topo), ...
axis square,axis xy,axis off, view(az,el),axis vis3d, rotate3d on
% fini
