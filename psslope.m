function [fl,line,ph]=psslope(rise,run,xst,yst)
% function [f,line,ph]=psslope(rise,run,xst,yst)
% plots a unit line of given slope (=rise/run) 
% on an exisitng loglog (power spectrum) plot.
% Optional xst=x-start tick # and yst=y-start tick #
% Defaults are lower left corner (2,2).
% Routine does not plot slopes on semilog or linear plots.
% Please enter rise and run as integers if possible.
% RKD 10/96
hold on
slope=rise/run;
if nargin < 3, xst=2; yst=2; end
if xst <= 1, xst=2; end
if yst <= 1, yst=2; end
if slope == 0, disp('Zero slopes not plotted'); return; end
st=[num2str(rise),'/',num2str(run)];
if rem(rise,run) == 0, st=num2str(slope); end
YScale=get(gca,'YScale');
XScale=get(gca,'XScale');
if length(YScale) == 3, % YScale = 'log'
   YTick=get(gca,'YTick');
else
   disp('Must be loglog plot for this slope routine.');
   return;
end
if length(XScale) == 3, % XScale = 'log'
   XTick=get(gca,'XTick');
else
   disp('Must be loglog plot for this slope routine.');
   return;
end
dy=YTick(yst)-YTick(yst-1);
dx=XTick(xst)-XTick(xst-1);
dydx=1; % loglog plots in MATLAB always use decades as tickmarks 
pos=get(gca,'Position');
if pos(3) < 0.5 | pos(4) < 0.5, % then this is a subplot, shrink fonts.
   fs=((min([pos(3) pos(4)]))^(0.2))*12;
else
   fs=10;
end
fr=log10(XTick(xst-1));
pr=log10(YTick(yst));
if slope > 0, % then line is goes up, start at origin
   if slope >= dydx, % then use dy as rise
      fl=[10^(fr) 10^(fr+1/slope)];
      line=[10^(pr-1) 10^pr];
      tsp=4;
      if slope == 1, tsp = 2; end
      th=text((XTick(xst-1)+dx/(tsp*slope/dydx)),(YTick(yst-1)+dy/4),st);
   else  % use dx as run
      fl=[10^(fr) 10^(fr+1)];
      line=[10^(pr-slope) 10^pr];
      th=text((XTick(xst-1)+dx/2),(YTick(yst-1)+dy*(slope/dydx)/3),st);
   end
else  % slope is down, start at YTick(2)
   if abs(slope) >= dydx, % then use dy as rise
      fl=[10^(fr) 10^(fr-1/slope)];
      line=[10^pr 10^(pr-1)];
      th=text((XTick(xst-1)+dx/(6*abs(slope/dydx))),(YTick(yst-1)+dy/2),st);
   else  % use dx as run
      fl=[10^(fr) 10^(fr+1.0)];
      line=[10^pr 10^(pr+slope)];
      th=text((XTick(xst-1)+dx/8),(YTick(yst-1)+dy/(6*abs(slope/dydx))),st);
   end
end
set(th,'Fontsize',fs);
%
ph(1)=loglog(fl,line,'k');
ph(2)=th;
% fini
