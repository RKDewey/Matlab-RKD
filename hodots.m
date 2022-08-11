function hodots(time,z,u,v,i,h,tim,sig);
% function hodots(time,z,u,v,i,h,tim,sig);
% plot frame i in a hodo time series height h
% RKD 04/07

%
figure(1);clf;
a1=axes('Position',[.1 .8 .8 .15]);
a2=axes('Position',[.1 .1 .8 .65]);
axes(a1);
gc=[0 0.6 0];
h1=plot(time,(u(h-1,:)+u(h,:)+u(h+1,:))/3,time,(v(h-1,:)+v(h,:)+v(h+1,:))/3,tim,sig);
set(h1(1),'Color',gc,'LineWidth',2);set(h1(2),'Color','b','LineWidth',2);set(h1(3),'Color','m','LineWidth',2);
axis tight;axdate(7);hold on
ylim=get(gca,'YLim');
grid on;
plot([time(i) time(i)],[ylim(1) ylim(2)],'r');
title(datestr(time(i)));
ylabel('U(g),V(b),\sigma_t''(m)')
%
set(gcf,'Clipping','off');
axes(a2);
u(1,i)=u(2,i)*0.8;v(1,i)=v(2,i)*0.8;
for j=1:length(z), 
    plot3([0 u(j,i)],[0 v(j,i)],[z(j) z(j)],'b');
    hold on;
end
plot3([0 0],[0 0],[0 z(end)],'k');
plot3([-0.75 -0.75],[0 0],[0 z(end)],'k');
plot3([0 0],[-0.75 -0.75],[0 z(end)],'k');
axis([-.75 .75 -.75 .75 -0.1 z(end)+2]);
up=[0 u(:,i)'];vp=[0 v(:,i)'];p=-0.75*ones(size(vp));zp=[0 z];
h2=plot3(up,p,zp);set(h2,'Color',gc,'LineWidth',1.5);
plot3(p,vp,zp,'b','LineWidth',1.5);
view(120,15);
th(1)=text(1.15,-0.6,0,'S');th(2)=text(1.1,0.6,0,'N');
th(3)=text(1.2,0,0,'[m/s]');
th(4)=text(0.6,1.,0,'E');th(5)=text(-0.5,0.95,0,'W');
th(6)=text(0,0.9,0,'[m/s]');
set(th(:),'FontSize',14);
zlabel('Height [m]');
grid on
drawnow;
% fini
