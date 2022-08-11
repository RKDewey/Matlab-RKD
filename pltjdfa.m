% script file to plot a page of shipboard ADCP data
%
vscl=[-125 125];
dp=[0 200];
%
sym=['o' 'd' 's' '<' '>' '^' 'v' 'x' '*'];
xs=[fix(tima(1)):0.05:fix(tima(1)+1)];
it=find(xs >=min(tima)&xs<=max(tima));
xs=xs(it);
% xs=[199.5:0.05:199.7];
ys=zeros(size(xs));
%
clf
orient tall;
jdfcoast1([3 2 1]);
plot(longa,lata,'r');
for i=1:length(xs), 
   j=max(find(tima<xs(i)));
   plot(longa(j),lata(j),sym(i),'markersize',4); 
end
%
subplot(6,2,2);
plot(tima,ua(12,:));
axis([min(tima) max(tima) vscl(1) vscl(2)]);grid;
text(min(tima),(vscl(2)-(vscl(2)-vscl(1))/8),' U')
set(gca,'fontsize',6)
title('Velocity at 50 m','fontsize',8);
%
subplot(6,2,4);
plot(tima,va(12,:));
axis([min(tima) max(tima) vscl(1) vscl(2)]);grid;
text(min(tima),(vscl(2)-(vscl(2)-vscl(1))/8),' V')
set(gca,'fontsize',6)
%
pltmcuv(ua,z,tima,vscl,dp,3,1,2,'Shipboard U',4,1);hold on
for i=1:length(xs), plot(xs(i),ys(i),sym(i),'markersize',6); end
%
pltmcuv(va,z,tima,vscl,dp,3,1,3,'Shipboard V',4,1);

% fini

