% script file to read 12 seasonal temperature fields and make a movie.
cd k:\temperat
M=moviein(12);
%
cd=fopen('temp01.obj');
T=fscanf(cd,'%8f',[360,180]);
fclose(cd);
Tn=flag2nan(T,-99.9999);
load d:\data\nodcaxes;
pltimage(Tn',xa,ya,[-3 30],xl,yl,1,1,1,'Longitude','Latitude',...
'Surface Temperature 1',2);
M(:,1) = getframe;
clf
%
cd=fopen('temp02.obj');
T=fscanf(cd,'%8f',[360,180]);
fclose(cd);
Tn=flag2nan(T,-99.9999);
pltimage(Tn',xa,ya,[-3 30],xl,yl,1,1,1,'Longitude','Latitude',...
'Surface Temperature 2',2);
M(:,2) = getframe;
%
cd=fopen('temp03.obj');
T=fscanf(cd,'%8f',[360,180]);
fclose(cd);
Tn=flag2nan(T,-99.9999);
pltimage(Tn',xa,ya,[-3 30],xl,yl,1,1,1,'Longitude','Latitude',...
'Surface Temperature 3',2);
M(:,3) = getframe;
%
cd=fopen('temp04.obj');
T=fscanf(cd,'%8f',[360,180]);
fclose(cd);
Tn=flag2nan(T,-99.9999);
pltimage(Tn',xa,ya,[-3 30],xl,yl,1,1,1,'Longitude','Latitude',...
'Surface Temperature 4',2);
M(:,4) = getframe;
%
cd=fopen('temp05.obj');
T=fscanf(cd,'%8f',[360,180]);
fclose(cd);
Tn=flag2nan(T,-99.9999);
pltimage(Tn',xa,ya,[-3 30],xl,yl,1,1,1,'Longitude','Latitude',...
'Surface Temperature 5',2);
M(:,5) = getframe;
%
cd=fopen('temp06.obj');
T=fscanf(cd,'%8f',[360,180]);
fclose(cd);
Tn=flag2nan(T,-99.9999);
pltimage(Tn',xa,ya,[-3 30],xl,yl,1,1,1,'Longitude','Latitude',...
'Surface Temperature 6',2);
M(:,6) = getframe;
%
cd=fopen('temp07.obj');
T=fscanf(cd,'%8f',[360,180]);
fclose(cd);
Tn=flag2nan(T,-99.9999);
pltimage(Tn',xa,ya,[-3 30],xl,yl,1,1,1,'Longitude','Latitude',...
'Surface Temperature 7',2);
M(:,7) = getframe;
%
cd=fopen('temp08.obj');
T=fscanf(cd,'%8f',[360,180]);
fclose(cd);
Tn=flag2nan(T,-99.9999);
pltimage(Tn',xa,ya,[-3 30],xl,yl,1,1,1,'Longitude','Latitude',...
'Surface Temperature 8',2);
M(:,8) = getframe;
%
cd=fopen('temp09.obj');
T=fscanf(cd,'%8f',[360,180]);
fclose(cd);
Tn=flag2nan(T,-99.9999);
pltimage(Tn',xa,ya,[-3 30],xl,yl,1,1,1,'Longitude','Latitude',...
'Surface Temperature 9',2);
M(:,9) = getframe;
%
cd=fopen('temp10.obj');
T=fscanf(cd,'%8f',[360,180]);
fclose(cd);
Tn=flag2nan(T,-99.9999);
pltimage(Tn',xa,ya,[-3 30],xl,yl,1,1,1,'Longitude','Latitude',...
'Surface Temperature 10',2);
M(:,10) = getframe;
%
cd=fopen('temp11.obj');
T=fscanf(cd,'%8f',[360,180]);
fclose(cd);
Tn=flag2nan(T,-99.9999);
pltimage(Tn',xa,ya,[-3 30],xl,yl,1,1,1,'Longitude','Latitude',...
'Surface Temperature 11',2);
M(:,11) = getframe;
%
cd=fopen('temp12.obj');
T=fscanf(cd,'%8f',[360,180]);
fclose(cd);
Tn=flag2nan(T,-99.9999);
pltimage(Tn',xa,ya,[-3 30],xl,yl,1,1,1,'Longitude','Latitude',...
'Surface Temperature 12',2);
M(:,12) = getframe;
%
save d:\data\tempmovi M
%
clear all