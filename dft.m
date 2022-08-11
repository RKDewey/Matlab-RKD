function F=dft(z,inv);
% function F=dft(z,inv);
% The discrete Fourier transform of complex time series z=x+iy
% inv=1 (default) for DFT F=dft(z); and inv=-1 of inverse DFT z=dft(F,-1);
% Check: F=dft(z); Z=dft(F,-1); z = real(Z) + imag(Z) - mean(z);
% RKD 03/12 (from ancient fortran code)
x=0;y=0;
if nargin<2, inv=1; end
if inv==1, % discrete Fourier transform
    n=length(z);
    nf=n/2+1;
    j=[0:n-1];
    for k=1:nf,
        a=2.0*pi*(k-1)/n;
        F(k)=sum(z.*complex(cos(a*j),sin(a*j)));
    end
else % inverse DFT
    nf=length(z);
    n=(nf-1)*2;
    j=[0:nf-1];
    for k=1:n,
        a=2.0*pi*(k)/n;
        F(k)=complex(sum(real(z).*cos(a*j)),sum(imag(z)*(-1).*sin(a*j)));
    end
    F=fliplr(F)/(nf-1);
end
