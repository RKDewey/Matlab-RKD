% script file to generate Ocean Physics Logo
% RKD 9/98

theta=[0:1:360]*(pi/180);
r=exp(theta/(2*pi))-1;
[x1,y1]=vector(r,theta,1);
theta=[-66:1:360]*(pi/180);
r=1.2*exp(theta/(2*pi))-1;
[x2,y2]=vector(r,theta,1);
theta=[-145:1:360]*(pi/180);
r=1.4*exp(theta/(2*pi))-1;
[x3,y3]=vector(r,theta,1);

f1=figure(1);clf
% The wave
sp1=subplot(1.5,1,1);
hold on
xmin=min(-x1);xmax=max(x1);
upx=[xmin xmin xmax xmax fliplr(x1) -x1];
upy=[0 1.5 1.5 0 fliplr(y1) -y1];
fill(upx,upy,[.6 .6 1],'edgeColor','none');
lowx=upx;
lowy=[0 -1.5 -1.5 0 fliplr(y1) -y1];
fill(lowx,lowy,[.4 .4 1],'edgeColor','none');
axis equal;axis off;axis tight;
ax=axis;
axis(axis);
% darkest blue
fill([x2 0 x3],[y2 0 y3],[.2 .2 1],'edgeColor','none');
% lightest blue
fill([-x2 0 -x3],[-y2 0 -y3],[.75 .75 1],'edgeColor','none');
axis(ax);
% Profiles
T=[.8 -.5 .07 -.07 .5 -.8];
Z=[1.5 .7 .1 -.1 -.7 -1.5];
[t,z]=pinterp(T,Z,0.005);
s=-t;
ht=plot(t,z);
set(ht,'color',[.9 0 0],'LineWidth',3);
hs=plot(s,z);
set(hs,'color',[0 .7 0],'LineWidth',3);
htit=title('UVic Ocean Physics','FontSize',18,'FontWeight','bold');
% the text
sp2=subplot(3.5,1,3);
axis([-10 10 0 4.6]);
clear txt
txt(1)=text(0,4.5,'Centre for Earth and Ocean Research');
txt(2)=text(0,3.5,'University of Victoria');
txt(3)=text(0,2.5,'PO Box 1700 Victoria BC Canada V8W 2Y2');
txt(4)=text(0,1.5,'Phone: 250-721-7702  FAX: 250-721-7715');
txt(5)=text(0,0.75,'http://maelstrom.seos.uvic.ca/  email:Garrett@phys.uvic.ca');
set(txt(1:3),'FontSize',14);
set(txt(:),'HorizontalAlignment','center');
axis tight
axis off
set(f1,'PaperPosition',[1.5 2.5 5.5 6]);
wysiwyg
% fini
