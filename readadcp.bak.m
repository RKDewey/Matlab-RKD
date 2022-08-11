% script to read an asci bblist file of 300 kHz ADCP data
% sample=number of seconds per sample (i.e. 30)
% hours=number of hours in file (12 for jdf, 8 for gs)
% ndep=number of depth bins (53 for jdf, 42 for gs)
% ifile=filename
% z=(126.7:-2:20.7); For Juan de Fuca
% z=(34.5:-1:(34.5-41)); For GS 1
% z=(73.5:-2:(73.5-82)); For GS 2
% RKD 4/9/96
nrec=hours*3600/sample;
clear m u v w U V W line io
io=fopen(ifile);
for r=1:nrec
    line=fgets(io);
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
    U(:,r)=m(5,:)';
    V(:,r)=m(6,:)';
    W(:,r)=m(7,:)';
    line=fgets(io);
end
U=flag2nan(U,99999);
V=flag2nan(V,99999);
W=flag2nan(W,99999);
u=flipud(U);v=flipud(V);w=flipud(W);
fclose(io);
clear m U V W line io
%