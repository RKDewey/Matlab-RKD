function pltbathy(theta0,bathy,depths,npts)
% function pltbathy(theta0,bathy,depths,npts)
% First call pltpolar/s with limits!
%  i.e. theta0=pltpolar(-999.,[76 84],[80 160],'k')
%      theta0=[(90+(mid long))*pi/180,lat min,lat max,long min,long max]
% Then use pltbathy/s to plot GEOBEC bathymetry data in 
%  the northern/southern hemisphere.
% Latitudes are degrees north, and Longitudes are in degrees EAST
% Assumes data is in array bathy(#,2)
% data format is Z #, followed by # pairs of Lat Long
% e.g. depths=[0,50,100,200,500,1000,2000,4000]
% Optional: npts is the length of each line segment before 
%           a contour label is plotted. Default = 20
% RKD Dec 7 1995
%
if isempty(theta0), error('Must first run pltpolar with limits');end
if nargin == 3, npts=20; end
[n m]=size(bathy);
dlat=abs(theta0(3)-theta0(2));
dlong=abs(theta0(5)-theta0(4));
icnt=0;
iz=0;
icol=1;
ndep=1;
zcol=depths(1);
col=['kgycmrb';'-------'];
[itot,jtot]=size(bathy);
while icnt < itot, 
   icnt=icnt+1;
   iz=iz+1;
   z(iz)=bathy(icnt,1);
   nz(iz)=bathy(icnt,2);
   if z(iz) ~= zcol,
      ndep=0;
      for i=1:max(length(depths)),
           if z(iz) == depths(i), ndep=i; end
      end
      if ndep ~= 0,  
    	  zcol = depths(ndep); 
	     icol=icol+2; 
        if icol >= 15, icol=1; end
      end
   end
   if ndep ~= 0,
     lat=bathy(icnt+1:icnt+nz(iz),1);
     long=bathy(icnt+1:icnt+nz(iz),2);
     theta0=pltpolar(theta0,lat,long,col(icol:icol+1));
     idx=find(lat > theta0(2) & lat < theta0(3)... 
            & long > theta0(4) & long < theta0(5));
     lat0=lat(idx);
     long0=long(idx);
     nz2=length(lat);
     if abs(z(iz)) > 10 & length(lat0) > npts, % then potential isobath for labeling
        LL=fix(length(lat0)*0.5);
        if length(lat0) > 4*npts, LL=fix(length(lat0).*[0.1 0.5 0.9]); end % 3 lables
        for L=LL
        if (((lat0(L)-theta0(2))>(0.05*dlat)) & ...   % contour must be
            ((theta0(3)-lat0(L))>(0.05*dlat)) & ...   % at least 5% away from
            ((long0(L)-theta0(4))>(0.05*dlong)) & ...  % the border of the plot
            ((theta0(5)-long0(L))>(0.05*dlong))) & ... % sides and top/bottom
           ((nz2 > npts) | ...    % and at least npts points long, or ..
           ((max(lat0)-min(lat0))>(0.05*dlat)) | ...    % physically a long line, if all this
           ((max(long0)-min(long0))>(0.05*dlong))),     % then label this bathy contour
        latm=[lat0(L-2) lat0(L) lat0(L+2)];
        longm=[long0(L-2) long0(L) long0(L+2)];
        indx=find(latm > theta0(2) & latm < theta0(3)... 
             & longm > theta0(4) & longm < theta0(5));
        if length(indx) == 3, % then line segment is in plot domain
        [rho0 hdg0]=gcdis(89.98*ones(size(latm)),longm,latm,longm);
        x0=rho0.*cos(((longm*pi/180.0)-theta0(1)));
        y0=rho0.*sin(((longm*pi/180.0)-theta0(1)));
        [mag,ang]=vector((x0(3)-x0(1)),(y0(3)-y0(1)),0);
        if ang > pi/2, ang=ang-pi; end  % orient labels always down
        if ang < -pi/2, ang=ang+pi; end
        if ~exist('bgcol'), % set up blanking boxes
           numb=8; % dummy nimbers, 80 800 8000, to set digit sizes
           for ibt=1:4
              numb=numb*10;
              h=text(x0(2),y0(2),num2str(numb,'%5.0f'));
              set(h,'FontSize',6);
              tpb=get(h,'Extent');
              set(h,'Visible','off');
              tp(ibt,:)=tpb; 
              tp(ibt,4)=tp(ibt,4)/2; % reduce the box height a bit

           end
           bgcol=get(gcf,'Color');  % get the plot's background color
        end
        ibt=floor(log10(abs(z(iz))))+1;  % determine the number of digits in isobath
        xb1=x0(2) - cos(ang)*tp(ibt,3)/2 + sin(ang)*tp(ibt,4)/2; % set up blanking box
        xb2=xb1 + cos(ang)*tp(ibt,3);
        xb3=xb2 - sin(ang)*tp(ibt,4);
        xb4=xb1 - sin(ang)*tp(ibt,4);
        yb1=y0(2) - sin(ang)*tp(ibt,3)/2 - cos(ang)*tp(ibt,4)/2;
        yb2=yb1 + sin(ang)*tp(ibt,3);
        yb3=yb2 + cos(ang)*tp(ibt,4);
        yb4=yb1 + cos(ang)*tp(ibt,4);
        p=fill([xb1 xb2 xb3 xb4],[yb1 yb2 yb3 yb4],bgcol);  % blank out background
        set(p,'EdgeColor',bgcol);
        h=text(x0(2),y0(2),num2str(z(iz),'%5.0f'));  % write number in blank space
        set(h,'HorizontalAlignment','center');
        set(h,'Rotation',ang*(180/pi),'FontSize',6);
        end
        end
     end
     end
     if z(iz) == 0,
        filpolar(theta0,lat,long,'k');  % if it's an island/land, fill it black
     end
   end
   icnt=icnt+nz(iz);
end
%