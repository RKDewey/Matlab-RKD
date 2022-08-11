% mooreleang.m  set phi1 and theta1
% script to plot a mooring element with angles
warning off
iskip1=1;
if iskip1==0,
    figure(1);clf;
    r1=[0 0.65];
    r2=[0 0.75];
    phi=[50*pi/180 30*pi/180];
    theta=[50*pi/180 30*pi/180];
%
%clf
%axes('Position',[-0.1 -0.1 1.3 1.3]);
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
    text(a/9,a/7,a/1.5,'\psi_{i+1}');
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
    text(x1(2)-0.075,y1(2)-0.1,z1(2)+0.05,'E_i');
    h=plot3(x2+x1(2),y2+y1(2),z2+z1(2),'Linewidth',4);
    plot3(x2+x1(2),y2+y1(2),[0 0]+z1(2),':k');
    plot3([x2(2) x2(2)]+x1(2),[y2(2) y2(2)]+y1(2),[0 z2(2)]+z1(2),':k');
    arc([x1(2) y1(2) z1(2)],[x1(2) y1(2) z1(2)+a],[x2(2)+x1(2) y2(2)+y1(2) z2(2)+z1(2)],a/2);
    text(a/20+x1(2),a/20+y1(2),a/1.5+z1(2),'\psi_i');
    arc([x1(2) y1(2) z1(2)],[x1(2)+a y1(2) z1(2)],[x2(2)+x1(2) y2(2)+y1(2) z1(2)],a/2);
    text(a/1.6+x1(2),a/8+y1(2),0+z1(2),'\theta_i');
    arrow([x1(2)+x2(2) y1(2)+y2(2) z1(2)+z2(2)],[x1(2)+x2(2)+x2(2)/4 y1(2)+y2(2)+y2(2)/4 z1(2)+z2(2)+z2(2)/4],'Length',8);
    text(x1(2)+x2(2)+x2(2)/4,y1(2)+y2(2)+y2(2)/4,z1(2)+z2(2)+z2(2)/4+a/6,'T_i');
    axis equal
    rotate3d on
    return
