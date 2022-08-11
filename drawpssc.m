function drawpssc(a,b,Nsg,Nang)
% function drawpssc(a,b,Nsg,Nang)
% draw both a smooth prolate spheroid and a
% segmented cylnder with major axis a (0.5), minor axis b (0.1)
% with Nsg segments in the segmented cylinder (try =15), and
% Nang elements in the circumference of each and segments
% in the prolate spheroid (try Nang=100).
%  RKD 4/97
clf;
f=abs(sqrt(a^2-b^2));
zeta=a/f;
da1=a*2/Nang;
da2=a*2/Nsg;
xps=(-a:da1:a);
xsc=(-a:da2:a);
yps=sqrt(b^2*(1-((xps.^2)/a^2)));
ysc=sqrt(b^2*(1-((xsc.^2)/a^2)));
[Zps,Yps,Xps]=cylinder(yps,Nang);
[Z,Y,X]=cylinder(ysc,Nang);
j=0;
for i=1:Nsg
   j=j+1;
   Xsc(j,:)=X(i,:);
   Ysc(j,:)=Y(i,:);
   Zsc(j,:)=Z(i,:);
   j=j+1;
   Xsc(j,:)=X(i+1,:);
   Ysc(j,:)=Y(i,:);
   Zsc(j,:)=Z(i,:);   
end
surf(Xps-a,Yps-3*b,Zps);
hold on;
surf(Xsc-a,Ysc+3*b,Zsc);
axis('equal');
colormap('gray');shading flat;
h=xlabel('Major Axis');
set(h,'Position',[-0.25,-0.7,0],'Rotation',22)
h=ylabel('Minor Axis');
set(h,'Position',[-.7,-0.3,0],'Rotation',-30)
zlabel('Vertical');
h=text(0,0,0,'Prolate Spheroid');
set(h,'Position',[-0.25,-.25,.15],'Rotation',22);
h=text(0,0,0,'Segmented Cylinder');
set(h,'Position',[-0.2,.4,.15],'Rotation',22);
% fini


