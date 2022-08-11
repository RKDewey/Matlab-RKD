% script to test oplogo
ip=0;
dx=1.4;
dy=10/8;
for i=1:4,
   xo=0.25+(i-1)*1.75;
   if i>2, xo=xo+0.5; end
   for j=1:7,
      ip=ip+1;
      yo=1/16 +(j-1)*(12/8+1/128);
      ipos(ip,:)=[xo/8 yo/10.5 dx/8 dy/10.5];
   end
end
oplogo(4*7,ipos);
% fini