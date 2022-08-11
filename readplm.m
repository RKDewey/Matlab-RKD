cd d:\disnew\model\new
[x,y,z]=meshgrid([1:99],[1:99],[1:10]);
v=z;
v=zeros(size(v));
fopen(ifile,'r');
for k=1:10,for j=1:99
  v1=fread(3,99,'float');
  ii=0;
  for i=j:99:9801
    ii=ii+1;
    v(i,k)=v1(ii);
  end;
end;end;
clear i j k ii v1
dummy=fread(3,3,'float');
dummy=fread(3,4,'int32');
xyaxis=fread(3,4,'float');
dummy=fread(3,1,'int16');
dummy=fread(3,16,'float');
ijks=fread(3,15,'int16');
dummy=fread(3,1,'float');
dummy=fread(3,155,'float');
dummy=fread(3,254,'float');
dummy=fread(3,11,'float');
clear dummy
z0=fread(3,10,'float')';
fclose(3);
x=[xyaxis(1)+0.25:0.25:xyaxis(2)-0.25];
y=[xyaxis(3)+0.25:0.25:xyaxis(4)-0.25];
[x,y,z]=meshgrid(x,y,z0);
