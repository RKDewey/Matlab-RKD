% script to plot Xygen time series and stdev for Pig 1
% must set Time1 and Time2 first
if ~exist('CTD1min'),
    load CTD1min
end
if ~exist('O'),
    O=CTD1min.O;
    Ot=CTD1min.Otime;
end
if ~exist('Od'),
    Od=flt(O,1440+1);
end
i=find(Ot>Time1 & Ot<Time2);
ph=plot(Ot(i),O(i),'b',Ot(i),Od(i),'k');
ylabel('Oxygen [ml/l]');
set(gca,'XLim',[Ot(i(1)) Ot(i(end))],'YColor','b');
set(ph(:),'LineWidth',1.5);
axdate;
j=1440/8 +1;
rstd=flt((abs((O(i)-Od(i)))),j);
rstd=flt(sqrt((O(i)-Od(i)).^2),j);
ph=plotsecond(Ot(i),rstd,2.5,70,[.9 .1 .1],2,'Ox Running STD [ml/l]',1);
set(ph,'LineWidth',1.5);
title('Dissolved Oxygen and Deviations from Running Mean');
