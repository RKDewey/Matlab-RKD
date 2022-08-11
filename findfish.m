function [ind,Rm,Ws,Wn]=findfish(x,sc)
% function [ind,Rm,Ws,Wn]=defish(x,sc)
%   search chi matrix x, searching 51 points centered around fish
%   return the indices for the fish for channel 1, Weights S/N
%   and the range of the fish from the center of the river (-S/+N)
%   sc == the check for 'out-lier', i.e sc*std(median), try sc=6.
%         if sc is real, look abs(sc*std(median)), otherwise, use
%     real part for upper and imaginary part for lower limits.
%   Try running defish to de-spike and count the number of fish.
%   x may be a matrix, with each column being a time series.
% RKD 2/97
[I,J]=size(x);
xs=zeros(size(x));
x0=xs*NaN;
scu=abs(real(sc));
if imag(sc) ~= 0,
   scl=imag(sc);
  else
   scl=-abs(sc);
end
y=x(1,:);
ym=median(y);
smad=median(abs(y-ym*ones(size(y))));
npts=20;
xm=min(reshape(y,npts,length(y)/npts));
% now just check for a spike within each 20 point segment.
ii=0;
for i=3:length(xm)-3  % loop through the segments
    if (xm(i)-ym) < scl*smad,   % a fish is in this segment
      ii=ii+1;
      sseg=(i-1)*npts +1;
      seg=(sseg:sseg+npts-1);
      js=find(y(seg) == xm(i));
      j=(i-1)*npts + js;
      ind(ii)=j;
      jst=j-20;jend=j+30;
      A=x(1:5:16,jst:jend)';
      XA=xcorr(A);
% Now find maxima in each cross-correlation and average swim speed
      c1=find(XA(52:101,2) == max(XA(52:101,2)));
      c2=find(XA(52:101,3) == max(XA(52:101,3)));
      c3=find(XA(52:101,4) == max(XA(52:101,4)));
      c4=find(XA(52:101,7) == max(XA(52:101,7)));
      c5=find(XA(52:101,8) == max(XA(52:101,8)));
      c6=find(XA(52:101,12) == max(XA(52:101,12)));
%      U=((4/c2)+(6/c3)+(4/c5))/3;
      U=((2/c1)+(4/c2)+(6/c3)+(2/c4)+(4/c5)+(2/c6))/6;
      disp(['Index = ',num2str(ind(ii)) ' , Speed = ' num2str(U)]);
      j1=j;
      j2=j1+2/U;
      j3=j1+4/U;
      j4=j1+6/U;
      Ws(ii)=abs(sum(x(1:4,j1))+sum(x(5:8,j2))+sum(x(9:12,j3))+sum(x(13:16,j4)))/16;
      Wn(ii)=abs(sum(x(1:4:16,j1))+sum(x(2:4:16,j2))+sum(x(3:4:16,j3))+sum(x(4:4:16,j4)))/16;
      Rm(ii)=Wn(ii) - Ws(ii);
    end
end
% fini
