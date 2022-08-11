function [a]=avg(x);
% function [mean]=avg(x);
% Calculate the mean of each row ignoring NaNs
% RKD 02/02
% x=x(:)';
[m,n]=size(x);
a=ones(m,1)*NaN;
for i=1:m,
   in=~isnan(x(i,:));
   if sum(in)>0,
      a(i)=mean(x(i,in));
   end
end
% fini