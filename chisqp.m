function [plow,phi,Fx]=chisqp(ndof,ci)
% function [plow,phi,[F x]]=chisqp(ndof,ci)
% 	returns the low and hi probability of a chi-sq dist. for ndof 
%	degrees of freedom and confidence interval ci (i.e. 95)
% Optional output is the distribution F(x)
%  1.0 RKD 4/4/94
alpha=1.0-ci/100;
if ndof <= 120
% Use full expression for Chi^2 distribution
  rnu2=ndof/2.0;
  rnu21=rnu2-1;
  y1=1.0/((2^rnu2)*gamma(rnu2));
  xx=ndof*5;
  if xx >= 250
    xx = 250;
  end
  dx=xx/2500;
  dx2=dx/2.0;
  F=y1.*((dx2:dx:xx).^rnu21).*exp(-(dx2:dx:xx)./2.0);
  phi=ndof/(dx2+dx*(max(find(cumsum(F)*dx <= (alpha/2.0)))));
  plow=ndof/(dx2+dx*(min(find(cumsum(F)*dx >= (1.0-alpha/2.0)))));
else
  rnu2=120/2.0;
  rnu21=rnu2-1;
  y1=1.0/((2^rnu2)*gamma(rnu2));
  xx = 250;
  dx=xx/2500;
  dx2=dx/2.0;
  F=y1.*((dx2:dx:xx).^rnu21).*exp(-(dx2:dx:xx)./2.0);
  phi120=120/(dx2+dx*(max(find(cumsum(F)*dx <= (alpha/2.0)))));
% Use approximation given by Bendat&Piersol page 544
  xx=6;
  dx=xx/2500;
  dx2=dx/2;
  F=(1/sqrt(2*pi))*exp(-((dx2:dx:xx).^2)./2);
  zalpha=dx2+dx*(max(find(cumsum(F)*dx <= (1-alpha)/2)));
  dphi=phi120-(1-2/(9*120)+zalpha*sqrt(2/(9*120)))^3;
  phi=dphi+(1-2/(9*ndof)+zalpha*sqrt(2/(9*ndof)))^3;
  plow=(1-2/(9*ndof)+zalpha*sqrt(2/(9*ndof)))^(-3);
end
Fx=[F ; [dx2:dx:xx]];
%
