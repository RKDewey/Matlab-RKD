% script file to read MODM plume output file #.p#
% Pass ifile='mmddhhmm.pyy'
% Return MODM parameters
% RKD 8/98

if exist([ifile(1:8),'.mat'],'file'),
   eval(['load ',ifile(1:8),'.mat']);
else
fid=fopen(ifile,'r');
% read and plot the CO2 data
co2=fread(fid,99*99*10,'float32');
%
time=fread(fid,3,'float32');
nclouds=fread(fid,3,'int32');
nadd=fread(fid,1,'float32');
%
limits=fread(fid,4,'float32');
nsource=fread(fid,1,'int16');
slong=fread(fid,5,'float32');slat=fread(fid,5,'float32');sdep=fread(fid,5,'float32');
Q0=fread(fid,1,'float32');
I0=fread(fid,5,'int16');J0=fread(fid,5,'int16');K0=fread(fid,5,'int16');
volf=fread(fid,1,'float32');
[dxd,dyd]=fread(fid,2,'float32');
dxv=fread(fid,51,'float32');dyv=fread(fid,1,'float32');
dxc=fread(fid,99,'float32');dyc=fread(fid,1,'float32');
dt=fread(fid,1,'float32');
[xminu,yminu]=fread(fid,2,'float32');
xmaxu=fread(fid,51,'float32');ymaxu=fread(fid,1,'float32');
xminc=fread(fid,99,'float32');yminc=fread(fid,1,'float32');
xmaxc=fread(fid,99,'float32');ymaxc=fread(fid,1,'float32');
zim=fread(fid,11,'float32');zom=fread(fid,11,'float32');
coastl=fread(fid,[5000,2],'float32');
tkep=fread(fid,1,'float32');
[zpmin,zpmax]=fread(fid,2,'float32');conv=fread(fid,1,'float32');
sctit=char(fread(fid,10,'char'))';
fclose(fid);clear fid
eval(['save ',ifile(1:8)]);
end
%
co2=reshape(co2,99,99,10);
co2xy=sum(co2,3);
co2xy=flag2nan(co2xy,0);
z=flipud(fliplr(log10(co2xy))');
co2scale=[1.1:(4.5-1.1)/62:4.5];
xmind=limits(1);xmaxd=limits(2);ymind=limits(3);ymaxd=limits(4);
LONG=[xmind+0.25:0.25:xmaxd-0.25]-360;
LAT=[ymind+0.25:0.25:ymaxd-0.25];
%
cmap=colmap;
figure(1);clf;
m_proj('lambert','long',[xmind xmaxd]-360,'lat',[ymind ymaxd]);
[C,H]=m_contourf(LONG,LAT,z);
m_gshhs_l('patch',[1 1 1]);
m_grid('box','fancy');
%bwmap=colmap(46,2,1);
%colormap(flipud(bwmap));
colormap(cmap);
set(H(:),'LineWidth',[0.000001]);
title('CO_2 Concentrations');
ch=colorbar('vert');
cht=get(ch,'Title');
set(cht,'String','Log_{10}[\mu mol/kg]');
%
text(-.32,.26,['Lat =',num2str(slat(1)),'^oN'])
text(-.32,.24,['Long =',num2str(slong(1)),'^oW']);
text(-.32,.22,['Depth = ',num2str(sdep(1)),' m']);
text(-.32,.20,['TKE/MKE =',num2str(tkep,3)]);
text(-.32,.18,['Time:',num2str(time(3)),' days']);
text(-.32,.16,['Rate:',num2str(Q0(1)),' m/s^2']);
text(-.32,.14,ifile);
%
pltdat
% fini
