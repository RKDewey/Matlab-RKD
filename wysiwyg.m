function wysiwyg
%
%  Function WYSIWYG
%
%  Usage:   WYSIWYG
%
%  This function is called with no args and merely changes the size of the
%  figure on the screen to equal the size of the figure that would be
%  printed, according to the papersize attribute.  Use this function to
%  give a more accurate picture of what will be printed
%

%  Nov 93   Dan(K) Braithwaite, Dept. of Hydrology U. of A. 
%  Apr 94   MDM   typed in from a Matlab Digest

unis = get(gcf,'units');
ppos = get(gcf,'paperposition');
set(gcf,'units',get(gcf,'paperunits'));
pos  = get(gcf,'position');
pos(3:4) = ppos(3:4);
set(gcf,'position',pos);
set(gcf,'units',unis);