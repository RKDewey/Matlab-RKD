function [phi,k] = nasmyth(epsilon,nu,N)
% [phi,k] = nasmyth(epsilon,nu,N)
%
% NASMYTH generates a Nasmyth universal shear spectrum 
%         for a specified dissipation (epsilon [W/kg]) and 
%         viscosity (nu [m^2/s]);
%         phi is the dimensional shear spectrum with N points
%           or (k_1)^2*phi_{22}(k_1) the dimensional shear/dissipation spectra
%         and k is the wavenumber in cycles per meter.
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

x = logspace(-4,0,N);  % x = k / ks;

G2 = 8.05 * x.^(1/3) ./ (1 + (20 * x).^(3.7));

ks = (epsilon ./ nu.^3) .^(1/4);

k = ks * x;

phi = epsilon.^(3/4) * nu.^(-1/4) * G2;
