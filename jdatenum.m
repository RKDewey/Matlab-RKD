function dn=jdatenum(j,yy)
% function dn=jdatenum(j,yyyy)
% convert a julian day (Jan 1 = day 1), into a MATLAB datenum
% to test datestr(dn);
% RKD 09/00
yy=ones(size(j))*yy;
N=length(j);
[id imt]=dmy(j(1),yy(1));
id=fix(id);
h=24*(j(1)-fix(j(1)));
ih=fix(h);
m=60*(h-ih);
im=fix(m);
is=fix(60*(m-im));
dn1=datenum(yy,imt,id,ih,im,is);
dn=j-j(1)+dn1;
% fini