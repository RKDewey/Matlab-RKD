function [phi,k] = nasmyth2(epsilon,nu,N,k)
% [phi,k] = nasmyth2(epsilon,nu,N,k)
%
% NASMYTH generates a Nasmyth universal shear spectrum 
%         for a specified dissipation (epsilon [W/kg]) and 
%         viscosity (nu [m^2/s]);
%         phi is the dimensional shear spectrum with N points
%           or (k_1)^2*phi_{22}(k_1) the dimensional shear/dissipation spectra
%         and k input is NOW the wavenumber in radians per meter.
%         and k output is in cylces per meter
%         The defult values for nu and N are N = 1000 and
%         nu = 1.0e-6;
%
%  There are 3 forms of the function
%
%  [phi,k] = nasmyth(epsilon,nu,N)
%
%  [phi,k] = nasmyth(epsilon,nu)
% 
%  [phi,k] = nasmyth(epsilon)
%
%
% 1st Version By D. Huang, G2's formula fited by R. Lueck, CEOR, UVic
%
% Feb. 05, 1996

if nargin == 0
   error('No specific dissipation can be used')
elseif nargin == 1
   nu = 1.0e-6;
   N = 1000;
elseif nargin == 2
   N = 1000;
end

ks = (epsilon/nu^3)^(1/4);

if nargin == 4,  % then user has supplied k
    x = k / (2*pi*ks);
else
    x = logspace(-4,0,N);  % x = k / ks;
end

k = ks * x * 2 * pi;  % in radians per meter

G2 = 8.05 * x.^(1/3) ./ (1 + (20 * x).^(3.7));

phi = epsilon.^(3/4) * nu.^(-1/4) * G2;
