function amp=pltfscat(theta,Pf,Pnf)
% function amp=pltfscat(theta,Pf,Pnf)
% Plots the forwward scatter function given Pf and Pnf
% at the angle theta
% RKD 1/97
%
rs=6.36;
ri=5.23;
rd=(rs+ri)*ones(size(theta));
t=(theta)*(pi/180);
rst=rs*(1./cos(t));
rirst=ri*ones(size(rst)) + rst;
%
i0=find(theta == 0);
Pd=abs(Pnf(i0,3));
f=200*1e3;
k=2*pi*f/1500;
i=sqrt(-1);
for j=1:4
  F(:,j)=((ri*rst)./rd).*(exp(-i*k*rd)./exp(-i*k*(rirst))).*(Pf(:,j)-Pnf(:,j));
end
amp=F;
for ii=1:length(theta)
  for j=1:4
      F1(ii,j)=((ri*rst(ii))/rd(ii)).*(abs(Pf(ii,j))/Pd);
end;end;
%
clf;orient tall
subplot(211);plot(theta',abs(F).^2);
xlabel('Angle(degrees)');
ylabel('|F|^2');
title('Forward Scatter Function')
%
subplot(212);plot(theta',10*log10(abs(F).^2));
xlabel('Angle(degrees)');
ylabel('10*log10(|F|^2) [dB]');
%
%subplot(313);plot(theta',F1);
%xlabel('Angle(degrees)');
%ylabel('F1');

% fini

