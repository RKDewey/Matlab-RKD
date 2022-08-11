function [Ri,N2,Shear]=richson(Tu,Tl,Uu,Ul,Vu,Vl,dz)
%  function [Ri,N2,Shear]=richson(Tu,Tl,Uu,Ul,Vu,Vl,dz)
%  calculate Richardson number from upper and lower T U and V time series
%  Assumes U and V are in cm/s
% RKD 9/23/94
g=9.81;
alpha=8.75e-6.*(((Tu+Tl)./2)-9);
N2=(alpha*g).*((Tu-Tl)/dz);
Shear=((Uu-Ul)/1000).^2 + ((Vu-Vl)/1000).^2;
Ri=N2./Shear;
%
