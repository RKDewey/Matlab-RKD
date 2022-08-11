function pltbaths(theta0,bathy,depths,npts)
% function pltbaths(theta0,bathy,depths,npts)
% First call pltpolar/s with limits!
%  i.e. theta0=pltpolar(-999.,[76 84],[30 -50],'w')
% where long=[30 -50] is from 30W to 50E
% Then use pltbathy/s to plot GEOBEC bathymetry data in 
%  the northern/southern hemisphere after making longituds WEST
%  (i.e. bathy(:,2)=-bathy(:,2)
% Latitudes are south, and Longitudes are in degrees WEST
% Assumes data is in array bathy(#,2)
% data format is Z #, followed by # pairs of Lat Long
% haven't added contour labeling to southern routine yet....
% optional: npts sets the nunmber of data between contour labels
% RKD Dec 7 1995
%
if theta0 == [], error('Must first run pltpolar with limits');end
[n m]=size(bathy);
icnt=0;
iz=0;
icol=1;
ndep=1;
zcol=depths(1);
col=['wgycmrb';'-------']; 
[itot,jtot]=size(bathy);
while icnt < itot, 
   icnt=icnt+1;
   iz=iz+1;
   z(iz)=abs(bathy(icnt,1));
   nz(iz)=abs(bathy(icnt,2));
   if z(iz) ~= zcol,
      ndep=0;
      for i=1:max(length(depths)),
           if z(iz) == depths(i), ndep=i; end
      end
      if ndep ~= 0,  
	zcol = depths(ndep); 
	icol=icol+2; 
        if icol == 15, icol=1; end
      end
   end
   if ndep ~= 0,
     lat=bathy(icnt+1:icnt+nz(iz),1);
     long=bathy(icnt+1:icnt+nz(iz),2);
     lat0=lat(find(lat > theta0(2) & lat < theta0(3)... 
             & long > theta0(5) & long < theta0(4)));
     long0=long(find(lat > theta0(2) & lat < theta0(3)...
             & long > theta0(5) & long < theta0(4)));
     theta0=pltpolas(theta0,lat0,long0,col(icol:icol+1));
   end
   icnt=icnt+nz(iz);
end
%