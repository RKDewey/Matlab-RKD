function tit(titl)
%
% Script file to plot the title at the top center of the page
%
fs=12;
centre=0.5-((length(titl)/2)*(fs/72))/21.5;
top=0.984;
axes('Position',[0 0 1 1],'Visible','off')
text('Fontsize',fs,'String',titl,'Position',[centre top]);
