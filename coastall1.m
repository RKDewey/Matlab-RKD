function coastall(linetype,filename,axislim,subplt)
%  function coastall(linetype,filename,axislim,subplt)
%  All inputs are optional.
%  Script tool to plot coastline on current plot if there one.
%  Otherwise, it draws with axis limits 
%          axislim=[longwest longeast latsouth latorth]
%  Data comes from a file like 'coastisl.dat' (global med-resolution)
%  with format: segments # -999, followed by # lat long pairs.
%  Routine must read entire file (relatively slow, but memory saving).
%  Assumes longitude axis -180 to 180
%  linetype '-w' default.

%  15 Dec 1993  G.Lagerloef
%  Modified March 1995 R.Dewey
%  again 6/96 to make aspect ratio correct (km in x == km in y)

if nargin<1, linetype='-k'; end % black now k
if nargin<2, filename='coastisl.dat'; end
if nargin<4, subplt=[1 1 1]; end
h=subplot(subplt(1),subplt(2),subplt(3));set(h,'Visible','off');

[fid,msg]=fopen(filename);
if ~isempty(msg), error(msg), end

xlim=get(gca,'XLim');
if xlim == [0 1],  % no figure yet.
   if nargin < 3
      xlim=[-180 180];
      ylim=[-90 90];
   else
      xlim=[axislim(1) axislim(2)];
      ylim=[axislim(3) axislim(4)];
   end
else
   ylim=get(gca,'YLim');
end

xmid=mean(xlim);ymid=mean(ylim);
dlat=abs(ylim(2)-ylim(1));
dlong=abs(xlim(2)-xlim(1));
dsx=gcdist(ymid,xmid,ymid,xmid+1.0)*dlong;
dsy=gcdist(ymid-0.5,xmid,ymid+0.5,xmid)*dlat;
ratio=abs(dsx/dsy);  % this is the ratio of km in long vs lat.
%
h=gcf;
orient=get(h,'PaperOrientation');
yoff=0;
if orient(1:8) == 'portrait',
   set(gcf,'PaperPosition',[0.25 1.5 8 8]);
else  % must be landscape
   set(gcf,'PaperPosition',[0 0 8.5 8.5]);
   if ratio > 11/8.5,
      set(gcf,'PaperPosition',[0 0 11 11]);
      yoff=-2;
   end
end
if dsx > dsy,
 axes('position',[0.1 0.2*ratio+yoff/11 0.8 (0.8/ratio)]);
else
 axes('position',[0.1/ratio 0.2 0.8*ratio 0.8]);
end
set(gca,'Box','on');
xneg=1;
if xlim(1) < 0 & xlim(2) <= 0,
   xlim=abs(xlim);
   axis([xlim(2) xlim(1) ylim(1) ylim(2)]);
   set(gca,'XDir','reverse');
   xneg=-1;
else
   axis([xlim(1) xlim(2) ylim(1) ylim(2)]);
end
%
fbox;  % draw nice box around figure
set(gca,'PlotBoxAspectRatio',[ratio 1 1]);
axis(axis);
hold on;
%
count=1;
while count,
  a=fscanf(fid,'%f',2);
  if isempty(a), fclose(fid); return, end
  b=fscanf(fid,'%f',[2,a(1)]);
  plot(xneg*b(2,:),b(1,:),linetype),
end
fclose(fid);
%
% fini