end
%
%figure(1);clf
set(0,'DefaultTextFontSize',8);
r=1;
Cd=1.1;A=1;den=10;
aL=10;
if ~exist('u'), u=0.2;v=0.15;w=0.1; end
%
r1=[0 r]; % length of element
if ~exist('phi1'), phi1=50*pi/180; end
if ~exist('theta1'), theta1=60*pi/180; end
a=0.7;
plot3([0 a NaN 0 0 NaN 0 0],[0 0 NaN 0 a NaN 0 0],[0 0 NaN 0 0 NaN 0 a],'k');
arrow([0 0 0],[0 0 a],'NormalDir',[1 0 1],'Length',12);
arrow([0 0 0],[0 a 0],'NormalDir',[1 0 1],'Length',12);
arrow([0 0 0],[a 0 0],'NormalDir',[1 1 0],'Length',12);
text(0,0,a*1.1,'Z');
text(-0.2*a,a,0,'Y');
text(a*1.1,0,0,'X');
hold on
x1=r1*cos(theta1)*sin(phi1);
y1=r1*sin(theta1)*sin(phi1);
z1=r1*cos(phi1);
h=plot3(x1,y1,z1,'Linewidth',2);
plot3(x1,y1,[0 0],':k');
%plot3([x1(2) x1(2)],[y1(2) y1(2)],[0 z1(2)],':k');
view(60,30);
set(gca,'Visible','off')
arc([0 0 0],[0 0 a],[x1(2) y1(2) z1(2)],z1(2)/3);
text(x1(2)/12,y1(2)/12,z1(2)/4,'\psi');
arc([0 0 0],[a 0 0],[x1(2) y1(2) 0],a/5);
text(a*cos(theta1/2)/6,a*sin(theta1/2)/6,0,'\theta');
%arrow([0 0 0],-[x1(2)/4 y1(2)/4 z1(2)/4]);
%text(-x1(2)/4,-y1(2)/4,-(z1(2)/4+a/6),'T');
% draw a current vector
%
%
zoff=z1(2)/2;
xoff=x1(2);yoff=y1(2);
plot3([0 xoff],[0 yoff],[zoff zoff],':k');
wa0=arrow([0 0 zoff],[u v w+zoff],'Length',aL);
arrow([0 0 zoff],[u 0 zoff],'Length',aL);text(u+0.02*sign(u),0,zoff,'U');
arrow([u 0 zoff],[u v zoff],'Length',aL);text(u,v+0.02*sign(v),zoff,'V');
wa1=arrow([u v zoff],[u v w+zoff],'Length',aL);text(u,v,zoff+w+0.02*sign(w),'W');
set(wa0,'FaceColor','b');
set(wa1,'FaceColor','r');
%
theta2=atan2(v,u);
UV=sqrt(u^2+v^2)*cos(theta1-theta2);
U=UV*cos(theta1);  % horizontal current in theta plane
V=UV*sin(theta1);
Up=u-U; % horizontal current perpendicular to theta plane
Vp=v-V;
thetap=atan2(Vp,Up);
arrow([0 0 zoff],[U V zoff],'Length',aL);
arrow([U V zoff],[U+Up V+Vp zoff],'Length',aL);
plot3([u U],[v V],[zoff zoff],':k');
%
theta3=atan2(V,U); % should be exactly equal to theta1
phi2=phi1+pi/2;
%
CdUV=(den/2)*Cd*cos(phi1)^3*A*UV*UV;
Cdx=CdUV*cos(theta3);
Cdy=CdUV*sin(theta3);
arrow([xoff/2 yoff/2 zoff],[xoff/2+Cdx yoff/2+Cdy zoff],'Length',aL);
text(xoff/2+Cdx+0.01,yoff/2+Cdy+0.01,zoff,'C_{DUV}');
%
sl=sign(sin(theta1))*sign(sin(theta3));if sl==0,sl=1;end
CLUV=-(den/2)*Cd*(cos(phi1)^2*sin(phi1))*A*UV*UV*sl;
arrow([xoff/2 yoff/2 zoff],[xoff/2 yoff/2 zoff+CLUV],'Length',aL);
text(xoff/2,yoff/2,zoff+CLUV+0.02*sign(CLUV),'C_{LUV}');
%
%CNUV=(den/2)*Cd*(cos(phi1)^2)*A*UV*UV;
%CNx=CNUV*cos(theta3)*sin(phi2);
%CNy=CNUV*sin(theta3)*sin(phi2);
%CNz=CNUV*cos(phi2);
arrow([xoff/2 yoff/2 zoff],[xoff/2+Cdx yoff/2+Cdy zoff+CLUV],'Length',aL);
text(xoff/2+Cdx+0.02*sign(Cdx),yoff/2+Cdy+0.02*sign(Cdy),zoff+CLUV,'C_{NUV}');
plot3([xoff/2 xoff/2+Cdx],[yoff/2 yoff/2+Cdy],[zoff+CLUV zoff+CLUV],':k');
plot3([xoff/2+Cdx xoff/2+Cdx],[yoff/2+Cdy yoff/2+Cdy],[zoff zoff+CLUV],':k');
%
phi2=pi/2-phi1;
CdW=(den/2)*Cd*cos(phi2)^3*A*w*w*sign(w);
Cdx=CdUV*cos(theta1);
Cdy=CdUV*sin(theta1);
wa2=arrow([xoff/2 yoff/2 zoff],[xoff/2 yoff/2 zoff+CdW],'Length',aL);
set(wa2,'FaceColor','r');
text(xoff/2,yoff/2,zoff+CdW+0.02*sign(CdW),'C_{DLW}');
%
phi2=phi1-pi/2;
CNW=(den/2)*Cd*cos(phi2)^2*A*w*w*sign(w);
CNx=CNW*cos(theta1)*sin(phi2);
CNy=CNW*sin(theta1)*sin(phi2);
CNz=CNW*cos(phi2);
wa3=arrow([xoff/2 yoff/2 zoff],[xoff/2+CNx yoff/2+CNy zoff+CNz],'Length',aL);
set(wa3,'FaceColor','r');
text(xoff/2+CNx+0.02*sign(CNx),yoff/2+CNy+0.02*sign(CNy),zoff+CNz,'C_{NW}');
%
%
CLW=(den/2)*Cd*(cos(phi2)^2*sin(phi2))*A*w*w*sign(w);
CLx=CLW*cos(theta1);
CLy=CLW*sin(theta1);
wa4=arrow([xoff/2 yoff/2 zoff],[xoff/2+CLx yoff/2+CLy zoff],'Length',aL);
set(wa4,'FaceColor','r');
text(xoff/2+CLx+0.02*sign(CLx),yoff/2+CLy+0.02*sign(CLy),zoff,'C_{LW}');
plot3([xoff/2 xoff/2+CNx],[yoff/2 yoff/2+CNy],[zoff+CdW zoff+CNz],':k');
plot3([xoff/2+CNx xoff/2+CLx],[yoff/2+CNy yoff/2+CLy],[zoff+CNz zoff],':k');
%
Ax=0.5*sqrt(y1(2)^2 + z1(2)^2);
Ay=0.5*sqrt(x1(2)^2 + z1(2)^2);
%Az=0.5*sqrt(x1(2)^2 + y1(2)^2);
Ch=(den/2)*Cd*A*(Up^2 + Vp^2);
Cx=Ch*cos(thetap);
Cy=Ch*sin(thetap);
arrow([xoff/2 yoff/2 zoff],[xoff/2+Cx yoff/2 zoff],'Length',aL);
text(xoff/2+Cx+0.02*sign(Cx),yoff/2,zoff,'C_{DU}');
arrow([xoff/2 yoff/2 zoff],[xoff/2 yoff/2+Cy zoff],'Length',aL);
text(xoff/2,yoff/2+Cy+0.02*sign(Cy),zoff,'C_{DV}');
%wa5=arrow([xoff/2 yoff/2 zoff],[xoff/2 yoff/2 zoff+Cz],'Length',aL);
%set(wa5,'FaceColor','r');
%text(xoff/2,yoff/2,zoff+Cz+0.02*sign(Cz),'C_{DW}');
%
view(80,20)
axis equal;
rotate3d on
%
% fini
