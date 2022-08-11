function [xout,tout]=gapnan(x,t,dt);
% function [xout,tout]=gapnan(x,t,dt);
% 
% fill gaps in the time series [x,t] with a NaN when gap is larger than dt
% Note t is always a vector
% if X is a matrix of "profiles", then fill gaps with a NaN profiles
%
% RKD 05/10
DT=diff(t);
indx=find(DT>dt);
indx=indx(:)';
J=length(indx);
if J>0, % then there are NaNs to fill
[m,n]=size(x);
[mt,nt]=size(t);
if m==mt & mt>1, % then m and mt are the time dimensions
    np=ones(1,n)*NaN;
    xout=[x ; ones(J,n)*NaN];
    tout=[t ; ones(J,1)*NaN];
    j=0;
    L=mt;
    for i=indx,
        j=j+1;
        ii=[i+1:L];
        xout(ii+j,:)=x(ii,:);
        xout(i+j,:)=np;
        tout(ii+j)=t(ii);
        tout(i+j)=(t(i)+t(i+1))/2;
    end
end
if n==nt & nt>1, % n and nt are the time dinensions
    np=ones(m,1)*NaN;
    xout=[x ones(m,J)*NaN];
    tout=[t ones(1,J)*NaN];
    j=0;
    L=nt;
    for i=indx,
        j=j+1;
        ii=[i+1:L];
        xout(:,ii+j)=x(:,ii);
        xout(:,i+j)=np;
        tout(ii+j)=t(ii);
        tout(i+j)=(t(i)+t(i+1))/2;
    end
end
if m==nt & nt>1,  % then m and nt are the time dimensions
    np=ones(1,n)*NaN;
    xout=[x ; ones(J,n)*NaN];
    tout=[t ones(1,J)*NaN];
    j=0;
    L=nt;
    for i=indx,
        j=j+1;
        ii=[i+1:L];
        xout(ii+j,:)=x(ii,:);
        xout(i+j,:)=np;
        tout(ii+j)=t(ii);
        tout(i+j)=(t(i)+t(i+1))/2;
    end
end
if n==mt & mt>1, % then n and mt are the time dimensions
    np=ones(m,1)*NaN;
    xout=[x ones(m,J)*NaN];
    tout=[t ; ones(J,1)*NaN];
    j=0;
    L=mt;
    for i=indx,
        j=j+1;
        ii=[i+1:L];
        xout(:,ii+j)=x(:,ii);
        xout(:,i+j)=np;
        tout(ii+j)=t(ii);
        tout(i+j)=(t(i)+t(i+1))/2;
    end
end
end
% fini