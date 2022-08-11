function [x,y]=range2d(xy1,xy2)
% function [x,y]=range2d(xy1,xy2)
% calculate the two intersection points of two circles xy1 xy2
% RKD 10/98
[m1,n1]=size(xy1);
if length(xy1) ~= n1, xy1=xy1'; xy2=xy2'; end
min1=inf;min2=inf;
for i=1:length(xy1),
   dis(i,:)=sqrt((xy1(1,i)-xy2(1,:)).^2 + (xy1(2,i)-xy2(2,:)).^2);
end
min1=min(min(dis))
ij1=find(min1==dis);
save1=dis(ij1);
dis(ij1)=inf;
min2=min(min(dis))
ij2=find(min2==dis);
dis(ij1)=save1;

ij1=floor(ij1/length(xy2));
if ij1==0, ij1=1; end
ij2=floor(ij2/length(xy2));
if ij2==0, ij2=1; end

x=[xy2(1,ij1) xy2(1,ij2)]
y=[xy2(2,ij1) xy2(2,ij2)]
% fini
