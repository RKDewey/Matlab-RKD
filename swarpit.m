function swarpit(map)
% Warps data to a sphere for a south pole projection
[m,n] = size(map);
lat = linspace(-90,90,m);
long = linspace(0,360,n);
[mlat, mlong] = meshgrid(lat, long);
mlat = mlat';
mlong = mlong';
x =  2*tan(pi/180*(45 + mlat/2)).*sin(mlong*pi/180);
y =  2*tan(pi/180*(45 + mlat/2)).*cos(mlong*pi/180);
dist = sqrt(2);
i = find(abs(x) >dist | abs(y) >dist);
map(i) = NaN + map(i);  
surf(x,y,map)
view(2)
shading flat
axis([-1 1 -1 1] * dist )
