%
% Script file to plot all the spectra for a given adcp matrix.
%	Load workspace first, determine maximum depth index=mstop (26)
%       set stnum = station number, and
%	frange and prange (if = [0 0] then calculate)
%       After return, rename plot file d:\plots\temp.hp
[m,n]=size(U);
nplts=m-mstop+1;
iplt=1;
itplt=1;
dt=1/60.0;
% determine spectral length. If time series is long use 256, or 128
if n > 256
   nps=fix(n/256)*2 - 1;
else
   nps=fix(n/128)*2 - 1;
end
j=m;
% peal off a single vertical profile of u and v.
u=U(j,:);
v=V(j,:);
%
orient tall
subplot(2,2,iplt);
pltrspec(u,v,dt,nps,slope,frange,prange);
%
xtx='Frequency (cph)';
ytx='Spectral Amplitude';
ttx(1:29)='Rotary Spectra ADCP: Station ';
ttx(30:31)=sprintf('%2.0f',stnum);
ttx(32:46)='  Depth =     m';
ttx(42:44)=sprintf('%3.0f',abs(ya(j)));
title(ttx);xlabel(xtx);ylabel(ytx);
clear ttx2;
ttx2(1:2)=sprintf('%2.0f',hdr(1,3));
ttx2(3)='/';
ttx2(4:5)=sprintf('%2.0f',hdr(1,4));
ttx2(6)='/';
ttx2(7:8)=sprintf('%2.0f',hdr(1,2));
ttx2(9)=' ';
ttx2(10:11)=sprintf('%2.0f',fix(hdr(1,5)/10000));
ttx2(12)=':';
stmin=(fix(hdr(1,5)/100)-(fix(hdr(1,5)/10000)*100));
if stmin < 10
   ttx2(13)='0';
   ttx2(14)=sprintf('%1.0f',stmin);
else
   ttx2(13:14)=sprintf('%2.0f',stmin);
end
ttx2(15)='-';
ttx2(16:17)=sprintf('%2.0f',hdr(n,3));
ttx2(18)='/';
ttx2(19:20)=sprintf('%2.0f',hdr(n,4));
ttx2(21)='/';
ttx2(22:23)=sprintf('%2.0f',hdr(n,2));
ttx2(24)=' ';
ttx2(25:26)=sprintf('%2.0f',fix(hdr(n,5)/10000));
ttx2(27)=':';
enmin=(fix(hdr(n,5)/100)-(fix(hdr(n,5)/10000)*100));
if enmin < 10
   ttx2(28)='0';
   ttx2(29)=sprintf('%1.0f',enmin);
else
   ttx2(28:29)=sprintf('%2.0f',enmin);
end
ttx2x=10^(frange(1)+1.2);
ttx2y=10^(prange(1)+0.1);
text(ttx2x,ttx2y,ttx2);
h=get(gca,'Children');
set(h(1),'FontSize',8);
% print -dps d:\plots\temp.ps
ipplt=0;
%
for j=m-1:-1:mstop
    iplt=iplt+1;
    itplt=itplt+1;
    u=U(j,:);
    v=V(j,:);
    subplot(2,2,iplt);
    pltrspec(u,v,dt,nps,slope,frange,prange);
    ttx(42:44)=sprintf('%3.0f',abs(ya(j)));
    title(ttx);xlabel(xtx);ylabel(ytx);
    text(ttx2x,ttx2y,ttx2);
    h=get(gca,'Children');
    set(h(1),'FontSize',8);
    if iplt == 4 | itplt == nplts
       ipplt=ipplt+1;
       if ipplt == 1
         print -dps -append d:\plots\temp.ps
       else
         print -dps -append d:\plots\temp.ps
       end
       clf;
       iplt=0;
    end
end
%
