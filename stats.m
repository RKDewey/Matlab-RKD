function s=stats(x,nm)
% function statistics=stats(x,nm)  where x can have NaN values
% Do stats in dimension nm (i.e. X(1,2))
% statistics is a structure with the following assignments:
% s.xbar=xbar;
% s.xstd=xstd;
% s.xmin=xmin;
% s.xmax=xmax;

% RKD 12/20/94
[n,m]=size(x);
if nargin<2, nm=1; end
if nm==1,
    xbar=ones(1,m)*NaN;
    xstd=xbar;xmin=xbar;xmax=xbar;
    for i=1:m,
        indx=~isnan(x(:,i));
        if sum(indx)>0,
        x0=x(indx,i);
        xbar(i)=mean(x0);
        xstd(i)=std(x0);
        xmin(i)=min(x0);
        xmax(i)=max(x0);
        end
    end
elseif nm==2,
    xbar=ones(n,1)*NaN;
    xstd=xbar;xmin=xbar;xmax=xbar;
    for i=1:n,
        indx=~isnan(x(i,:));
        if sum(indx)>1,
        x0=x(i,indx);
        xbar(i)=mean(x0);
        xstd(i)=std(x0);
        xmin(i)=min(x0);
        xmax(i)=max(x0);
        end
    end
end
s.xbar=xbar;
s.xstd=xstd;
s.xmin=xmin;
s.xmax=xmax;
%
