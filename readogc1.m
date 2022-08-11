% script to read a slab from OGCM ifile into matrix CO2(72,144)
% RKD 5/25/94
load d:\data\epri\ogcmaxes
orient tall
tmax=-5;
tmin=-15;
scal=[1,(1:60)];
xscal=tmin + (1:60)*((tmax-tmin)/60);
yscal=0;
%
  io=fopen(ifile,'r','b');
  fseek(io,4,'cof');
  [header,cnt]=fread(io,[1,22],'float');
  fseek(io,4,'cof');
%
colormap(gray);
%colormap(jet);
map=colormap;
colormap(flipud(map));
iplt=0;
for islab=1:inum
  fseek(io,4,'cof');
  [x,cnt]=fread(io,[144,72],'float');
  fseek(io,4,'cof');
  for j=1:144, for i=1:72
   if x(j,i) == 1e6, x(j,i) = NaN; end
   if x(j,i) < 1e-15, x(j,i) = 1e-15; end
  end,end
  [xmin xmax]=minmax(x);
  co2=log10(x);
  co2=((flipud(co2')-tmin)./(tmax-tmin))*60;
  for j=1:72, for i=1:144
      if isnan(co2(j,i)) == 1, co2(j,i) = 65; end
  end, end
  iplt=iplt+1;
  subplot(3,2,iplt)
  text1='Log(CO2)  Depth=     m'; 
  text1(18:21)=sprintf('%4.0f',depths(islab));
  image(xlong,ylat,fliplr(flipud(co2)));
  title(text1),xlabel('Longitude (W)'),ylabel('Latitude');
  if iplt == 4 | islab == inum
      subplot(15,1.5,16.26)
      image(xscal,yscal,scal);
      xlabel('Log10 CO2 Concentration')
      set(gca,'YTickLabels',[]);
      pltdat;
      text(0.2,0.2,filename);
      h=get(gca,'Children');
      set(h(1),'FontSize',8,'Units','normalized','Position',[1.1 0.0]);
      iplt = 0; 
  end
end
fclose(io);
