function pltdate(ifmt)
% function pltdate(ifmt)
% Using one of datestr's format indices (0-31)
% RLD 11/05
if nargin<1, ifmt=0; end
timdat=datestr(now,ifmt);
text('String',timdat,'FontSize',6,'Position',[0.90 -0.1 0],'Units','Normalized');
%
