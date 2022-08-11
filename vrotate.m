function [u2,v2] = vrotate(u1,v1,theta)
%    Function to perform 2-D vector rotation
%    Usage: [u2,v2] = vrotate(u1,v1,theta)
%    Where: u1, v1 = input vector coordinates
%           u1(depth,time) is assumed if matrix u1(time) if vector
%           theta(time) = rotation angle in degrees (- is clockwise)
%    RKD 4/97
if size(u1) ~= size(v1), disp(['X Y vectors must be the same size.']); return; end
[m,n]=size(u1);
[mh,nh]=size(theta);
if mh==n, theta=theta'; end  % make sure time dimension is same for both
z1=u1 + sqrt(-1)*v1; % Use complex notation for one step rotation
phi=sqrt(-1)*theta*pi/180;
for j=1:m, % loop through columns (i.e. for matrix ADCP data 
    z(j,:)=z1(j,:).*exp(phi);  % Rotate
end
u2=real(z);v2=imag(z);  % separate real and imaginary parts
% fini
