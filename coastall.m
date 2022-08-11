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
%  Make page orientation call first, otherwise aspectratio will be wrong

%  15 Dec 1993  G.Lagerloef
%  Modified March 1995 R.Dewey
%  again 6/96 to make aspect ratio correct (km in x == km in y)

if nargin<1, linetype='-k'; end % black now k
if nargin<2, filename='coastisl.dat'; end
if nargin==4,
   subplot(subplt(1),subplt(2),subplt(3));
end
set(gca,'Visible','off');
ap=get(gca,'Position');
axes('Position',[ap(1)*1.1 ap(2) ap(3) ap(4)]); % must make this call!!!

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
yoff=0;

set(gca,'Box','on');
xneg=1;
if xlim(1) < 0 & xlim(2) <= 0,
   xlim=abs(xlim);
   axis([xlim(2) xlim(1) ylim(1) ylim(2)]);
   set(gca,'XDir','reverse');
   xneg=-1;
   xylim=[xlim(2) xlim(1) ylim(1) ylim(2)];
else
   axis([xlim(1) xlim(2) ylim(1) ylim(2)]);
   xylim=[xlim(1) xlim(2) ylim(1) ylim(2)];
end
%
if ratio >= 1 % either way, make aspectratiomode manual
   set(gca,'PlotBoxAspectRatio',[1 1/ratio 1]);
else
   set(gca,'PlotBoxAspectRatio',[ratio 1 1]);
end
%
fbox;  % draw nice box around figure using Rich P's M_Map routines
%
axis(axis);
%
hold on;
% Now restrict plot domain by patch thickness
tkln=get(gca,'TickLength');
dy=tkln(1)*abs(xylim(3)-xylim(4));
dx=tkln(1)*abs(xylim(1)-xylim(2));
% Use the following line if fbox is NOT used above
%xylim=[xylim(1) xylim(2) xylim(3) xylim(4)];
% Otherwise use the following coast line domain limits
xylim=[xylim(1)+dx xylim(2)-dx xylim(3)+dy xylim(4)-dy];
%
count=1;
while count,
  a=fscanf(fid,'%f',2);
  if isempty(a), fclose(fid); return, end
  b=fscanf(fid,'%f',[2,a(1)]);
  if xneg == 1,  % find coastline within plot doamin
     idx=find(b(2,:)>=xylim(1) & b(2,:)<=xylim(2)&...
              b(1,:)>=xylim(3) & b(1,:)<=xylim(4));
   else
     idx=find(abs(b(2,:))>=xylim(1) & abs(b(2,:))<=xylim(2)&...
              b(1,:)>=xylim(3) & b(1,:)<=xylim(4));
   end
   if ~isempty(idx),     
      xl=b(2,idx);yl=b(1,idx); % these are the coastline elements within plot domain
      idi=[0 find(diff(idx)>1) length(idx)];
      for i=1:length(idi)-1,
         id=[idi(i)+1:idi(i+1)];
         plot(xneg*xl(id),yl(id),linetype),
      end
   end
end
fclose(fid);
%
% fini
