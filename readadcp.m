function ofile=readadcp(ifile,z,ndep,ens)
% function ofile=readadcp(ifile,z,ndep,ens)
% script to read an asci bblist file of 300 kHz ADCP data
% Set these prelim parameters:
% ndep=number of depth bins 
% (53 jdf96, 42 gs96, 54 jdf97, 60 jdf98n 50 jdf98s 115 jdf99s)
% ifile=filename
% JdF99s z=3:117, depth=109:-1:-5
% JdF98n z=(131.1:-2:13.1);
% JdF98s z=(96.1:-2:-2);
% JdF97 z=(117.5:-2:11.5)
% JdF96 z=(126.5:-2:20.5); 
% GS96 z=(34.5:-1:(34.5-41)); For GS 1
% GS96 z=(73.5:-2:(73.5-82)); For GS 2
% RKD 4/9/96
io=fopen(ifile);
r=0;
ndep=length(z);
for rr=1:ens
   line=fgetl(io);
   if line == -1, break, end
    nens=str2num(line(1:5));
    yy=1900+str2num(line(7:8));
    mm=str2num(line(10:11));
    dd=str2num(line(13:14));
    hh=str2num(line(16:17));
    mi=str2num(line(19:20));
    ss=str2num(line(22:23));
    if rem(nens,100) == 0, disp(line); end
    r=r+1;
    time(r)=julian([dd mm yy],[hh mi ss]);
    heading(r)=str2num(line(25:30));
    pitch(r)=str2num(line(32:37));
    roll(r)=str2num(line(39:44));
    temp(r)=str2num(line(47:51));
    m=fscanf(io,'%f',[12,ndep]);
    %    m=fscanf(io,'%f',[16,ndep]);   % If % good are included
    b1(:,r)=m(1,:)';
    b2(:,r)=m(2,:)';
    b3(:,r)=m(3,:)';
    b4(:,r)=m(4,:)';
    U(:,r)=m(5,:)';
    V(:,r)=m(6,:)';
    W(:,r)=m(7,:)';
    E(:,r)=m(8,:)';
    bs1(:,r)=m(9,:)';
    bs2(:,r)=m(10,:)';
    bs3(:,r)=m(11,:)';
    bs4(:,r)=m(12,:)';
    line=fgets(io); % read the "end of line"
end
fclose(io);
b1=flipud(b1);
b2=flipud(b2);
b3=flipud(b3);
b4=flipud(b4);
u=flipud(flag2nan(U,99999))/10;
v=flipud(flag2nan(V,99999))/10;
w=flipud(flag2nan(W,99999))/10;
e=flipud(flag2nan(E,99999))/10;
bs1=flipud(flag2nan(bs1,99999));
bs2=flipud(flag2nan(bs2,99999));
bs3=flipud(flag2nan(bs3,99999));
bs4=flipud(flag2nan(bs4,99999));
bs=(bs1+bs2+bs3+bs4)/8;  % now in dB
ofile=['d:\data\jdf1998\adcps\rawmat\',ifile(1:6) ifile(8:10)];
eval(['save ',ofile,' ifile z time b1 b2 b3 b4 u v w e bs heading pitch roll temp']);
save temp ofile
clear all
load temp
% fini
