function hodo(u,v,z,i,az,el)
% function hodo(u,v,z,i,az,el)
% to plot a hodograph at index i from a U anv V profile with a height vector z
% az and el are the view angles for view(az,el), defaults 120,15
% Optional: i (default 1), az (120),el (15)
%
% RKD 05/11
if nargin<4, i=1; end
if nargin<5, az=120; end
if nargin<6, el=15; end
gc=[0 0.6 0];
vmax=max(max(abs((minmax(u))),abs(minmax(v))));
vmax0=[0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0];
ivmx=find(vmax0>vmax);
vmax=vmax0(ivmx(1));
clf;axes('Position',[0.25 0.1 0.5 0.8]);
hold on
% warning off
%for j=1:length(z),
      orig=[0;0;1]*z;
      vec=[u(:,i)';v(:,i)';z(:)'];
      ar=arrow(orig,vec,'Length',30,'BaseAngle',80,'TipAngle',30);
      set(ar(:),'FaceColor','b','EdgeColor','b');
      set(ar(:),'LineWidth',1);
%end
lw=0.5;
lh(1)=plot3([0 0],[0 0],[0 z(end)],'k');
if az>0,
    lh(2)=plot3([-vmax -vmax],[0 0],[0 z(end)],'k');
else
    lh(2)=plot3([vmax vmax],[0 0],[0 z(end)],'k');
end
lh(3)=plot3([0 0],[-vmax -vmax],[0 z(end)],'k');
set(lh(:),'LineWidth',lw);
axis([-vmax vmax -vmax vmax -0.1 z(end)+2]);
up=[0 u(:,i)'];vp=[0 v(:,i)'];
p=-vmax*ones(size(vp));zp=[0 z];
h2=plot3(up,p,zp);set(h2,'Color',gc,'LineWidth',1.5);
if az>0,
    plot3(p,vp,zp,'r','LineWidth',1.5);
else
    plot3(-p,vp,zp,'r','LineWidth',1.5);
end
view(az,el);
scl=1.3;
if az>0,
    th(1)=text(scl*vmax,-0.6,0,'S');th(2)=text(scl*vmax,0.7,0,'N');
    th(3)=text(scl*vmax,0,0,'[m/s]');
    th(4)=text(0.7,scl*vmax,0,'E');th(5)=text(-0.55,scl*vmax,0,'W');
    th(6)=text(0.15,scl*vmax,0,'[m/s]');
else
    th(1)=text(-scl*vmax,-0.6,0,'S');th(2)=text(-scl*vmax,0.7,0,'N');
    th(3)=text(-scl*vmax,0,0,'[m/s]');
    th(4)=text(0.7,scl*vmax,0,'E');th(5)=text(-0.55,scl*vmax,0,'W');
    th(6)=text(0.15,scl*vmax,0,'[m/s]');
end
set(th(:),'FontSize',14);
zlabel('Height [m]');
set(gca,'LineWidth',lw);
grid on
drawnow;
% fini