% Read and plot RBR data
type=1; % 1=tr1000, 2=xl200, 3=xl210
%load filenames;  % To process abatch, load filenames here
filenames(1,:)=ifile;  % Otherwise, pass a single input file name in ifile
[n,m]=size(filenames);
for j=1:n,
fid=fopen(filenames(j,1:12));
line=fgetl(fid);disp(line);
%
if type==1,
for i=1:3, line=fgetl(fid); end
yy=str2num(line(15:16));mo=str2num(line(18:19));dd=str2num(line(21:22));
hh=str2num(line(24:25));mm=str2num(line(27:28));ss=str2num(line(30:31));
stime=julian([dd mo yy],[hh mm ss]);
for i=1:2, line=fgetl(fid); end
dt=(str2num(line(27:28)) + (str2num(line(30:31))/60))/(24*60);
for i=1:6, line=fgetl(fid); end
T=fscanf(fid,'%f');
elseif type==2,
for i=1:3, line=fgetl(fid); end
yy=str2num(line(15:16));mo=str2num(line(18:19));dd=str2num(line(21:22));
hh=str2num(line(24:25));mm=str2num(line(27:28));ss=str2num(line(30:31));
stime=julian([dd mo yy],[hh mm ss]);
for i=1:2, line=fgetl(fid); end
dt=(str2num(line(27:28)) + (str2num(line(30:31))/60))/(24*60);
for i=1:6, line=fgetl(fid); end
iend=1;icnt=1;
line=fgetl(fid);
line=fgetl(fid);disp(line);
while iend,
  [a,count]=fscanf(fid,'%f',8);
  if count<2, 
     line=fgetl(fid);disp(line);
     [a,count]=fscanf(fid,'%f',8);
  end
  if count < 8, iend=0; end
  nd=length(a)/2;
  T(icnt:icnt+nd-1)=a(1:2:nd*2);
  P(icnt:icnt+nd-1)=a(2:2:nd*2);
  icnt=icnt+nd;
end
elseif type==3,
for i=1:3, line=fgetl(fid); end
yy=str2num(line(15:16));mo=str2num(line(18:19));dd=str2num(line(21:22));
hh=str2num(line(24:25));mm=str2num(line(27:28));ss=str2num(line(30:31));
stime=julian([dd mo yy],[hh mm ss]);
for i=1:2, line=fgetl(fid); end
dt=(str2num(line(27:28)) + (str2num(line(30:31))/60))/(24*60);
for i=1:6, line=fgetl(fid); end
iend=1;icnt=1;
line=fgetl(fid);
line=fgetl(fid);disp(line);
while iend,
  [a,count]=fscanf(fid,'%f',8);
  if count<2, 
     line=fgetl(fid);disp(line); 
     [a,count]=fscanf(fid,'%f',8);
  end
  if count <8, iend=0; end
  nd=length(a)/2;
  T(icnt:icnt+nd-1)=a(1:2:nd*2);
  C(icnt:icnt+nd-1)=a(2:2:nd*2);
  icnt=icnt+nd;
end
end
fclose(fid);
etime=stime+dt*(length(T)-1);
if type==1,
   eval(['save ',filenames(j,3:8),' T stime dt etime']);
   plot([stime:dt:etime],T);
elseif type==2,
   eval(['save ',filenames(j,3:8),' T P stime dt etime']);
   subplot(2,1,1);plot([stime:dt:etime],T);
   subplot(2,1,2);plot([stime:dt:etime],P);
elseif type==3,
   eval(['save ',filenames(j,3:8),' T C stime dt etime']);
   subplot(2,1,1);plot([stime:dt:etime],T);
   subplot(2,1,2);plot([stime:dt:etime],C);
end
%
save temp filenames n j type
clear all
load temp
end  % loop required if using filenames
% fini