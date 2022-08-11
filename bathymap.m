function h=bathymap(proj,longlim,latlim,origin,icol);
% function h=bathymap(proj,longlim,latlim,origin,icol)
% 
% Plot the tbase bathymetry
% Inputs:	proj='ortho' or other projection (default='braun')
% 				longlim=[west|east east|west]  default=[-180 180]
%				latlim=[south|north north|south]  default=[-80 80]
%				origin=[lat long orient]  default=[0 0 0]
%           icol=0 (default MATLAB colormap)
%				     1 Dewey's colour colmap(64,1)
%					  2 Dewey's B&W colmap(64,1,2)
%
% To set Origin (centre on Ortho) use setm(h,'Origin',[48 -127 0])
% RKD 11/98
if nargin < 1, proj='braun'; end
if nargin < 3, longlim=[-180 180];latlim=[-90 90]; end
if nargin < 4, origin=[0 0 0]; end
if nargin < 5, icol=0; end
figure(1);clf
dg=[1 2 5 10 15 20 30 45];
%if max(longlim) > 360; longlim=longlim-360; end
dgp=max(dg(find(dg<((max(latlim)-min(latlim))/5))));
dgm=max(dg(find(dg<((max(longlim)-min(longlim))/5))));
[map,mapl]=tbase(ceil(max([dgp dgm])/5),latlim,longlim);
h=axesm('MapProjection',proj,...
   'MapLatLimit',latlim,'MapLonLimit',longlim,...
   'MLabelLocation',dgm,'MLineLocation',dgm,...
   'PLabelLocation',dgp,'PLineLocation',dgp,...
   'MLabelParallel','south',...
   'GLineStyle','-');
meshm(map,mapl);demcmap(map);
framem;gridm;mlabel;plabel;
axis off
% fini
