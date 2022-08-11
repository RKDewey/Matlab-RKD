% script [M]=mkmovie2(uv,time,nframes,vleg)
%   script file to make a current vector movie looking down
%   uv data should be in uv(i,j) (j=1:10 for u, j=11:20 for v)
%   time is the time vector
%   vleg is the size of the vector in the legend (i.e. 50 cm/s)
%   nframes is the number of frames in this movie
%  tit = title for top of plot
%   RKD 9/95
x0=[0 0 0 0 0];
y0=[225 175 125 75 25];
%
for i=1:nframes
  axis([-125 125 0 275])
  axis(axis)
  arrowc(x0(1),y0(1),uv(i,1),uv(i,11),5,1,'r')
  hold on
  arrowc(x0(1),y0(1),uv(i,2),uv(i,12),5,1,'g')
  arrowc(x0(1),y0(1),uv(i,3),uv(i,13),5,1,'w')
  arrowc(x0(2),y0(2),uv(i,4),uv(i,14),5,1,'y')
  arrowc(x0(2),y0(2),uv(i,5),uv(i,15),5,1,'r')
  arrowc(x0(2),y0(2),uv(i,6),uv(i,16),5,1,'g')
  arrowc(x0(3),y0(3),uv(i,7),uv(i,17),5,1,'g')
  arrowc(x0(4),y0(4),uv(i,8),uv(i,18),5,1,'y')
  arrowc(x0(4),y0(4),uv(i,9),uv(i,19),5,1,'r')
  arrowc(x0(5),y0(5),uv(i,10),uv(i,20),5,1,'y')
  text(0,280,'N');
  text(0,5,'S');
  arrowc(-100,30,vleg,0.,5,1,'w');
  text(-100,20,num2str(vleg));
  text(-75,20,'cm/s');
  text(-100,5,num2str(time(i)-110.));
  title(tit);
  M(:,i)=getframe;
  clf
end
