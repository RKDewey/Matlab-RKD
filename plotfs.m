function plotfs(angle,dat,fsamp,drt)
% function plotfs(angle,dat,fsamp,drt)
% plots the forward scatter (beam pattern) defined by
% the variables angle (degrees) and fsamp (amplitude).
% where dat is the plot ingrement for angle axes (i.e. 10),
% and drt are the range tick marks in db (i.e. 10). 
% This routine takes the db of amp, and plots 
% the db relative to the minimum amplitude.
%
%  RKD 2/97
amp=db(fsamp);
if min(amp) < 0,
   range=max(amp)-min(amp);
else
   range=max(amp);
end
dr=fix(range/10)*10+10;
rticks=[0:drt:dr];
if min(amp) < 0, amp=amp+abs(min(amp)); end
%
a=angle*(pi/180);
arange=max(angle)-min(angle);
dar=(fix(arange/10)+1)*10;
amid=(max(angle)+min(angle))/2;
aticks=[(fix((amid-dar/2)/10)-1)*10:dat:(fix((amid+dar/2)/10)+1)*10];
aticksr=aticks*(pi/180);
%
% Draw axes
%
na=length(aticksr);
j=1;
da=2*(pi/180);
for i=1:na
    xr(j)=0;xr(j+1)=dr;
    ya(j)=aticksr(i);ya(j+1)=aticksr(i);
    j=j+2;
    if i == 1 | i == na | aticks(i) == amid;
       for jj=0:length(rticks)-2
           xr(j)=dr-(jj*drt);
           xr(j+1)=dr-(jj*drt);
           xr(j+2)=dr-(jj*drt);
           ya(j)=aticksr(i)+da;ya(j+1)=aticksr(i)-da;ya(j+2)=aticksr(i);
           j=j+3;
           xr(j)=dr-((jj+1)*drt);
           ya(j)=aticksr(i);
           j=j+1;
           fac=(1.3*length(rticks))/(length(rticks)-jj);
           if i==1
              xrl(1,jj+1)=dr-(jj*drt);
              yrl(1,jj+1)=aticksr(i)-(da*fac);
           end
           if i==na
              xrl(2,jj+1)=dr-(jj*drt);
              yrl(2,jj+1)=aticksr(i)+(da*fac);
           end
       end
       xr(j)=0;ya(j)=0;j=j+1;
    end
end
[x,y]=vector(xr,ya,1);
plot(x,y,'w');axis('equal');axis(axis);
set(gca,'Visible','off');hold on
for j=1:2
 [x,y]=vector(xrl(j,:),yrl(j,:),1);
 for i=1:length(x)
    h=text(x(i),y(i),num2str(rticks(length(rticks)+1-i)));
    set(h,'HorizontalAlignment','center');
    set(h,'Rotation',((180/pi)*yrl(j,i)));
 end
end
%
[x,y]=vector([dr dr],[aticksr(1) aticksr(length(aticksr))],1);
xyz0=[0,0,0];xyz1=[x(1),y(1),0];xyz2=[x(2),y(2),0];
th2=pltarc(xyz0,xyz1,xyz2,dr,200);
%
[x,y]=vector(amp,a,1);
h=plot(x,y,'r');
set(h,'LineWidth',2.0)
%fini