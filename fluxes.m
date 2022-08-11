function [grad1,grad2,flux1]=fluxes(z,t,s,d,ziw,eiw,Kiw,Ri);
% function [grad1,grad2,flux1]=fluxes(z,t,s,d,ziw,eiw,Kiw,Ri);
% Function to calculate vertical heat and salinity fluxes
% call iwdiss first to calculate Ri mSh eiw Kiw
% eiw is dissipation due to internal waves (iw)
% Kiw is vertical diffusivity due to iw.
% Hf Sf are heat and salt fluxes.
% grad1=[Tgr',Sgr',Dgr',zgr'];
% grad2=[Tg',Sg',Dg',ziw'];
% flux1=[Hf',Sf',Hfpp',Sfpp',Kpp',ziw'];
% RKD 3/96

% first filter slightly, take out spike gradients.
t=lpflt(t,1,(1/8));
s=lpflt(s,1,(1/8));
d=lpflt(d,1,(1/8));
m=length(z);
zgr=abs(z(2:m)+z(1:m-1))./2;
dz=abs(diff(z));
Tgr=-diff(t)./dz;
Sgr=-diff(s)./dz;
Dgr=-diff(d)./dz;
% smooth gradients one more time.
Tgr=lpflt(Tgr,1,(1/8));
Sgr=lpflt(Sgr,1,(1/8));
Dgr=lpflt(Dgr,1,(1/8));
%
% inri=find(Ri<0.25);
% eiw(inri)=ones(size(eiw(inri)))*NaN;
% Kiw(inri)=ones(size(Kiw(inri)))*NaN;
% Kpp is Pacanowski and Philander's parameterization of diffusivity
O=ones(size(Ri));
Kpp=((O*5e-3+1e-4*(O+5*Ri).^2)./((O+5*Ri).^3)) + O*1e-5;
m=length(ziw);
dz2=abs(mean(diff(ziw)))/2;
for i=1:m
 z1=ziw(i)-dz2;
 z2=ziw(i)+dz2; 
 avgz=0; avgt=0; 
 avgs=0; avgd=0; 
 ii=find(zgr >= z1 & zgr <= z2);
%
 if (sum(ii) > 0 & isnan(Ri(i)) == 0),
   Tg(i)=mean(Tgr(ii));
   Sg(i)=mean(Sgr(ii));
   Dg(i)=mean(Dgr(ii));
   % Heat flux in W/m^2: rho*Cp*K*(dT/dz), Cp=4.01e+3 [sw_cp(S,T,P)]
   Hf(i)=4.1*10^6*Tg(i)*Kiw(i); 
   Hfpp(i)=4.1*10^6*Tg(i)*Kpp(i);
% Salt flux in gm/s/m^2
   Sf(i)=1026*Sg(i)*Kiw(i);
   Sfpp(i)=1026*Sg(i)*Kpp(i);
 else
   Tg(i)=NaN;
   Sg(i)=NaN;
   Dg(i)=NaN;
   Hf(i)=NaN;
   Sf(i)=NaN;
   Hfpp(i)=NaN;
   Sfpp(i)=NaN;
 end
end
grad1=[Tgr',Sgr',Dgr',zgr'];
grad2=[Tg',Sg',Dg',ziw'];
flux1=[Hf',Sf',Hfpp',Sfpp',Kpp',ziw'];
%