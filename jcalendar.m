function jcalendar(year)
% function jcalendar(year)
% make a Julian day Calendar for year=year
% load calendarxy.mat
% RKD 4/98

load calendarxy
orient tall
j=0;
clf;
for j=1:12,
   subplot1(4,3,j,.1,.1,.3,.4);
   plot(x,y,'k');axis off;
   for i=1:7,
       h=text(xd(i),yd(i),day(i));set(h,'HorizontalAlignment','center');
   end
   title(month(j,:));
end
 
% fini

