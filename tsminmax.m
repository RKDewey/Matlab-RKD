function [x,y]=tsminmax(x,y,sl);
% function [x,y]=tsminmax(x,y,sl);
% Function to divide a time seris (y) up into segments of length sl
% and pass back the new ts composed of min/max values per segment
% Optional: x timebase or indecies (default)
%           sl segment length in x units (default 100)
% RKD 6/06
if nargin<2, x=[1:length(y)]; sl=100; end
if nargin>2 & nargin<3, sl=100*mean(diff(x)); end
% if nargin==3, sl=fix(sl/mean(diff(x))); end
ly=length(y);
ns=floor(ly/sl);
Y=reshape(y([1:ns*sl]),sl,ns);
X=reshape(x([1:ns*sl]),sl,ns);
[miny,imin]=min(Y);
[maxy,imax]=max(Y);
for j=1:ns, 
    if imin(j)<imax(j),
        x2(1:2,j)=[X(imin(j),j);X(imax(j),j)];
        y2(1:2,j)=[miny(j);maxy(j)];
    else
        x2(1:2,j)=[X(imax(j),j);X(imin(j),j)];
        y2(1:2,j)=[maxy(j);miny(j)];
    end
end
x=reshape(x2,1,ns*2);
y=reshape(y2,1,ns*2);
% fini