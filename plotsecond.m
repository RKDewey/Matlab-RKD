function ph=plotsecond(x,y,offset,perc,col,lr,lab,gridon);
% function ph=plotsecond(x,y,offset,perc,col,lr,lab,gridon);
% Function to plot a second (or more) variable on a single plot, assuming
% SAME range/values for X, different scale/variable/valeus for Y
% Input: Second X and Y
% Output: ph is the plot(x,y) handle
% Optional: Offset the second variable by offset units given in the
%           first/original variable units (default 0)
%        perc is the percentage of full scale the new variable is touse
%           (i.e. 40= 40% of full y axis), default 60
%        col = color in [R G B] (default red = [.7 .1 .1]
%        lr= 1 or 2 for axis ticks on left or right y axes, default 2
%        lab= variable label (i.e. 'Sal')
%        gridon = 1, then grid lines for these tick marks
%
% RKD 07/08
if nargin<3, offset=0; end
if nargin<4, perc=60; end
if nargin<5, col=[.8 .2 .2]; end
if nargin<6, lr=2; end
if nargin<7, lab=' '; end
if nargin<8, gridon=0; end
%
hold on;
xl=get(gca,'XLim');
yl=get(gca,'YLim');
yl(2)=yl(2)*1.1;
ymax=max(y(~isnan(y)));
ymin=min(y(~isnan(y)));
dy=ceil((ymax-ymin)*10)/10;
yy=(perc/100)*(y-ymin)./(ymax-ymin);
yy=yy*(yl(2)-yl(1))+yl(1)+offset;
if max(yy)>yl(2), yl(2)=max(yy); end
if min(yy)<yl(1), yl(1)=min(yy); end
ph(1)=plot(x,yy,'Color',col);
set(gca,'YLim',yl);
set(gca,'XLim',xl);
%
ddy=ceil(dy*10/5)/10;
ys=[floor(ymin*10):ddy*10:ceil(ymax*10)]/10;  % second y axes scale
ysl=strvcat(num2str(ys',4)); % tick labels
yst=((perc/100)*(ys-ymin)./(ymax-ymin))*(yl(2)-yl(1))+yl(1)+offset; % tick positions
for i=1:length(yst),
    if yst(i)>yl(1) & ys(i)>(ymin-ddy/3) & yst(i)<=yl(2) & lr==1,
        plot([-0.01 0]*(xl(2)-xl(1))+xl(1),[yst(i) yst(i)],'Color',col,'Clipping','off');
        text([-0.05]*(xl(2)-xl(1))+xl(1),[yst(i)],ysl(i,:),'Color',col,'Clipping','off');
    end
    if yst(i)>yl(1) & ys(i)>(ymin-ddy/3) & yst(i)<=yl(2) & lr==2,
        plot([0 0.01]*(xl(2)-xl(1))+xl(2),[yst(i) yst(i)],'Color',col,'Clipping','off');
        text([0.02]*(xl(2)-xl(1))+xl(2),[yst(i)],ysl(i,:),'Color',col,'Clipping','off');
    end
    if gridon==1,
        set(gca,'XGrid','on');
        plot([xl(1) xl(2)],[yst(i) yst(i)],':','Color',col);
    end
end
dx=(xl(2)-xl(1))*0.02;
yavg=avg(yy(:)');
if lr==1,
    th=text(xl(1)-dx*3,yavg,lab,'Color',col,'Rotation',90,'HorizontalAlignment','center','VerticalAlignment','bottom');
    ph(2)=plot([xl(1)-dx*2.6 xl(1)],[yavg yavg],'Color',col);
    set(ph(:),'Clipping','off');
else
    text(xl(2)+dx*3.7,yavg,lab,'Color',col,'Rotation',90,'HorizontalAlignment','center','VerticalAlignment','bottom');
    ph(2)=plot([xl(2) xl(2)+dx*2.3],[yavg yavg],'Color',col);
    set(ph(:),'Clipping','off');
end
hold off;
% fini