% script to plot ADCP beam patterns and bin mapping
clf;
dr=1.0; % bin size
bw=5.0; % half beam width
ba=20; % beam angle
ta=-15; % tilt angle
nb=15;
facex=[0 -1 -1 -0.15 0.15 1 1 0];
facey=[0 0 .2 0.2+tan(ba*pi/180)*0.85 0.2+tan(ba*pi/180)*0.85 0.2 0 0];
cfx=[-1+0.85/2 1-0.85/2];
cfy=0.2+tan(ba*pi/180)*(0.85/2)*[1 1];
rangebins=dr*[0:nb];
rbc=rangebins(1:end-1)+dr/2;
l=length(rangebins);
s=[sin((ba-bw)*pi/180) sin(ba*pi/180) sin((ba+bw)*pi/180)];
c=[cos((ba-bw)*pi/180) cos(ba*pi/180) cos((ba+bw)*pi/180)];
beam1x=cfx(1)-[rangebins*s(1);rangebins*s(2);rangebins*s(3)];
beam1y=cfy(1)+[rangebins*c(1);rangebins*c(2);rangebins*c(3)];
beam1cx=cfx(1)-rbc*s(2);
beam1cy=cfy(1)+rbc*c(2);
beam2x=cfx(2)+[rangebins.*s(1);rangebins.*s(2);rangebins.*s(3)];
beam2y=cfy(2)+[rangebins.*c(1);rangebins.*c(2);rangebins.*c(3)];
beam2cx=cfx(2)+rbc*s(2);
beam2cy=cfy(2)+rbc*c(2);
plot(facex,facey,'b');hold on
plot(beam1x,beam1y,'k',beam2x,beam2y,'k');
plot(beam1x([1 3],:)',beam1y([1 3],:)','k',beam2x([1 3],:)',beam2y([1 3],:)','k');
plot(beam1cx,beam1cy,'*k',beam2cx,beam2cy,'*k');
text(beam1cx(end)-0.5,beam1cy(end)+1,'Beam-4');
text(beam2cx(end)-0.5,beam2cy(end)+1,'Beam-3');
[fx,fy]=vrotate(facex,facey,ta);
os=10;
plot(fx+os,fy,'b');hold on
[b1x,b1y]=vrotate(beam1x,beam1y,ta);
[b2x,b2y]=vrotate(beam2x,beam2y,ta);
[b1cx,b1cy]=vrotate(beam1cx,beam1cy,ta);
[b2cx,b2cy]=vrotate(beam2cx,beam2cy,ta);
plot(b1x+os,b1y,'k',b2x+os,b2y,'k');
plot(b1x([1 3],:)'+os,b1y([1 3],:)','k',b2x([1 3],:)'+os,b2y([1 3],:)','k');
plot(b1cx+os,b1cy,'-+k',b2cx+os,b2cy,'-+k');
for i=1:length(b2cx),
    text(b1cx(i)+os-0.5,b1cy(i),num2str(i));
    text(b2cx(i)+os+0.2,b2cy(i),num2str(i));
end
text(b1cx(end)+os-0.5,b1cy(end)+1,'Beam-4');
text(b2cx(end)+os-0.5,b2cy(end)+1,'Beam-3');
set(gca,'Visible','off');axis equal
XLim=get(gca,'XLim');
%
hx=zeros(1,length(rbc));
hy=rbc*cos(ba*pi/180)+cfy(1);
plot(hx,hy,'r',hx+os,hy,'r');
for i=1:length(hx),
    plot([XLim(1) XLim(2)],[hy(i) hy(i)],'r');
    text(hx(i)+0.2,hy(i),num2str(i));
    text(hx(i)+os+0.2,hy(i),num2str(i));
end
text(hx(end)-0.5,hy(end)+1,'Zero Tilt');
text(hx(end)+os,hy(end)+1,'Tilted (Pitch/Beam 3 Down)');
%wysiwyg
% fini