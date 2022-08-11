% Script to figure out World Bathy Variance
% Uses RP's M-tbase routine and the tbase.int dataset
% RKD 08/98
clear all
% set up world grid
dd=2; % size of grid (degrees)
longgrid=[0:dd/2:359];
latgrid=[-90+dd/2:dd/2:90-dd/2];
longmin=[longgrid-dd/2];longmax=longgrid+dd/2;
latmin=latgrid-dd/2;latmax=latgrid+dd/2;
% initialize bathyvariance matrix
bathyvar=ones(length(longgrid),length(latgrid))*NaN;
%
ntot=length(longgrid)*length(latgrid);
icnt=0;
for i=1:length(longgrid);  % loop through all longitude grids
   for j=1:length(latgrid);
      icnt=icnt+1;
      [elev,long,lat]=m_tbase([longmin(i) longmax(i) latmin(j) latmin(j)]);
      ie=length(elev);
      disp([num2str(icnt),'/',num2str(ntot),';  Long = ',num2str(longgrid(i)),'  Lat = ',num2str(latgrid(j))]);
      if ie > 0,
         if min(elev) < 0,
            bathyvar(i,j)=std(elev);
         end
      end
   end
end
bathyvar=bathyvar';
bv=log10(bathyvar);
save bathyvar longgrid latgrid bathyvar bv
% fini
