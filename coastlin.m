function coastline(elon,linetype)
%  function coastline(elon,linetype)
%
%  Script tool to plot world coastline on current plot if there is one.
%  Otherwise, it draws a world plot.  Data come coastline.dat (coarse).
%
%  elon=0 for longitude axis -180 to 180
%  elon=1 for longitude axis 0 to 360
%  linetype '-w' default if not specified

%  15 Dec 1993  G.Lagerloef

if elon~=0 & elon ~=1, help coastline, error('Improper elon'),end
if nargin<2, linetype='-w'; end

[fid,msg]=fopen('coastline.dat');
if ~isempty(msg), error(msg), end

set(gca,'box','on');

hold on,

count=1;
while count,
  a=fscanf(fid,'%i',2);
if isempty(a), return, end
  b=fscanf(fid,'%f',[a(2),a(1)]);
  if elon,
    I=find(b(1,:)<0); plot(360+b(1,I),b(2,I),linetype),
    I=find(b(1,:)>=0);  plot(b(1,I),b(2,I),linetype),
  else
    plot(b(1,:),b(2,:),linetype),
  end
end

fclose(fid);

% fini
