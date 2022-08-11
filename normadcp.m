function U0=normadcp(U,id1,id2,uabs);
%
% function U0=normadcp(U,id1,id2,uabs) subtracts the average U between
%    depth bins id1 and id2 inclusive.
%    U=adcp matrix (top is shallow, i.e. inverted)
%    id1:id2 depth range to average and then normalize by,
%    i.e. 18:11   form 55-37:55-44
%    uabs determine the magnitude of velocities included in average
%
U0=zeros(size(U));
[m,n]=size(U);
for i=1:n
    avgu=0;
    navg=0;
    for j=id2:id1
        if U(j,i)~=NaN
        if abs(U(j,i))<uabs
           avgu=avgu+U(j,i);
           navg=navg+1;
        end
        end
    end
    if navg~=0
      avgu=avgu/navg;
      for j=1:m
        U0(j,i)=U(j,i)-avgu;
      end
    end
end
