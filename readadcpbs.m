% script to read an asci bblist file of 300 kHz ADCP data
% and save the back-scatter data
% Set these prelim parameters:
% sample=number of seconds per sample (i.e. 30)
% hours=number of hours in file (12 for jdf, 8 for gs)
% ndep=number of depth bins (53 jdf96, 42 gs96, 54 jdf97)
% ifile=filename
% z=(126.5:-2:20.5) % in JdF96; z=(117.5:-2:11.5) % in JdF97
% z=(34.5:-1:(34.5-41)); For GS 1
% z=(73.5:-2:(73.5-82)); For GS 2
% RKD 4/9/96
nrec=hours*3600/sample;
clear m bs1 bs2 bs3 bs4 bsa line io
io=fopen(ifile);
for r=1:nrec
   line=fgets(io);
   if length(line) > 4,
    nens=str2num(line(1:5));
    yy=1900+str2num(line(7:8));
    mm=str2num(line(10:11));
    dd=str2num(line(13:14));
    hh=str2num(line(16:17));
    mi=str2num(line(19:20));
    ss=str2num(line(22:23));
    if rem(nens,100) == 0, disp(line); end
    time(r)=julian([dd mm yy],[hh mi ss]);
    m=fscanf(io,'%f',[16,ndep]);
    bs1(:,r)=m(9,:)';
    bs2(:,r)=m(10,:)';
    bs3(:,r)=m(11,:)';
    bs4(:,r)=m(12,:)';
    line=fgets(io);
   end
end
bs1=flipud(flag2nan(bs1,99999));
bs2=flipud(flag2nan(bs2,99999));
bs3=flipud(flag2nan(bs3,99999));
bs4=flipud(flag2nan(bs4,99999));
bsa=(bs1+bs2+bs3+bs4)/4;
fclose(io);
clear m line io
%