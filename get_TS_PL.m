%function [TS]=get_TS_PL(freq,a,rho,Ccompress,Cshear,PL);
%calculate sphere target strength (in dB) weighted by frequency window of
% transmitted pulse at :
%      freq => frequency of sounder (in kHz)
%         a => diameter of target sphere (in milimeters)
%       rho => density of target sphere (kg/m^3; 7860 for stainlees steel)
% Ccompress => compressive sound speed of target sphere (m/s; 5850 for stainlees steel)
%    Cshear => shear sound speed of target sphere (m/s; 3130 for stainlees steel)
%        PL => transmit pulse length of sounder (microsec)

function [TS]=get_TS_PL(freq,a,rho,Ccompress,Cshear,PL);
sigma=(1-(Ccompress/Cshear)^2/2)/(1-(Ccompress/Cshear)^2); %poisson's ratio
a=a/2/1000; %want RADIUS in meters
f=freq+[-round(PL/100):0.01:round(PL/100)];
k=2*pi*f/1.48; %wavenumber at f (in water)
k1=2*pi*f/Ccompress*1000; %compresional wavenumber at f (in sphere)
k2=2*pi*f/Cshear*1000; %shear wavenumber at f (in sphere)
g=rho/1000;   %ratio of target density to water density (approx)
sigfac=sigma/(1-2*sigma);
x1=k1*a;
x2=k2*a;
x=k*a;
m=[0:50]';
%Jm1,2 == mth order spherical bessel function with argument x1,2
%Jpm1,2 == x1,2 * first derivative of mth order spherical bessel function
%Jppm1,2 == (x1,2)^2 * second derivative of mth order spherical bessel function
Jm1  =ones(size(m))*sqrt(pi./x1/2).*(                         besselj(m+.5,x1)'                                                                            );
Jm2  =ones(size(m))*sqrt(pi./x2/2).*(                         besselj(m+.5,x2)'                                                                            );
Jpm1 =ones(size(m))*sqrt(pi./x1/2).*(       m*ones(size(x1)).*besselj(m+.5,x1)'-ones(size(m))*x1.*besselj(m+1+.5,x1)'                                       );
Jpm2 =ones(size(m))*sqrt(pi./x2/2).*(       m*ones(size(x1)).*besselj(m+.5,x2)'-ones(size(m))*x2.*besselj(m+1+.5,x2)'                                       );
Jppm1=ones(size(m))*sqrt(pi./x1/2).*((m-1).*m*ones(size(x1)).*besselj(m+.5,x1)'-      (2*m+1)*x1.*besselj(m+1+.5,x1)'+ones(size(m))*x1.^2.*besselj(m+2+.5,x1)');
Jppm2=ones(size(m))*sqrt(pi./x2/2).*((m-1).*m*ones(size(x1)).*besselj(m+.5,x2)'-      (2*m+1)*x2.*besselj(m+1+.5,x2)'+ones(size(m))*x2.^2.*besselj(m+2+.5,x2)');
Fm=1/g.*ones(size(m))*x2.^2/2.*...
    (            Jpm1       ./(Jpm1-Jm1)         -   2*(m.^2+m)*ones(size(x1)).*Jm2./((m.^2+m-2)*ones(size(x1)).*Jm2+Jppm2))./ ...
    ((sigfac*ones(size(m))*x1.^2.*Jm1-Jppm1)./(Jpm1-Jm1)  -   2*(m.^2+m)*ones(size(x1)).*(Jm2-Jpm2)./((m.^2+m-2)*ones(size(x1)).*Jm2+Jppm2));
nu_m=atan(-(besselj(m+.5,x)'.*(Fm-m*ones(size(x1)))+ones(size(m))*x.*besselj(m+1+.5,x)')./ ... %from Faran (1951)
           (bessely(m+.5,x)'.*(Fm-m*ones(size(x1)))+ones(size(m))*x.*bessely(m+1+.5,x)'));
for i=1:length(f)
TSall(i)=sum(sum([(-1).^(m)*(-1).^(m')].*[[2*m+1]*[2*m+1]'].*(sin(nu_m(:,i))*sin(nu_m(:,i)')).*exp(sqrt(-1)*(nu_m(:,i)*ones(size(nu_m(:,i)'))-ones(size(nu_m(:,i)))*nu_m(:,i)'))))/k(i)^2;
end
TSall=10*log10(real(TSall));
%now calculate (weighted) mean TS @ freq
w=sinc(f*PL*1e-3*pi).^2;
TS=sum(w.*TSall)/sum(w);
% fini