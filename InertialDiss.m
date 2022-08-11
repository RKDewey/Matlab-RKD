function [epsilon,k,phi]=InertialDiss(dt,velocity,lfft,col);
% function [epsilon,k,phi]=InertialDiss(dt,velocity,lfft,col);
%
% Calculate the turbulent dissipation rate from velocity time series
% Assumes isotropic turbulence with an inertial subrange near k=0.1*k_s
% Following Nasmyth, Grant, Stewart, etc. and Green 1992.
% Inputs:   dt is the sample rate in seconds i.e. 1/4
%           velocity(3,:) is the [U,V,W] time series in m/s
% Optional: lfft = length of fft (default 128)
%           col = color of spectra plot, default 'b'
% Output:   epsilon is the turbulent dissipation rate in m2/s3
%           k is the wavenumber vector
%           phi is the wavenumber spectra phi(k)
% Assumes Temp=10, Sal=31, Density = 1024 --> viscosity=1.345e-6
% Generates a plot of the spectra and the fit in the -5/3 inertial subrange

% RKD 05/10
if nargin<3, lfft=128; end
if nargin<4, col='b'; end
U=velocity(1,:);V=velocity(2,:);W=velocity(3,:);
spd=mean(sqrt(U.^2 + V.^2));
f2k=spd/(2*pi);
%
[pspec,f]=ps(W,dt,lfft);
k=f./f2k;
phi=pspec*f2k;
loglog(k,phi,col);
hold on
%
% now look for a best fit to the Nasmyth spectra in the length scale range 0.5 - 1.0 m 
% corresponding to wavenumbers k = 6.3 t0 12.6
varmin=1e20;
nu=1.345e-6;
k1=10;k2=21; % between scales of 0.63m and 0.30m
indx=find(k > k1 & k < k2);
kfit=k(indx);
m=length(kfit);
eps=1e-10*rand(1);
go=1;
while go,
    [phiN,kN]=nasmyth2(eps,nu,m,kfit);
    phiN=phiN./(kN.*kN);
    var=sum((phi(indx)-phiN).^2);
    varmin=min(var,varmin);
    if varmin==var,
        epsilon=eps;
        indx0=indx;
    end
    eps=eps*1.1;
    if eps> 1e-4,
        go=0;
    end
end
[phiN,kN]=nasmyth2(epsilon,nu,length(k),k);
loglog(kN,phiN./(kN.*kN),'k');
[phiN,kN]=nasmyth2(epsilon,nu,length(k(indx0)),k(indx0));
loglog(kN,phiN./(kN.*kN),'r');
axis([5e-2 5e2 1e-10 1e-3]);
set(gca,'YTick',[1e-10 1e-7 1e-4]);
psslope(-5,3,2,2);
%
%xlabel('Wavenumber (k_1) [m^{-1}]');
ylabel('Velocity Spectra [\phi_{33}(k_1)]')
title(['Epsilon = ',num2str(epsilon),'[W/kg]']);
hold off
% fini