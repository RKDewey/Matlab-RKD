function velscle(nr,nc,plt,scle,ncol);
%    function VELSCLE - to plot velocity scale on bottom of plot
%    usage: velscle(nr,nc,plt,scle,ncol)
%    where:    nr=number of plots down
%              nc=number of plots across
%              plt=plot to put scale in
%              scle=velocity limits (eg [-40 40])
%              ncol= number of colors in spectrum
%    version 1.0 JTG - 18 Jan 1994
%             1.1 rkd - 16 Mar 1994 increase number of colors

low=scle(1);
high=scle(2);
cinc=(high-low)/ncol;
%c=[low:high;low:high];
subplot(nr,nc,plt);
pcolor(low:cinc:high,1:2,[low:cinc:high; low:cinc:high]);
shading flat;caxis([low high]);
axis([low high 1 2]);
set(gca,'YTickLabels',[]);
xlabel('Shear^2 - s^-2');set(gca,'FontSize',10);
