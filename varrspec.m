function [cwv,acwv]=varrspec(x,y,dt,nps,frange)
%  [cwv,acwv]=VARRSPEC(x,y,dt,nps,frange) calculates rotary spectrum 
%  for the complex time series z=x+iy, divided into nps 50% overlap segments.
%  calculates variance between frequncies passed in variable frange
%  Note: Negative Frequency spectral part=clockwise component
%  equal to SPECTRUM Pxx if cw and acw are added.
%  Version 1.0  rkd 4/13/94
[m,T]=size(x);
% chunk and fill NaN values in both real and imaginary ts first.
tsx=zeros(1,T) + (dt:dt:(T*dt));
tsy=tsx;
if max(isnan(x)) == 1 | max(isnan(y)) == 1
[x,tsx]=cleanx(x,tsx);
[y,tsy]=cleanx(y,tsy);
if size(tsx) ~= size(tsy)
   if tsx(1) < tsy(1)
      mx=length(tsx);
      ist=find(tsx == tsy(1));
      iend=find(tsy == tsx(mx));
      nnew=iend-ist+1
      xnew(1:nnew)=x(ist:mx);
      ynew(1:nnew)=y(1:iend);
      x=xnew;
      y=ynew;
   else
      my=length(tsy);
      ist=find(tsy == tsx(1));
      iend=find(tsx == tsy(my));
      nnew=iend-ist+1
      xnew(1:nnew)=x(1:iend);
      ynew(1:nnew)=y(ist:my);
      x=xnew;
      y=ynew;
   end
end
end
% now find new time series length
[m,T]=size(x);
% calculate various spectral parameters
M=fix((2*T)/(nps+1));
window=hanning(M);
I=(sum(window.^2));
W=M/I;
window=window';
nst=1;
n2=fix(M/2)+1;
pscw=zeros(1,n2-1);
psacw=zeros(1,n2-1);
% see how he uses the spanner!
for jj=1:nps
    nen=nst+M-1;
    XY=fft((window.*(detrend(x(nst:nen))))+i*(window.*(detrend(y(nst:nen)))));
    PS=XY.*conj(XY);
    psacw=psacw+PS(2:n2);
    PS=fliplr(PS);
    pscw=pscw+PS(1:n2-1);
    nst=nst+fix(M/2);
end
% note: no factor of 2, since both +/- frequencies are maintained
% total power in a freq band includes both pscw and psacw
pscw=pscw*(dt*W/(M*nps));
psacw=psacw*(dt*W/(M*nps));
%
dfreq=1.0/(M*dt);
ist=frange(1)/dfreq;
iend=frange(2)/dfreq;
%
cwv=sum(pscw(ist:iend))*dfreq;
acwv=sum(psacw(ist:iend))*dfreq;
%
