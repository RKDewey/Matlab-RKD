function [Shu,Shv,Shuv,zsh]=shearuv(U,V,z);
% Function [Shu,Shv,Shuv,z]=shearuv(U,V,z)
%  To calculate the vertical shear given two ADCP velocity marices U,V
%	U = east/west velocity matrix [in m/s]
%	V = north/south velocity matrix [in m/s]
%  z = depths (i.e. [23 31 39 ...])  [in meters]
%	Shu = (dU/dz), Shv = (dV/dz), Shuv = (dU/dz)^2 +(dv/dz)^2
%	zsh = depths of shear estiamtes (i.e. [27 35...])
% 1.0	RKD 3/28/94

[m,n]=size(U);
%initialize output matices to NaN values. Note size of shear matrices.
Shu=zeros(m-1,n) + NaN;
Shv=zeros(m-1,n) + NaN;
Shuv=zeros(m-1,n) + NaN;
% Calculate the depth bins for the shear estimates.
for j=2:m
    jj=j-1;
    zsh(jj)=(z(j)+z(jj))/2;
    dz(jj)=abs(z(jj)-z(j));
end
% For every two non-NaN values, calculate shears.
for i=1:n
    for j=2:m
        jj=j-1;
        if ~isnan(U(jj,i)) & ~isnan(U(j,i)),
          Shu(jj,i)=(U(jj,i)-U(j,i))/dz(jj);
        end
        if ~isnan(V(jj,i)) & ~isnan(V(j,i)),
          Shv(jj,i)=(V(jj,i)-V(j,i))/dz(jj);
        end
        if ~isnan(Shu(jj,i)) & ~isnan(Shv(jj,i)),
          Shuv(jj,i)=Shu(jj,i)*Shu(jj,i) + Shv(jj,i)*Shv(jj,i);
        end
    end
end
%