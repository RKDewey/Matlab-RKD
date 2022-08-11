function [eps1,eps2,ze]=epsilon(shear,zs,T,z,zbin,thd,asci,iplt)
% function epsilon(shear,zs,T,z,zbin,thd,asci,iplt)
% plots (if iplt exists) the zbin (2 m) sectioned power spectrum 
% of the shear. Despikes with thd (=0.2-0.5).
% Calculates the dissipation rate [W/m^3] by integrating the ps
% between 1 and 50 Hz. Presently no corrections.
% shear=[shear1 shear2] to plot both channels.
% Run reademux(ifile='demux0001.txt'), chunk and roughe first
% RKD 4/97
v=visc(T);
%
z1=ceil(z(1));  % top of bin averaged data
z2=floor(z(length(z)));  % bottom of bin averaged data
%
[m,n]=size(shear);
if n > 1,
   shear1=shear(:,1);
   shear2=shear(:,2);
   twoshs=1;
else
   shear1=shear;
   twoshs=0;
end
shear1=despike(shear1,thd);  % don't plot, otherwise ..,iplt)
if twoshs, shear2=despike(shear2,thd); end
%
if zbin >= 1, 
   nfft=256;
else
   nfft=128;
end
Nfft=min(find([(1:50)*256]>zbin*nfft));
N=Nfft*nfft;
N2=fix(N/2);
iz=0;
for zb=z1:zbin/2:z2-zbin,
   iz=iz+1;
   ze(iz)=zb+zbin/2;
   zbin2=zb+zbin;  % 1 metre bins
   indxs=fix(mean(find(zs >= zb & zs <= zbin2)));
   if (indxs-N2) < 1, indxs=N2+1; end
   if (indxs+N2-1) > length(shear1), indxs=length(shear1)-N2; end
   indxs=[indxs-N2:indxs+N2-1];
   length(indxs);
   indxv=find(z >= zb & z <= zbin2);
   [ps1,f1]=ps(shear1(indxs),(0.9043/248),nfft);
   df=f1(1);
   fu=min(find(f1>50));
   fl=min(find(f1>1));
   variance=sum(ps1(fl:fu))*df;  % integrate power spectrum from 1 to 50 Hz
   viscosity=mean(v(indxv));
   eps1(iz)=7.5*viscosity*variance;
   if twoshs,
      [ps2,f1]=ps(shear2(indxs),(0.9043/248),nfft);
      variance=sum(ps2(fl:fu))*df;  % integrate power spectrum from 5 to 50 Hz
      eps2(iz)=7.5*viscosity*variance;
   end
   if exist('iplt'),  % if iplt == 1 then flash-plot each spectra
     PSn=2e-6+((1/sqrt(2*pi))*exp(-0.5*((f1-63)/3).^2))*(1.5e-4)/0.4;
     ps=ps1-PSn;
     indx=find(ps < 1e-6);ps(indx)=1e-6*ones(size(ps(indx)));
     figure(2);clf;loglog(f1,ps1,f1,ps,f1,PSn);
     axis([0.5 200 1e-6 1e-1]);
     depth=[num2str(zb) ' - ' num2str(zbin2)];
     title(depth);
     xlabel('Frequency [Hz]');ylabel('Spectral Amplitude');
     pause(0.1)
   end
end
mp=1; np=3;
figure(1);clf;
subplot(mp,np,1);plot(T,-z);grid;
axis([6 12 -z2 0]);
YTickL=get(gca,'YtickLabel');
[ym,yn]=size(YTickL);YTickL(1:ym-1,1:yn-1)=YTickL(1:ym-1,2:yn);
YTickL=YTickL(:,1:yn-1);
set(gca,'YTickLabel',YTickL); % set depth labels positive
xlabel('Temperature [C]');
ylabel('Depth [m]');
title(asci(3:14));
if twoshs,
   subplot(mp,np,2);plot(shear1-3,-zs,shear2+3,-zs);
   xlabel('Shear [s^{-1}]');
else
   subplot(mp,np,2);plot(shear1,-zs);
   xlabel('Shears 1 and 2 [s^{-1}]');
end
axis([-8 8 -z2 0]);
YTickL=get(gca,'YtickLabel');
[ym,yn]=size(YTickL);YTickL(1:ym-1,1:yn-1)=YTickL(1:ym-1,2:yn);
YTickL=YTickL(:,1:yn-1);
set(gca,'YTickLabel',YTickL); % set depth labels positive
ylabel('Depth [m]');
title(asci(29:48));
if twoshs,
   h=subplot(mp,np,3);semilogx(eps1,-ze,eps2,-ze)
else
   h=subplot(mp,np,3);semilogx(eps1,-ze);
end
set(h,'LineWidth',1.0);
axis([5e-6 1e-1 -z2 0]);grid;
YTickL=get(gca,'YtickLabel');
[ym,yn]=size(YTickL);YTickL(1:ym-1,1:yn-1)=YTickL(1:ym-1,2:yn);
YTickL=YTickL(:,1:yn-1);
set(gca,'YTickLabel',YTickL); % set depth labels positive
set(gca,'XTick',[1e-5 1e-4 1e-3 1e-2 1e-1],'XTickLabel',['-5';'-4';'-3';'-2';'-1']);
xlabel('Dissipation Rate [W/m^3]');
ylabel('Depth [m]');
title('Log(Epsilon) [W/m^3]')
%
pltdat; drawnow
% fini
