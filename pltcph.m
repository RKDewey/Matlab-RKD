function pltcph(cph)
% function pltcph(cph)
% plots an addition legend on a loglog spectrum plot
% where cph are the (1/cph) periods to plot 
% i.e. cph=[48 24 12 6 1 1/2 1/3 1/6]
% if the freq axs is in Hz then pass cph*3600
% assumes that a call to loglog has already occured.
% RKD 1/97
YT=get(gca,'YTick');
XL=get(gca,'XLim');
lYT=length(YT);
dY=(YT(lYT)-YT(lYT-1))/4;
fcph=1./(cph);
hold on
for i=1:length(cph)
    if fcph(i) > XL(1) & fcph(i) < XL(2), 
    plot([fcph(i) fcph(i)],[YT(lYT)-dY YT(lYT)-2*dY],'r')
    if cph(i) >= 1,
       h=text(fcph(i),YT(lYT)-2.75*dY,int2str(cph(i)));
    else
       h=text(fcph(i),YT(lYT)-2.75*dY,[':' int2str(60*cph(i))]);
    end
    set(h,'FontSize',8,'HorizontalAlignment','center');
    end
end

% fini