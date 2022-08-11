function [Long,Lat]=xy2LL(xy,LL,x,y);
% function [Long,Lat]=xy2LL(xy,LL,x,y);
% Convert [x,y] pixel locations into [Long,Lat] for bitmap charts
%  given 2 reference points (i.e. lower left and upper right)
%     xy(1,:)=[x1 y1] xy(2,:)=[x2 y2] (pixels)
%     LL(1,:)=[Long1 Lat1] LL(2,:)=[Long2 Lat2] (West/South negative)
% First convert a chart kap file into a tif image, 
%       then save the image as png (or bmp) format and read with imread.
%       Then reference two points LL=Long/Lat using ginput, save as xy.
% RKD 03/02
dlong=LL(2,1)-LL(1,1);
dlat=LL(2,2)-LL(1,2);
dx=xy(2,1)-xy(1,1);
dy=xy(2,2)-xy(1,2);
Long=LL(1,1)+(x-xy(1,1))*dlong/dx;
Lat=LL(1,2)+(y-xy(1,2))*dlat/dy;
% fini