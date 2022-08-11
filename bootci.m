function [lo,stat,hi]=bootci(x,per,nbs,moment);
% function [lo,stat,hi]=bootci(x,percent,nbs,moment)
%
% Function to calculate the percent (%) bootstrap confidence 
% interval for data in matrix x about the statistic "stat"
% The number of rows in lo, stat and hi is equal to the 
%   number of rows (statistics on column vectors) in x.
% Optional Parameters:
%   nbs: number of bootstrap iterations (default=1000)
%   moment: 1 = stat = mean (default), 
%           2 = stat = variance, =sum[(x-mean(x))^2]/N 
%           3 = stat = normalized 3rd moment
%           4 = stat = normalized 4th moment
% RKD 4/98
[m,n]=size(x);
if n==1, x=x'; [m,n]=size(x); end % for a vector, make sure it's a column
per=per/100;
if nargin < 3, nbs=1000; end
if nargin < 4, moment=1; end
iper=(1.0-per)/2;
ilow=round(iper*nbs);
ihi=round((1-iper)*nbs);
%
rand('state',sum(100*clock));
for M=1:m  % loop through if x is a matrix
   for i=1:nbs  % loop the nbs bootstrap sub-sets
      ir=ceil(rand(1,n)*n);  % get the ith set of random indecices
      xtmp=x(M,ir);
      % This version calculates the mean, sub the stat you want
      if moment==1,
         xm(i)=mean(xtmp');
      elseif moment==2,
         xm(i)=std(xtmp').^2;
      elseif moment==3,
         xm(i)=mean((xtmp-mean(xtmp)).^3)/(std(xtmp).^3);
      elseif moment==4,
         xm(i)=mean((xtmp-mean(xtmp)).^4)/(std(xtmp).^4);
      end
   end
   xm=sort(xm);
   lo(M)=xm(ilow);
   hi(M)=xm(ihi);
   if M==1, figure(1); clf; end
   [N,X]=hist(xm,100);
   bar(X,N);hold on
   plot(lo(M),0,'rd',mean(x),0,'r*',hi(M),0,'rd');
   if moment==1,
      stat(M)=mean(x(M,:));
   elseif moment==2,
      stat(M)=std(x(M,:))^2;
   elseif moment==3,
      stat(M)=mean((x(M,:)-mean(x(M,:))).^3)/(std(x(M,:)).^3);
   elseif moment==4,
      stat(M)=mean((x(M,:)-mean(x(M,:))).^4)/(std(x(M,:)).^4);
   end
end
% fini