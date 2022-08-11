% scipt to generate a figure for 1997 ONR Report
% Load u,v,w,z,time,bsa for julian 198 (July 17, 1997)
% RKD 11/97, modified 4/98

[ur,vr]=vrotate(u,v,13);
figure(1);clf
orient tall
tb=[198.6 198.75];
i=find(time>=tb(1)&time<=tb(2));
pltmc(ur,time,z,[-105 105],tb,[40 120],[4 1 1],'U (Along Channel) July 17, 1997',2,2);
pltmc(vr,time,z,[-30 30],tb,[40 120],[4 1 2],'V (Cross Channel) July 17, 1997',2,2);
pltmc(bsa,time,z,[50 175],tb,[40 120],[4 1 3],'Back-Scatter (dB) July 17, 1997',2,2,'[dB]');
%
h=subplot(4,1,4);sp=get(h,'Position');
fac=0.95*(tb(2)-tb(1)+0.001)/(tb(2)-tb(1));
set(h,'Position',[sp(1) sp(2) sp(3)*fac sp(4)]);
hold on;
iz=[2:5:54];iz=iz(1:7);
for ii=iz, 
   plot(time(i),-w(ii,i)+z(ii),'b',time(i),ones(size(time(i)))*z(ii),'--k');
end;
vsc=z(max(iz))+[-10 -10 10 10];
tsc=tb(2)+[0.001 0 0 0.001];
plot(tsc,vsc,'k','LineWidth',1);
text(tb(2)+0.002,vsc(1),'  10','Fontsize',8);
text(tb(2)+0.003,z(max(iz)),'cm/s','Fontsize',8);
text(tb(2)+0.002,vsc(4),' -10','Fontsize',8);
set(gca,'Ydir','reverse');
ylabel('Depth (m)','Fontsize',10);
xlabel('Time (Julian Day)','Fontsize',10);
h=title('Vertical Velocities (cm/s)','Fontsize',10);
tp=get(h,'Position');
set(h,'Position',[tb(1) 45 0],'HorizontalAlignment','left');
set(gca,'FontSize',8);
axis([tb(1) tb(2)+0.001 45 122]);
pltdat
%