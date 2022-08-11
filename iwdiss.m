function [eiw,Kiw,Ri,mSh,ziw]=iwdiss(N,zN,S,zS,zstop);
% [eiw,Kiw,Ri,mSh,ziw]=iwdiss(N,zN,Sh,zSh,zstop);
% function to calculate the Gregg estimate of IW dissipation/diffusivity
%	N = Brunt-Vaisala frequency profile units [rad/s=s^-1]
%	S = Shear maxtrix ((dU/dz)^2 + (dV/dz)^2) in units of s^-2
%	z? the depths in meters for each of the above data
%	   the eiw are evaluated at the zS depths, assumed dz=8.
%	eiw is the dissipation rate [W/kg] due to IW (Gregg 1987)
%	Kiw is the diffusivity [m^2/s] following D'Asaro&Morison(1992)
%	Ri is a Richardson Number profile (N^2/Sh^2)
%	mSh is the average Shear^2 profile [s^-2]
%	zstop=maximum depth to stop at (i.e. zstop=300)
% RKD 4/21/94, vectorized 3/96
dz2=mean(diff(zS))/2;
jstop=max(find(zN<=zstop));
if zN(jstop) < zstop, zstop=zN(jstop); end
innan=find(N<=0); % remove all negative N values.
if sum(innan) > 0, N(innan)=ones(size(N(innan)))*NaN; end
[mS,nS]=size(S);
N02=(0.0052)^2;
N2N02=(N.^2)/N02;
S4GM=(1.66*10^(-10))*N2N02.^2;
%
izmax=max(find(zS <= zstop));
ziw=zS(1:izmax);
for i=1:izmax
   [cS,tS]=cleanx(S(i,:),(1:length(S(i,:))));
% 2.47 is the differential factor for dz=8m, see Gregg&Stanford'88
   mS4=mean((2.47*cS).^2);
   mSh(i)=mean(2.47*cS); % Calculate the mean shear at each depth
   izN=find((zN >= (zS(i)-dz2) & zN <= (zS(i)+dz2)));
   if sum(izN) ~= 0,
      eiw(i)=(7*10^(-10))*mS4*mean(N2N02(izN)./S4GM(izN));
      Kiw(i)=(5*10^(-6))*mS4/(mean(N(izN))^4);
      Ri(i)=(mean(N(izN))^2)/mSh(i);
   else
      eiw(i)=NaN;
      Kiw(i)=NaN;
      Ri(i)=NaN;
   end % if there are N values in this shear depth range
end % for loop through Shear depths
%
