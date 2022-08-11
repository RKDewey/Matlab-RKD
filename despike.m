function [X,indxo]=despike(x,thd,ispkiseg,iplt)
% function [X,indx]=despike(x,thd,[ispk iseg],iplt)
% Despike a time series based on the amount (thd)
% of variance contained by central ispk points of each iseg(ment) of data.
% iseg must be a multiple of ispk i.e. [5 50] so we can use reshape
% Suggest you try a threshold between thd = 10%
% defaults are thd=10, iseg=[5 25]
% iplt =1 to plot before and after time series.
% Optional output are the indecies of the removed points, indx
% RKD 4/97
if nargin<2, thd=10;end
if nargin<3, 
    ispk=5; iseg=25; 
else
    ispk=ispkiseg(1);
    iseg=ispkiseg(2);
end
if mod(iseg,ispk)~=0, disp([' iseg must be multiple of ispk.']); return; end
if nargin<4, iplt=0; end
ss=5;sr=fix(ss*4);
ss=ispk;sr=iseg;
if rem(iseg,ss)~=0, iseg=fix(iseg/ss)*ss; end
thd=thd/100;
stdev=std(x);
X=x;  % initialize despiked array
if length(x) < iseg, return; end
M=iseg;
N=fix(length(x)/M)-1;
nsp=0;
for j=1:1, % do the process a few times
block=reshape(X(1:M*N),M,N);  % block the data into sections of length M=iseg 
varb=std(detrend(block)).^2;
for i=2:N,    % loop through all the blocks
   indx1=i*M-(M-1);
   if varb(i)/(stdev^2) > 1,  % don't bother if the data is just noise
   spikes=reshape(block(:,i),ss,M/ss);
   vars=std(detrend(spikes)).^2;
   indx=find(vars./varb(i) > thd);
   if ~isempty(indx),  % a spike exists in this section
      for is=1:length(indx)
         nsp=nsp+1;
         indxm=indx(is)*ss-(fix(ss/2)+1);
         indxb1=indx1+[indxm-2:indxm+2];
         if min(indxb1)<1, indxb1=indxb1(find(indxb1>0)); end
         if max(indxb1)>length(X), indxb1=indxb1(find(indxb1<(length(X)+1))); end
         indxb2=indx1+[indxm-sr:indxm+sr];
         if min(indxb2)<1, indxb2=indxb2(find(indxb2>0)); end
         if max(indxb2)>length(X), indxb2=indxb2(find(indxb2<(length(X)+1))); end
         med=median(X(indxb2)); % or med=NaN;
         X(indxb1)=med*ones(size(X(indxb1)));
         indxo(nsp)=indxb1(3);
      end
   end
   end
end
end
% X=cleanx(X); % use this is you set med above to NaN
% disp([num2str(nsp) ' spikes removed']);
if iplt==1,
   plot((length(x):-1:1),x,'r',(length(x):-1:1),X,'b');
end
% fini
