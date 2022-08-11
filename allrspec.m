%
% Script file to plot all the spectra for a given adcp matrix.
%	Load ADCP data first, (U(i,j),V(i,j),z(j))
%     set zstop: maximum depth to process zstop=###m
%     set stnum: = station number, and
%     set dt: the sample rate in hours (i.e. dt=1/60)
%     set frange and prange: are log(#) frequency and power spectra ranges 
%     for plotting (if = [0 0] then calculate), 
%         ie frange=[-1 2], prange=[-2 2]
%       After return, rename plot file temp.ps
%  RKD 1.2 12/15/94

[m,n]=size(U);
mstop=min(find(z > zstop)) - 1;
nplts=m-mstop+1;
iplt=1;
itplt=1;
% calculate the spectra from 5 overlapping segments if # points > 1280 
% otherwise determine spectral length: if time series is long use 256, else 128
nps=5;
if (n/256) < nps
  if n > 256
     nps=fix(n/256)*2 - 1;
  else
     nps=1
  end
end
% Set up all the titles and text strings (i.e. time of plot)
xtx='Frequency (cph)';
ytx='Spectral Amplitude';
ttx(1:29)='Rotary Spectra ADCP: Station ';
ttx(30:31)=sprintf('%2.0f',stnum);
ttx(32:46)='  Depth =     m';
ttx2=[];
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

j=1;
% peal off a single vertical profile of u and v.
u=U(j,:);
v=V(j,:);
%
orient tall
subplot(2,2,iplt);
pltrspec(u,v,dt,nps,slope,frange,prange);
%
ttx(42:44)=sprintf('%3.0f',abs(z(j)));
title(ttx);xlabel(xtx);ylabel(ytx);
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
         print -dps d:\plots\temp.ps
       else
         print -dps -append d:\plots\temp.ps
       end
       clf;
       iplt=0;
    end
end
%
