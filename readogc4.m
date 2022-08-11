% script to read a multiple slabs from 1995 OGCM ifile into matrix CO2(72,144)
% and plot them using image.
% plotslab(4) are the numbers of the slabs to plot (e.g. 1,4,8,12)
% nfile is now the array number (1-14) for years:
%       10,20,40,60,80,100,150,200,250,300,350,400,450,500
% ifile='filename'
% brite = power to set map when colormap=gray and igray=1
% 
% RKD 5/25/94
tmax=-4;
tmin=-16;
scal=[1,(1:60)];
xscal=tmin + (1:60)*((tmax-tmin)/60);
yscal=0;
%
io=fopen(ifile,'r','b');
%
% Skip nfile-1 arrays
%
if nfile > 1,
   for nskip=1:(nfile-1),
       fseek(io,4,'cof');
       [header,cnt]=fread(io,[1,33],'float');
       fseek(io,4,'cof');
       for islab=1:15
           fseek(io,4,'cof');
           [x,cnt]=fread(io,[144,72],'float');
           fseek(io,4,'cof');
       end
       nskip
   end
end
% read header of desired array (time)
fseek(io,4,'cof');
[header,cnt]=fread(io,[1,33],'float');
fseek(io,4,'cof');
%
orient tall
set(gcf,'paperposition',[0.0 3.44 21.5 20.0]./2.54)
%
if igray == 1,
   colormap(gray);
   if brite ~= 0.0, brighten(brite), end
   map=colormap;
   map=1-map;
   colormap(map);
else
   uvcol=uvcmap(64);
   uvcol(60,:)=[0.8 0 0];
   colormap(uvcol);
end
%
iplt=1;
for islab=1:pltslab(4);
    fseek(io,4,'cof');
    [x,cnt]=fread(io,[144,72],'float');
    fseek(io,4,'cof');
    if islab == pltslab(iplt),
       for j=1:144, for i=1:72
           if x(j,i) == 1e6, x(j,i) = NaN; end
           if x(j,i) < 10.0^tmin, x(j,i) = 10.0^tmin; end
       end,end
       [xmin xmax]=minmax(x);
       co2=log10(x);
       co2=((co2'-tmin)./(tmax-tmin))*60;
       for j=1:72, for i=1:144
           if isnan(co2(j,i)) == 1, co2(j,i) = 65; end
       end, end
       subplot1(2.5,2,iplt,1.,1.,1.,1.1)
       text1='Log(CO2)  Depth=     m'; 
       text1(18:21)=sprintf('%4.0f',depths(islab));
       image(xlong,ylat,fliplr(co2));
       title(text1),xlabel('Longitude (W)'),ylabel('Latitude');
       if iplt == 4;
          subplot(15,1.5,22.26)
          image(xscal,yscal,scal);
          xlabel('Log10 CO2 Concentration')
          set(gca,'YTickLabels',[]);
	  tit(filename);
%         if igray == 0,
%            print -dpsc d:\plots\temp.psc
%         else
%	     print -dps d:\plots\temp.ps
%         end
	  pltdat;
        end
        iplt=iplt+1;
  end
end
fclose(io);
%