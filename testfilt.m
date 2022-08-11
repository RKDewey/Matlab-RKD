function testfilt(ff,ft);
% function testfilt(ff,ft);
% plot and test the filter response of sinc
% pass the filter (sinc) freq i.e. ff=1.2
% and the filter length (time) i.e. ft=4
%  RKD 3/97

dt=16*pi/1024;
t=(dt:dt:16*pi);
t2=(-ft/2:dt:ft/2);
flt1=sinc(2*pi*ff*t2);flt1=flt1./sum(flt1);figure(1);plot(flt1)
x=3*sin(2*pi*3*t) + 5*sin(2*pi*6*t);
figure(2);plot(t(1:2*length(t2)),x(1:2*length(t2)),t2+t2(length(t2)),flt1*20)
y=filter(flt1,1,x);
figure(3);plot(t(1:100),x(1:100),t(1:100),y(1:100));
[psx,fx]=ps(x,dt);
[psy,fy]=ps(y,dt);
[psf,ff]=psd(flt1,64);  % use psd, since present ps doesn't work on small x
figure(4);loglog(fx,psx,fy,psy,ff/(dt*2),psf*2*dt);
%