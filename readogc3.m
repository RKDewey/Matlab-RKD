% script to read a single slab from OGCM ifile into matrix CO2(72,144)
% and plot it using image.
% RKD 5/25/94
load d:\data\epri\ogcmaxes
%orient tall
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
%colormap(gray);
%colormap(jet);
uvcol=uvcmap(64);
uvcol(60,:)=[0.8 0 0];
colormap(uvcol);
%map=colormap;
%colormap(flipud(map));
for islab=1:inum
  fseek(io,4,'cof');
  [x,cnt]=fread(io,[144,72],'float');
  fseek(io,4,'cof');
  if(islab == inum)
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
      subplot(1.25,1,1)
      text1='Log(CO2)  Depth=     m'; 
      text1(18:21)=sprintf('%4.0f',depths(islab));
      image(xlong,ylat,fliplr(flipud(co2)));
      title(text1),xlabel('Longitude (W)'),ylabel('Latitude');
      pltdat;
      subplot(15,1.5,22.26)
      image(xscal,yscal,scal);
      xlabel('Log10 CO2 Concentration')
      set(gca,'YTickLabels',[]);
      text(0.2,0.2,filename);
      h=get(gca,'Children');
      set(h(1),'FontSize',8,'Units','normalized','Position',[1.1 0.0]);
  end
end
fclose(io);
