function h=plttides(time,y);
% function h=plttides(time,y);
% Plot a few days of tidal data and mark the peaks
% DOES correction for Day Light Savings: plot(time+dls(time(1))/24,y);
% RKD 05/06
time=time+dls(time(1))/24;
plot(time,y);
hold on;
np=0;
ymm=minmax(y);
tmm=minmax(time);
dy=0.05*(ymm(2)-ymm(1));
for i=2:(length(y)-1),
    if y(i)>y(i-1) & y(i)>y(i+1), % then max
        np=np+1;
        h(np)=text(time(i),y(i)+dy,datestr(time(i),15));
    elseif y(i)<y(i-1) & y(i)<y(i+1), % then min
        np=np+1;
        h(np)=text(time(i),y(i)-dy,datestr(time(i),15));
    end
end
set(h(:),'HorizontalAlignment','center');
set(gca,'YLim',[ymm(1)-dy*1.5 ymm(2)+dy*1.5],'XLim',tmm);
axdate(max([9 ceil(tmm(2)-tmm(1))*4+1]));grid;
drawnow
% fini