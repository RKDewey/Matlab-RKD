function [handle]=pltmap(latr,longr,sp)
% function handle=pltmap(latr,longr,sp)
% function to plot a high resolutoin (GSHHS_H) chart of some coastal region
% defined by latr=[latmin latmax], longr=[longmin longmax], neg for west
% Optional is a subplot vector sp=[2,2,1],
if nargin < 3, sp=[1 1 1]; end
handle=subplot(sp);
m_proj('albers equal-area','lat',latr,'long',longr,'rect','on');
m_gshhs_h('patch',[.6 .6 .6]);
m_grid('linest','none','linewidth',2,'tickdir','out','xaxisloc','top','yaxisloc','right');
m_text(-64.18,46.58,'GSHHS\_H (high)','color','m','fontweight','bold','fontsize',14);
% fini
