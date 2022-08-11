function [pscw,psacw,M,T,f,aXY]=rotspec(x,y,dt,nps)
%  [pscw,psacw,M,T,f,XY]=rotSPEC(x,y,dt,nps) calculates rotary spectrum 
%  for the complex time series z=x+iy, divided into nps (odd) 50% overlap segments.
%  Note: Negative Frequency spectral part=clockwise component
%  M is the length of the clean time series sections passed to fft (DFT).
%  T is the total length of the clean time series.
% Optional outputs are 
%    XY is the raw (un-scaled) complex cross spectra
%      to scale (XY.*conj(XY))*dt/(sum(hanning(M).^2));
%  Equal to SPECTRUM's Pxx if cw and acw are added.
%  Version 1.0  rkd 4/13/94; v1.2 2/1/95
x=x(:)';
y=y(:)';
T=length(x);
% force nps to be odd
if rem(nps,2) == 0,nps=nps+1;end
%if nps<3,nps=3;end 
% chunk and fill NaN values in both real and imaginary ts first.
tsx=(dt:dt:(T*dt));
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
T=length(x);
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
    if jj==1,
       aXY=XY;
    else
       aXY=aXY + XY;
    end
    PS=XY.*conj(XY);
    psacw=psacw+PS(2:n2); % anticlockwise are the positive freq
    PS=fliplr(PS);
    pscw=pscw+PS(1:n2-1); % clockwise are the negative freq
    nst=nst+fix(M/2);
end
% note: no factor of 2, since both +/- frequencies are maintained
% total power in a freq band includes both pscw and psacw
pscw=pscw*(dt*W/(M*nps));
psacw=psacw*(dt*W/(M*nps));
aXY=aXY/nps;
%
tott=M*dt;
dfreq=1.0/tott;
n2=fix(M/2)+1;
f=dfreq*(1:n2-1);
% fini
