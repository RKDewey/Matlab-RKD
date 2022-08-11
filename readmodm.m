function readmodm(ifile,icol,newlim,spmnp)
% function readmodm(ifile,icol,newlim,[m,n,p])
% function to read and plot MODM plume output file #.p#
% Pass ifile='mmddhhmm.pyy'
% Optional: icol = 1 for color, 0 for B&W
%				plot domain newlim=[longmin longmax latmin latmax]
%           subplot [m,n,p], if passed (any values) then no text
% Uses Rich P's M_Map routines.
% Return MODM parameters
% RKD 8/98

if exist([ifile(1:8),'.mat'],'file'),
   eval(['load ',ifile(1:8),'.mat']);
else
   save temp
   clear newlim spmnp % don't save these in the CO2 mat file
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
   slong=fread(fid,5,'float32');
   slat=fread(fid,5,'float32');
   sdep=fread(fid,5,'float32');
	Q0=fread(fid,1,'float32');
   I0=fread(fid,5,'int16');
   J0=fread(fid,5,'int16');
   K0=fread(fid,5,'int16');
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
   load temp
end
%
txt=0;
if nargin < 2, icol=1; end
if nargin < 3, newlim=[]; end
if nargin < 4, 
   txt=1;
   mp=1;np=1;pp=1;
else
   mp=spmnp(1);np=spmnp(2)+0.2;pp=spmnp(3);
   ax=subplot(mp,np,pp);
   axp=get(ax,'Position');
end
%
co2=reshape(co2,99,99,10);
co2xy=sum(co2,3);
co2xy=flag2nan(co2xy,0);
z=flipud(fliplr(log10(co2xy))');
xmind=limits(1);xmaxd=limits(2);ymind=limits(3);ymaxd=limits(4);
LONG=[xmind+0.25:0.25:xmaxd-0.25]-360;
LAT=[ymind+0.25:0.25:ymaxd-0.25];
if ~isempty(newlim),
   xmind=newlim(1);xmaxd=newlim(2);ymind=newlim(3);ymaxd=newlim(4);
end
%
if icol==1,
   dv=0.1;
   v=[1:dv:4.6];
   cmap=colmap(length(v)+1,1);
 else
   dv=0.2;
   v=[1:dv:4.6];
   cmap=flipud(colmap(length(v)+1,1,1));
end
disp(['Length of color map is ',num2str(length(v)+2)]);
if pp==1, figure(1);clf; end

m_proj('lambert','long',[xmind xmaxd]-360,'lat',[ymind ymaxd]);
m_gshhs_l('patch',[1 1 1]);
m_grid('box','fancy');
hold on
[C,H]=m_contourf(LONG,LAT,z,v);
set(H(:),'LineStyle','none');
axp=get(gca,'Position');
colormap(cmap);
title('CO_2 Concentrations');
if mod(pp,floor(np))==0,
   if txt==0,
      ch=colorbar('vert');
      set(ch,'Position',[axp(1)+axp(3)+0.05 axp(2)+axp(4)*0.25 0.05 axp(4)*0.5]);
   else
      ch=colorbar('vert');
   end
	cht=get(ch,'Title');
   set(cht,'String','Log_{10}[\mu mol/kg]');
end
if txt==0,
   set(ax,'Position',axp);
   alphab=['(a)';'(b)';'(c)';'(d)';'(e)';'(f)';'(g)';'(h)'];
   text(-0.15,-0.15,alphab(pp,:),'Units','normalized');
end % reset axis position
%
if txt==1,
	text(-.32,.26,['Lat = ',num2str(slat(1)),'^oN'])
	text(-.32,.24,['Long = ',num2str(slong(1)),'^oE']);
	text(-.32,.22,['Depth = ',num2str(sdep(1)),' m']);
	text(-.32,.20,['TKE/MKE = ',num2str(tkep)]);
	text(-.32,.18,['Time: ',num2str(time(3)),' days']);
	text(-.32,.16,['Rate: ',num2str(Q0(1)),' m/s^2']);
   text(-.32,.14,ifile);
end
%
%if pp==mp*floor(np), pltdat; end
% fini
