%
% Script to calculate/plot the average rotary variance for an ADCP matrix
%	Load workspace first (U,V) assuming dt=60 seconds,
%  determine maximum depth index=mstop (i.e 30)
%	frange is the frequncy range, prange ps amplitude range
% RKD 4/18/94
%
[m,n]=size(U);
dt=1/60.0;
if n > 256
   nps=fix(n/256)*2 - 1;
elseif n > 128 & n <= 256
   nps=fix(n/128)*2 - 1;
elseif n <= 128
   nps=fix(n/64)*2 - 1;
end
%
nvar=0;
for j=m:-1:mstop
    u=U(j,:);
    v=V(j,:);
    [pscw,psacw,M]=rotspec(u,v,dt,nps);
    nvar=nvar+1;
    if j == m 
      T=(M/2)*(nps+1);
      n2=fix(M/2)+1;
      n2m1=n2-1;
      apscw=pscw;
      apsacw=psacw;
    else
      apscw=apscw(1:n2m1)+pscw(1:n2m1);
      apsacw=apsacw(1:n2m1)+psacw(1:n2m1);
    end
 end
 
M=2*T/(nps+1);
I=sum(hanning(M).^2);
ndof=(2*T/I)*(nvar-1);
[plow,phi]=chisqp(ndof,95);
%
pscw=apscw/nvar;
psacw=apsacw/nvar;
%
tott=M*dt;
dfreq=1.0/tott;
f=dfreq*(1:n2-1);
%
psmin=min([log10(pscw) log10(psacw)]);
psmax=max([log10(pscw) log10(psacw)]);
% calculate number of degrees of freedom in original spectrum
if prange(1)==0 & prange(2) ==0
 prange=[floor(psmin) ceil(psmax)];
end
if frange(1)==0 & frange(2) ==0
 frange=[floor(min(log10(f))) ceil(max(log10(f)))];
end
pminc=(10^prange(1))*1.5;
pdec=prange(2)-prange(1); fdec=frange(2)-frange(1);
ndecad=max([pdec fdec]);
%
% Now bin average into increasing size frequency bins
%
fravg=10^(ceil(min(log10(f)))+0.5);
favg=0;
pca=0;
paca=0;
navg=1;
iavg=0;
inew=0;
cmid=10^(prange(1)+1);
pminc=cmid*plow;
pmaxc=cmid*phi;
for i=1:n2-1
    if f(i) <= fravg
       iavg=iavg+1;
       favg=favg+f(i);
       pca=pca+pscw(i);
       paca=paca+psacw(i);
       if iavg == navg
          inew=inew+1;
          fa(inew)=favg/navg;
          pscwa(inew)=pca/navg;
          psacwa(inew)=paca/navg;
          cf(inew)=cmid;
          cfl(inew)=cmid*plow;
          cfh(inew)=cmid*phi;
          iavg=0;
          favg=0;
          pca=0;
          paca=0;
       end
    else
       if iavg >= 1
         inew=inew+1;
         fa(inew)=favg/iavg;
         pscwa(inew)=pca/iavg;
         psacwa(inew)=paca/iavg;
         cf(inew)=cmid;
         cfl(inew)=cmid*plow;
         cfh(inew)=cmid*phi;
       end
       iavg=0;
       favg=0;
       pca=0;
       paca=0;
       navg=navg*2;
       ndof=ndof*2;
       [plow,phi]=chisqp(ndof,95.);
       fravg=10^(log10(fravg)+0.5);
    end
end
if iavg >= 1
   inew=inew+1;
   fa(inew)=favg/iavg;
   pscwa(inew)=pca/iavg;
   psacwa(inew)=paca/iavg;
   cf(inew)=cmid;
   cfl(inew)=cmid*plow;
   cfh(inew)=cmid*phi;
end
%
flab(1)=0.1.*10^frange(2);
flab(2)=0.3.*10^frange(2);
%
fl=([10^(frange(1)+1) 10^(frange(1)+2)]);
if slope < 0
   line=(fl.^(slope))*10.^(prange(1)+ndecad);
   txs=10^(frange(1)+1.4); tys=10^(prange(1)+ndecad-0.25);
elseif slope > 0
   line=(fl.^(slope))*10.^(prange(1));
   txs=10^(frange(1)+1.4); tys=10^(prange(1)+0.25);
elseif slope == 0
   line=(fl.^0)*10.^(prange(1));
end
tx1=10^(frange(1)+0.1); ty1=cmid;
tx2=10^(frange(2)-0.5); 
ty21=10^(prange(2)-.35); ty22=10^(prange(2)-.15);
line1=ones(2,1).*10.^(prange(2)-.35);
line2=ones(2,1).*10.^(prange(2)-.15);
%
loglog(fa,pscwa,'w',fa,psacwa,'--w',fl,line,'w' ...
      ,fa,cfl,'g',fa,cf,'--g',fa,cfh,'g' ...
      ,flab,line1,'--w',flab,line2,'w'),
text(tx1,ty1,'95%'),
text(tx2,ty21,'ACW'),text(tx2,ty22,'CW');
if slope ~= 0
 text(txs,tys,num2str(slope));
end
axis([10.^frange 10.^prange]); pltdat;
%
