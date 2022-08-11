function ah=axlonglat(xy,LL);
% function ah=axlonglat(xy,LL);
% To "re-plot" an image axes in Longitude and Latitude
%  given 2 reference points (i.e. lower left and upper right)
%     xy(1,:)=[x1 y1] xy(2,:)=[x2 y2] (pixels)
%     LL(1,:)=[Long1 Lat1] LL(2,:)=[Long2 Lat2] (West/South negative)
% Option: With no inputs, assume plot is Long vs Lat already
%         ah is axis handles
% Example: 
%[chart,cmap]=imread('123.png','PNG');image(chart);colormap(cmap);axlonglat(xy,LL);
% calls ll2xy.m (to convert long,lat to xy pixels)
% also see xy2ll.m to convert x.y pixels to long,lat
%
% RKD 03/02
degc=char(176); % the degree symbol
minc=char(180); % the minute symbol
hold on;
axis manual;
xlim=get(gca,'XLim');
ylim=get(gca,'YLim');
xdir=get(gca,'XDir');
ydir=get(gca,'YDir');
if nargin>0,
    [mmlong,mmlat]=xy2ll(xy,LL,xlim,ylim);
    mmlong=[min(mmlong),max(mmlong)];
    mmlat=[min(mmlat),max(mmlat)];
    dlong=abs(mmlong(2)-mmlong(1));
else
    xy=[];LL=[];
    mmlong=[min(xlim),max(xlim)];
    mmlat=[min(ylim),max(ylim)];
    dlong=abs(max(xlim)-min(xlim));
end

% do the x axis first
if mmlong(1)<0,
   xlabel('Longitude (W)');
else
   xlabel('Longitude (E)');
end
dlongm=0;
longmin=0;
dlongd=0;
longdeg=[0:1:180];
if dlong>30,
    dlongd=10;
    longdeg=[0:10:180];
elseif dlong<=30&dlong>10, % then large, use 5 degree increments
   dlongd=5;
   longdeg=[0:5:180];
elseif dlong<=10&dlong>2, % then large, use 5 degree increments
   dlongd=1;
   longdeg=[0:1:180];
elseif dlong<=2&dlong>1/2, % then use 10 minute
   dlongm=10;
   longmin=[0:10:50];
elseif dlong<=1/2&dlong>1/6, % then use 5 minute
   dlongm=5;
   longmin=[0:5:55];
elseif dlong<=1/6&dlong>1/15, % then use 2 minute
   dlongm=2;
   longmin=[0:2:58];
elseif dlong<=1/15, % then use 1 minute increments
   dlongm=1;
   longmin=[0:1:59];
end
if mmlong(1)<0, longdeg=-longdeg;longmin=-longmin;end;
% now find "clean" end points for Long axis
longmdeg=fix(min(mmlong)); % this is the minimum integer degree
longmmin=fix((min(mmlong)-longmdeg)*60);  % this is the minimum integer minute
if dlongd==0,
   longmd=longmdeg;
else
   longmd=longdeg(min([length(longdeg) find(abs(longdeg)>=abs(longmdeg))]));
end
if dlongm==0,
   longmm=0;
else
   longmm=longmin(min([length(longmin) find(abs(longmin)>=abs(longmmin))]));
end
longt=[(longmd+longmm/60):(dlongd+dlongm/60):max(mmlong)];  % new ticks (decimal degrees)
for xl=1:length(longt),
   if abs((longt(xl)-fix(longt(xl)))*60)<1,
      longlab=[num2str(abs(fix(longt(xl)))),degc];
   else
      longlab=[num2str(abs(fix(longt(xl)))),degc,num2str(abs((longt(xl)-fix(longt(xl)))*60)),minc];
   end
   if xl==1,
      longl=char(longlab);
   else
      longl=char(longl,longlab);
   end
end

% now the y axis
dlat=abs(mmlat(2)-mmlat(1));
if mmlat(1)<0,
   ylabel('Latitude (S)');
else
   ylabel('Latitude (N)');
end
dlatm=0;
latmin=0;
dlatd=0;
latdeg=[0:1:90];
if dlat>30,
    dlatd=10;
    latdeg=[0:10:90];
elseif dlat<=30&dlat>10, % then large, use 5 degree increments
   dlatd=5;
   latdeg=[0:5:90];
elseif dlat<=10&dlat>4, % then large, use 5 degree increments
   dlatd=1;
   latdeg=[0:1:90];
elseif dlat<=4&dlat>1, % then use 10 minute
   dlatm=10;
   latmin=[0:10:50];
elseif dlat<=1&dlat>1/4, % then use 5 minute
   dlatm=5;
   latmin=[0:5:55];
elseif dlat<=1/4&dlat>1/12, % then use 2 minute
   dlatm=2;
   latmin=[0:2:58];
elseif dlat<=1/12, % then use 1 minute increments
   dlatm=1;
   latmin=[0:1:59];
end
if mmlat(1)<0, latdeg=-latdeg;latmin=-latmin;end;
% now find "clean" end points for Long axis
latmdeg=fix(min(mmlat)); % this is the minimum integer degree
latmmin=fix((min(mmlat)-latmdeg)*60);  % this is the minimum integer minute
if dlatd==0,
   latmd=latmdeg;
else
   latmd=latdeg(min([length(latdeg) find(abs(latmdeg)>=abs(latdeg))]));
end
if dlatm==0,
   latmm=0;
else
   latmm=latmin(min([length(latmin) find(abs(latmin)>=abs(latmmin))]));
end
latt=[(latmd+latmm/60):(dlatd+dlatm/60):max(mmlat)];  % new ticks (decimal degrees)
for yl=1:length(latt),
   if abs(((latt(yl))-fix(latt(yl)))*60)<1,
      latlab=[num2str(abs(fix(latt(yl)))),degc];
   else
      latlab=[num2str(abs(fix(latt(yl)))),degc,num2str(abs(((latt(yl))-fix(latt(yl)))*60)),minc];
   end
   if yl==1,
      latl=char(latlab);
   else
      latl=char(latl,latlab);
   end
end
if nargin>0,
    [xt,yt]=ll2xy(xy,LL,longt,latt);
else
    xt=longt;yt=latt;
end
%
if xt(1)>xt(end), xt=fliplr(xt);longl=flipud(longl);end
if yt(1)>yt(end), yt=fliplr(yt);latl=flipud(latl);end
set(gca,'XDir',xdir,'XLim',xlim);
set(gca,'XTickLabelMode','manual','XTick',xt,'XTickLabel',longl);
set(gca,'YDir',ydir,'YLim',ylim);
set(gca,'YTickLabelMode','manual','YTick',yt,'YTickLabel',latl);
% make image have correct proportions in X and Y directions
if ~isempty(xy),
    [long2(1),lat2(1)]=xy2ll(xy,LL,xlim(1),ylim(1));
    [long2(2),lat2(2)]=xy2ll(xy,LL,xlim(2),ylim(2));
else
    long2=xlim;
    lat2=ylim;
end
dy=abs(gcdist(lat2(1),long2(1),lat2(2),long2(1)));
dx=abs(gcdist(lat2(1),long2(1),lat2(1),long2(2)));
if dy > dx, % then make Lat the larger
    set(gca,'PlotBoxAspectRatio',[dx/dy 1 1]);
else % else make the Long the longer
    set(gca,'PlotBoxAspectRatio',[1 dy/dx 1]);
end
%
ah=gca;
% fini