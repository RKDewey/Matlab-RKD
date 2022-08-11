function pltmcsh(vl,xa,ya,sh,ncol,mp,np,p,ax,tit)
% function pltmcsh(vl,xa,ya,sh,ncol,mp,np,p,ax,tit) to plot adcp shear data 
%	and color plot with scales xa, ya
%	sh = shear matrix
%	vl = [shmin shmax] values
%	xa = horizontal axis units
%	ya = vertical axis units
%	tit = title (text string)
%	ncol = number of color tones used in color scale (i.e. 25)
%	mp,np,p = number od subplots (m,n,p)
%	1.0 RKD 3/25/94
%h=uvcmap(120);
%colormap(h(1:110,:));
%set(0,'DefaultTextFontSize',10);
%shscle(9,1,9,vl,ncol);
%subplot(mp,np,p);pcolor(xa,ya,sh);shading flat;caxis(vl);axis(ax);
%xlabel('Time (minutes)');ylabel('Depth (m)');set(gca,'FontSize',8);

colormap(jet);
shscl=(1:60);
if vl(1) == 0 & vl(2) == 0
   [smin smax]=minmax(sh);
else
   smin=vl(1);
   smax=vl(2);
end
shsc=((sh-smin)./(smax-smin))*60;
subplot(mp,np,p);image(xa,ya,shsc);set(gca,'YDir','normal');
axis(ax);title(tit);
xlabel('Time (minutes)');ylabel('Depth (m)');set(gca,'FontSize',8);
subplot(15,1.5,22.26);image([smin smax],[0 1],shscl);
set(gca,'YTickLabels',[]);
