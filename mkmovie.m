%function [M]=mkmovie(uv,nframes,vsc,vleg,xbtm,ybtm)
% function [M]=mkmovie(uv,time,nframes,vsc,vleg,xbtm,ybtm)
%   script file to make a current vector movie
%   uv data should be in uv(i,j)
%   time is the time vector
%   vcs sets velocity scale
%   vleg is the size of the vector in the legend (i.e. 50 cm/s)
%   nframes is the number of frames in this movie
%   xbtm,ybtm are the bottom topography arrays
%   RKD 9/95
for i=1:nframes
  axis([-1000 30000 0 22500])
  axis(axis)
  arrow0(8450,15000,uv(i,11)*vsc,0.0,10*vsc,1)
  hold on
  arrow0(8450,10000,uv(i,12)*vsc,0.0,10*vsc,1)
  arrow0(8450,5000,uv(i,13)*vsc,0.0,10*vsc,1)
  arrow0(12675,18000,uv(i,14)*vsc,0.0,10*vsc,1)
  arrow0(12675,15000,uv(i,15)*vsc,0.0,10*vsc,1)
  arrow0(12675,10000,uv(i,16)*vsc,0.0,10*vsc,1)
  arrow0(16160,10000,uv(i,17)*vsc,0.0,10*vsc,1)
  arrow0(20280,18000,uv(i,18)*vsc,0.0,10*vsc,1)
  arrow0(20280,15000,uv(i,19)*vsc,0.0,10*vsc,1)
  arrow0(22390,18000,uv(i,20)*vsc,0.0,10*vsc,1)
  plot(xbtm,ybtm*100,'w');
  text(1000, 22000,'N');
  text(23000,22000,'S');
  arrow0(1000, 4000,vleg*vsc,0.,10*vsc,1);
  text(1000,3000,num2str(vleg));
  text(3000,3000,'cm/s');
  text(1000,1000,num2str(time(i)-110.));
  M(:,i)=getframe;
  clf
end
%