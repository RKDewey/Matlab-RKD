% script file to estimate angle error in shipboasrd ADCP
% load adcpdata (Atim,Shnw,Shew)
% load navjdf## (jd,lat,long)
% Note: GPS does need declination correction (19.65E in 1996)
% 1.0 RKD 11/97
[jd,I]=sort(jd);lat=lat(I);long=long(I); % sort if nav out of order
[us,vs,latuv,longuv,timuv]=shipspeed(lat,long,jd);
%
time=fix(jd(1)) + [0:1/60:24]/24;
[us,tim1]=binavg(us,timuv,time);
[vs,tim1]=binavg(vs,timuv,time);
%
[us,tim]=cleanx(us,tim1);
[vs,tim]=cleanx(vs,tim1);
%
[shns,tim1]=binavg(-Shns/100,Atim,time);
[shew,tim1]=binavg(-Shew/100,Atim,time);
%
%[shns,timns]=cleanx(-Shns/100,Atim);
%[shew,timew]=cleanx(-Shew/100,Atim);
%
[shew,shns]=vrotate(shew,shns,19.65); % correct for declination
%
figure(1);plot(tim,vs,'b',tim1,shns,'g');
figure(2);plot(tim,us,'b',tim1,shew,'g');
timst=input('Enter the start and end times to use: ts=');
timend=input(' te=');
itim=find(tim>=timst & tim<=timend);
tim=tim(itim);us=us(itim);vs=vs(itim);
itim1=find(tim1>=timst & tim1<=timend);
tim1=tim1(itim1);shew=shew(itim1);shns=shns(itim1);
%
if length(tim) < length(tim1),
   [shns,tim2]=binavg(shns,tim1,tim);
   [shew,tim2]=binavg(shew,tim1,tim);
   tim1=tim2;
end
if length(tim) > length(tim1),
   [vs,tim2]=binavg(vs,tim,tim1);
   [us,tim2]=binavg(us,tim,tim1);
   tim=tim2;
end

[lata,timnav]=binavg(latuv,timuv,tim);
[longa,timnav]=binavg(longuv,timuv,tim);
figure(3);jdfcoast1;plot(longa,lata,'r');
tima=tim;
%
ins=~isnan(shns);
iew=~isnan(shew);
shns1=shns(ins); % exclude NaNs from angle estimation.
shew1=shew(iew);
%
dxs=sum(us);dys=sum(vs);
dxa=sum(shew1);dya=sum(shns1);
figure(5);plot([0 dxs],[0 dys],'b',[0 dxa],[0 dya],'r');
[mags,angs]=vector(dxs,dys,0);
[maga,anga]=vector(dxa,dya,0);
ca=(anga-angs)*180/pi;
%
[shewr,shnsr]=vrotate(shew,shns,ca);
figure(1);plot(tim,vs,'b',tim1,shns,'g',tim1,shnsr,'r');
figure(2);plot(tim,us,'b',tim1,shew,'g',tim1,shewr,'r');
%figure(4);compass([stats(us) stats(shew) stats(shewr)],[stats(vs) stats(shns) stats(shnsr)]);
%
[m,n]=size(U);
mask=ones(m,n);
for i=1:n
   ib=find(z>=avbdpth(i));
   mask(ib,i)=ones(length(ib),1)*NaN;
end
[u,v]=vrotate(U.*mask,V.*mask,19.65-23.0+ca); % correct for mag dec, channel and offset
[ua,tima]=binavg(u,Atim,tim1);
[va,tima]=binavg(v,Atim,tim1);
figure(4);compass(ua(20,:),va(20,:),'r');hold on
[u,v]=vrotate(U.*mask,V.*mask,19.65-23.0); % correct for mag dec and channel axis
[ua,tima]=binavg(u,Atim,tim1);
[va,tima]=binavg(v,Atim,tim1);
figure(4);compass(ua(20,:),va(20,:));hold off
%
[wdepth,tim]=binavg(avbdpth,Atim,tim1);
%
clear dxs dxa mags maga angs anga time timeuv latuv longuv n m i ib tim0
clear tim2 ins iew dys dya shew1 shns1 us1 vs1 indx indxn tim1 tim timnav
%
save adcprotated lata longa tima shewr shnsr ua va us vs wdepth z ca
clear all
load adcprotated
% fini