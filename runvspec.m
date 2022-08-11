%
% Script to calculate the average rotary variance for an ADCP matrix
%	Load workspace first, determine maximum depth index=mstop (i.e 26)
%	frange is the frequncy band to calculate the variance between
% RKD 4/13/94
[m,n]=size(U);
dt=1/60.0;
frange=[1 20];
if n > 256
   nps=fix(n/256)*2 - 1;
elseif n > 128 & n <= 256
   nps=fix(n/128)*2 - 1;
elseif n <= 128
   nps=fix(n/64)*2 - 1;
end
%
nvar=0;
varcw=0;
varacw=0;
for j=m:-1:mstop
    u=U(j,:);
    v=V(j,:);
    [cwv,acwv]=varrspec(u,v,dt,nps,frange);
    varcw=varcw+cwv;
    varacw=varacw+acwv;
    nvar=nvar+1;
end
%
varcw=varcw/nvar;
varacw=varacw/nvar;
[plow,phi]=chisqp((nvar-1),95);
%
[mhd,nhd]=size(hdr);
nlat=0;
nlong=0;
lat=0;
long=0;
for i=1:1:mhd
    if hdr(i,6) > latr(1) & hdr(i,6) < latr(2)
       nlat=nlat+1;
       lat=lat+hdr(i,6);
    end
    if hdr(i,7) > longr(1) & hdr(i,7) < longr(2)
       nlong=nlong+1;
       long=long+hdr(i,7);
    end
end
lat=lat/nlat;
long=long/nlong;
[diskm,dhdng]=gcdis(lat,long,lat0,long0);
%
Dis(istat)=diskm;
Pos(istat,1)=lat;
Pos(istat,2)=long;
Var(istat,1)=varcw;
Var(istat,2)=varacw;
Var(istat,3)=plow;
Var(istat,4)=phi;
