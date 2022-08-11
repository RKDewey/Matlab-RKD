function [x,y]=ll2xy(xy,LL,Long,Lat);
% function [x,y]=ll2xy(xy,LL,Long,Lat);
% Convert [Long,Lat] into pixel locations [x,y] for bitmap charts
%  given 2 reference points (i.e. lower left and upper right)
%     xy(1,:)=[x1 y1] xy(2,:)=[x2 y2] (pixels)
%     LL(1,:)=[Long1 Lat1] LL(2,:)=[Long2 Lat2] (West/South negative)
% First convert a chart kap file into a tif image, 
%       then save the image as png (or bmp) format and read with imread
% usage: image(chart)colormap(cmap);axlonglat(xy,LL);
% also see axlonglat and xy2ll
% RKD 03/02
dlong=LL(2,1)-LL(1,1);
dlat=LL(2,2)-LL(1,2);
dx=xy(2,1)-xy(1,1);
dy=xy(2,2)-xy(1,2);
x=xy(1,1)+(Long-LL(1,1))*dx/dlong;
y=xy(1,2)+(Lat-LL(1,2))*dy/dlat;
% fini