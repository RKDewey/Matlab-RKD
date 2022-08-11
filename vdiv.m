function MM=vdiv(M,v)
% MM=vdiv(M,v)
%
% Vdiv divides vector v into each row of m x n matrix M.
% The length of v must equal the number of columns in M.
%  9 Mar 92  - G.Lagerloef

[m,n]=size(M);vp=v;[vm,vn]=size(vp);
if vm~=1, vp=v'; end; [vm,vn]=size(vp);
if vm~=1, error(' v is not a vector'), end
if vn~=n, 
error(' Length v not equal to number columns in M'),
end,

if any(vp==0),
 error(' v contains some zeros, cant divide.'),
end,

MM=ones(m,1); vp=ones(vp)./vp; MM=MM*vp;
MM = M .* MM;