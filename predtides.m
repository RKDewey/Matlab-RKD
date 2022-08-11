function [u,v,t]=predtides(iconfile,tstart,tend,dt)
% function [u,v,t]=predtides(iconfile,tstart,tend,dt)
% function to make tidal predictions from Forman (tidal.exe) output
% Input:	iconfile='filename.con'
%			tstart=[ihr iday imon iyyyy] to start
%			tend=[ihr iday mon iyyyy} to end
%			dt=time increment (in hours)
% Output: u,v the tidal currents
%			 t the time vector (Julian days)
%
% RKD 11/98

fid=fopen(iconfile,'r');
line=fgetl(fid);
line=fgetl(fid);
line=fgetl(fid);
if strcmp(line(2:12),'Middle Hour'), tm=str2num(line(15:24)); end
line=fgetl(fid);
line=fgetl(fid);
line=fgetl(fid);
line=fgetl(fid);
line=fgetl(fid);
i=0;
while line~=-1,
   disp(line)
   i=i+1;
   con(i)=str2num(line(1:3));
   f(i)=str2num(line(11:20));
   maj(i)=str2num(line(23:29));
   min(i)=str2num(line(30:36));
   amp(i)=str2num(line(37:43));
	inc(i)=str2num(line(44:50));
   g(i)=str2num(line(51:57));
	gp(i)=str2num(line(58:64));
   gm(i)=str2num(line(65:71));
   v(i)=str2num(line(81:88));
   line=fgetl(fid);
end
fclose(fid);
ep=(v-gp);
em=(gm-v);
phase=v-g;
%phase=((ep-em)/2);
%
ids=tstart(2);ims=tstart(3);
iyyyy=tstart(4);ics=fix(iyyyy/100);iys=iyyyy-(ics*100);
ide=tend(2);ime=tend(3);
iyyyy=tend(4);ice=fix(iyyyy/100);iye=iyyyy-(ice*100);
kds=gday(ids,ims,iys,ics);
khs=kds*24 + tstart(1);
kde=gday(ide,ime,iye,ice);
khe=kde*24 + tend(1);
t=[0:dt:(khe-khs)];
u=zeros(size(t));
v=u;
T=tm-t;
dtr=pi/180;
theta=((ep+em)/2);
%theta=inc;
ap=(maj+min)/2;
am=ap-maj;
%
%figure(2);plot(con,phase1,con,phase);
%
i=-sqrt(-1);
for j=1:length(con),
   z1=exp(i*theta(j)*dtr)*(maj(j)*cos(dtr*phase(j) - 2*pi*f(j)*T)...
      			      		+ i*min(j)*sin(dtr*phase(j) - 2*pi*f(j)*T));
   z2=ap(j)*exp(i*(dtr*ep(j) - 2*pi*f(j)*T)) ...
      +am(j)*exp(i*(dtr*em(j) + 2*pi*f(j)*T));
   %figure(3);clf;plot(real(z1),imag(z1),'r',real(z2),imag(z2),'b');
   u=u+real(z1);
   v=v+imag(z1);
end
t1=julian([ids ims iys],[tstart(1) 0 0]);
t2=julian([ide ime iye],[tend(1) 0 0]);
t=[t1:dt/24:t2];
% fini
