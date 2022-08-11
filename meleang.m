% script to plot a mooring element with angles
clear all
r1=[0 0.65];
r2=[0 0.75];
phi=[50*pi/180 30*pi/180];
theta=[50*pi/180 30*pi/180];
%
clf
a=0.5;
plot3([0 a NaN 0 0 NaN 0 0],[0 0 NaN 0 a NaN 0 0],[0 0 NaN 0 0 NaN 0 a],'k');
arrow([0 0 0],[0 0 a],'NormalDir',[1 0 1],'Length',18);
arrow([0 0 0],[0 a 0],'NormalDir',[1 0 1],'Length',12);
arrow([0 0 0],[a 0 0],'NormalDir',[1 1 0],'Length',18);
text(0,0,a*1.1,'Z');
text(-0.2*a,a,0,'Y');
text(a*1.1,0,0,'X');
hold on
x1=r1*cos(theta(1))*sin(phi(1));
y1=r1*sin(theta(1))*sin(phi(1));
z1=r1*cos(phi(1));
h=plot3(x1,y1,z1,'Linewidth',4);
plot3(x1,y1,[0 0],':k');
plot3([x1(2) x1(2)],[y1(2) y1(2)],[0 z1(2)],':k');
view(60,30);
set(gca,'Visible','off')
arc([0 0 0],[0 0 a],[x1(2) y1(2) z1(2)],a/2);
text(a/7,a/7,a/1.75,'\psi_{i+1}');
arc([0 0 0],[a 0 0],[x1(2) y1(2) 0],a/2);
text(a/1.8,a/4,0,'\theta_{i+1}');
arrow([0 0 0],-[x1(2)/4 y1(2)/4 z1(2)/4]);
text(-x1(2)/4,-y1(2)/4,-(z1(2)/4+a/6),'T_{i+1}');
%
x2=r2*cos(theta(2))*sin(phi(2));
y2=r2*sin(theta(2))*sin(phi(2));
z2=r2*cos(phi(2));
plot3([0 a NaN 0 0 NaN 0 0]+x1(2),[0 0 NaN 0 a NaN 0 0]+y1(2),[0 0 NaN 0 0 NaN 0 a]+z1(2),'k');
arrow([x1(2) y1(2) z1(2)],[x1(2) y1(2) z1(2)+a],'NormalDir',[1 0 1],'Length',10);
arrow([x1(2) y1(2) z1(2)],[x1(2) y1(2)+a z1(2)],'NormalDir',[1 0 1],'Length',10);
arrow([x1(2) y1(2) z1(2)],[x1(2)+a y1(2) z1(2)],'NormalDir',[1 1 0],'Length',10);
h=plot3(x2+x1(2),y2+y1(2),z2+z1(2),'Linewidth',4);
plot3(x2+x1(2),y2+y1(2),[0 0]+z1(2),':k');
plot3([x2(2) x2(2)]+x1(2),[y2(2) y2(2)]+y1(2),[0 z2(2)]+z1(2),':k');
arc([x1(2) y1(2) z1(2)],[x1(2) y1(2) z1(2)+a],[x2(2)+x1(2) y2(2)+y1(2) z2(2)+z1(2)],a/2);
text(a/12+x1(2),a/12+y1(2),a/1.75+z1(2),'\psi_i');
arc([x1(2) y1(2) z1(2)],[x1(2)+a y1(2) z1(2)],[x2(2)+x1(2) y2(2)+y1(2) z1(2)],a/2);
text(a/1.6+x1(2),a/8+y1(2),0+z1(2),'\theta_i');
arrow([x1(2)+x2(2) y1(2)+y2(2) z1(2)+z2(2)],[x1(2)+x2(2)+x2(2)/4 y1(2)+y2(2)+y2(2)/4 z1(2)+z2(2)+z2(2)/4],'Length',8);
text(x1(2)+x2(2)+x2(2)/4,y1(2)+y2(2)+y2(2)/4,z1(2)+z2(2)+z2(2)/4+a/6,'T_i');
axis equal
rotate3d on

% fini
