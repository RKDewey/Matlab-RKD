function xi=matinv(x)
%
% function xi=matinv(x) to invert the rows of a matrix x, top to bottom.
%
[r,c]=size(x);
xi=zeros(size(x));
for k=1:r
    kk=r+1-k;
    xi(kk,:)=x(k,:);
end
