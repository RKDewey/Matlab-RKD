function pltdat(ifmt)
% function pltdat(ifmt)
% Script file to plot the time and date at the lower right corner
% default format ifmt=2 
% if ifmt=0, then Canadian (dd/mm/yy)
% if ifmt=1, then US format (mm/dd/yy)
% if ifmt=2, internatinoal (yy/mm/dd)
% RKD 1/94, additional formats 4/97
clck=clock;
timdat(1:2)=sprintf('%2.0f',clck(4));
timdat(3)=':';
if clck(5) < 10,
   timdat(4)='0';
   timdat(5)=sprintf('%1.0f',clck(5));
else
   timdat(4:5)=sprintf('%2.0f',clck(5));
end
timdat(6)=' ';
clck(1)=clck(1)-(100*floor(clck(1)/100));
% now format date: clck(1)=yy, clck(2)=mm, clck(3)=dd
if nargin < 1, ifmt=2; end
if ifmt == 2, % international format
timdat(7:8)=sprintf('%2.0f',clck(1));  % year
timdat(9)='/';
if clck(2) < 10,
   timdat(10)=sprintf('%1.0f',clck(2));
   timdat(11)='/';
   if clck(3) < 10,
      timdat(12)=sprintf('%1.0f',clck(3));
   else
      timdat(12:13)=sprintf('%2.0f',clck(3));
   end
else
   timdat(10:11)=sprintf('%2.0f',clck(2));
   timdat(12)='/';
   if clck(3) < 10,
      timdat(13)=sprintf('%1.0f',clck(3));
   else
      timdat(13:14)=sprintf('%2.0f',clck(3));
   end
end
elseif ifmt == 1, % US format 
timdat(7:8)=sprintf('%2.0f',clck(2));  % month
timdat(9)='/';
if clck(3) < 10,
   timdat(10)=sprintf('%1.0f',clck(3));  % day
   timdat(11)='/';
   timdat(12:13)=sprintf('%2.0f',clck(1)); % year
else
   timdat(10:11)=sprintf('%2.0f',clck(3)); % day
   timdat(12)='/';
   timdat(13:14)=sprintf('%2.0f',clck(1)); % year
end
elseif ifmt == 0, % Canadian format
timdat(7:8)=sprintf('%2.0f',clck(3));  % day
timdat(9)='/';
if clck(2) < 10,
   timdat(10)=sprintf('%1.0f',clck(2)); % month
   timdat(11)='/';
   timdat(12:13)=sprintf('%2.0f',clck(1)); % year
else
   timdat(10:11)=sprintf('%2.0f',clck(2)); % month
   timdat(12)='/';
   timdat(13:14)=sprintf('%2.0f',clck(1)); % year
end
end
% plot the time/date at the lower right corner, bsed on points.
au=get(gca,'Units');
set(gca,'Units','Points');
axp=get(gca,'Position');
set(gca,'Units',au);
axlh=get(gca,'XLabel');
alu=get(axlh,'Units');
set(axlh,'Units','Points');
axlp=get(axlh,'Position');
set(axlh,'Units',alu);
fsize=6;
xd=axp(3);
yd=axlp(2)-fsize;
%
h=text('String',timdat,'FontSize',fsize,'Position',[xd yd 0],...
   'Units','Points','HorizontalAlignment','Right');
set(h,'Units','Data');
% fini

