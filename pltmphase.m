function pltmphase(x,y,r,nq);
% function pltmphase(x,y,r,nq);
% Routine to plot a circle representing the moon at a particular phase,
% centred at (x,y) with plot units radius r
% Phases are relative to a new moon (nq=0) and range from full at -0.5 and 0.5
% to 3rd (last) quarter at -0.25 and 1st quarter at 0.25
hold on
[xs,ys,zs]=sphere(359);
xs=xs*r;zs=zs*r;
[xc,yc]=vector(r*ones(size([0:360])),[0:360]*(pi/180),1);
plot(x+xc,y+yc,'k'); % plot the moon (outside line)
nf=abs(nq)*2; % determine the fraction to fill (0-1)
mm=2*29.5306;
if nq<(1/mm) | abs(nq-1.0) < (1/mm), % new moon, all filled
   fill(x+xc,y+yc,'k');
elseif abs(nq-0.25) < (1/mm), % last quarter
   xc1=xs(:,1);yc1=zs(:,1); % fill from left to ...
   nd=180-floor(90); % this fraction of semi-sphere
   xc2=flipud(xs(:,nd));yc2=flipud(zs(:,nd));
   fill(x+[xc1;xc2],y+[yc1;yc2],'k');
elseif abs(nq-0.5) < (1/mm),
   return % full moon, no fill    
elseif abs(nq-0.75) < (1/mm), % first quarter
   xc1=xs(:,180);yc1=zs(:,180); % fill from right to ...
   nd=ceil(90); % this fraction of a semi-sphere
   xc2=flipud(xs(:,nd));yc2=flipud(zs(:,nd));
   fill(x+[xc1;xc2],y+[yc1;yc2],'k');
end
% fini
