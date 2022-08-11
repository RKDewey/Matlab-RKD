function earthtop(az,el)
%EARTHTOP View Earth's topography
% earthtop(az,el) where az=rotation (lat) and el is elavation (long)
%	Copyright (c) 1984-94 by The MathWorks, Inc.

echo off
disp('The topography data used in this demo is available from')
disp('the National Geophysical Data Center, NOAA,')
disp('US Department of Commerce under data announcement 88-MGG-02.')
load topo
clf reset
colormap(topomap1)
[x,y,z] = sphere(24);
a = min(min(topo));
b = max(max(topo));
to = fix(64*(topo-a)/(b-a)+1);
to(find(to>64)) = 64;

labels = [
    '  2-D Contour  '
    '   2-D Image   '
    '3-D Pseudocolor'
    '     Done      '];

% Callbacks
s = str2mat(...
    'contour(-179:180,-89:90,topo,[0 0]),axis image,axis([-180 180 -90 90])', ...
    'image([-180 180],[-90 90],to), axis xy, axis image', ...
    ['cla,axis auto,surface(x,y,z,''FaceColor'',''texture'',''Cdata'',topo), ', ...
        'axis square,axis xy,axis off, view(az,el)'], ...
    'clf reset');

cs = 'point = get(gcf,''pointer'');set(gcf,''pointer'',''watch'');drawnow,';
ce = ';set(gcf,''pointer'',point),drawnow';

for n=1:size(labels,1)
	rect = [.025 .02 .23 .07];
	uicontrol('units','normal','position',rect+[(n-1)*.24 0 0 0],...
              'string',labels(n,:),'horiz','center','callback',[cs s(n,:) ce]);
end
axis off
text(.5,.5,'Select a view of the earth.','horiz','center');
