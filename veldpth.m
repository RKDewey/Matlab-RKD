function vdr=veldpth(v,dr);
%
% function vdr=veldpth(v,dr) averages non NaN values in depth range dr
%	v = adcp velocity matrix
%       dr = [ibin1 ibin2] bins to average between (bin1<bin2)
%
[m,n]=size(v);
vdr=zeros(1,n);
for i=1:n
    avgv=0;
    navg=0;
    for j=dr(1):dr(2)
        if v(j,i)~=NaN
        if abs(v(j,i))<50
           avgv=avgv+v(j,i);
           navg=navg+1;
        end
        end
    end
    if navg>0
      vdr(i)=avgv/navg;
    else
      vdr(i)=NaN;
    end
end
