function [Xa,Ta]=binavg(x0,t0,ta0)
% function [xa,ta]=binavg(x0,t0,ta0)
%   function to bin average data from original time series (x0,t0) into
%   new time series (xa,ta).
%   ta0 should have new time base upon entry, otherwise 1/10 scale.
%	x0 = original data (ignores NaNs)
%	t0 = original time base, not necessarily even
%	ta0= new time base, also, not necessarily even (then SLOW)
%     OR integer factor (i.e. 2,3,4,..) for even t0
%	xa = bin averaged data
%	ta = time base at center of bins
% if x0 is a matrix, then bin average each row/column
% RKD 23/9/94
warning off
if nargin<3, ta0=10; end
[nx,mx]=size(x0);
[nt,mt]=size(t0);
td=2; % assumes 2D matrix
if nt==1 | mt==1, td=1; end
flip=0;Xa=[];Ta=[];
if mx==length(t0), x0=x0'; t0=t0'; flip=1; end % average along the dimension of t0
[nx,mx]=size(x0);
if length(ta0)>1,
    ia=find(ta0 >= min(t0) & ta0 <= max(t0));
	if isempty(ia), error('No time base match in binavg!?'); return; end
    dt1=(ta0(2)-ta0(1))/2;
    dt2=(ta0(end)-ta0(end-1))/2;
else
    J=nx-mod(nx,ta0);
end
if length(ta0)>1,
    tn=length(ta0);
else
    tn=nx/ta0;
end
for ii=1:mx,
    x=x0(:,ii);
    if td==1; 
        t=t0;
    else
        t=t0(:,ii);
    end
% deal with NaNs
    nisn=~isnan(x);
    x=x(nisn);t=t(nisn);
% 1/09
	if length(ta0) > 1,
        I=length(ta0);
        j=0;
        for i=1:I,
            if i==1,
                jj=find(t>ta0(i)-dt1 & t<ta0(i)+dt1);
            elseif i>1 & i<I,
                jj=find(t>ta0(i)-(ta0(i)-ta0(i-1))/2 & t<ta0(i)+(ta0(i+1)-ta0(i))/2);
            elseif i==I,
                jj=find(t>ta0(i)-dt2 & t<ta0(i)+dt2);
            end
            nn=~isnan(x(jj));
            if ~isempty(nn)
                j=j+1;
                ta(j)=ta0(i);
                xa(j)=mean(x(jj(nn)));
            end
        end
        disperc(ii,mx);
    else  % then decimate by factor ta0
        nn=sum(isnan(x(1:J)));
        if nn==0,
            xa=mean(reshape(x(1:J),ta0,(J/ta0)),1);
        else
        	xa=avg(reshape(x(1:J),ta0,(J/ta0))')';
        end
    	ta=mean(reshape(t(1:J),ta0,(J/ta0)),1)';
    end
	Xa(:,ii)=xa;
    if td==1,
        Ta=ta;
    else
        Ta(:,ii)=ta;
    end
end
if flip==1, Xa=Xa'; Ta=Ta'; end
% fini
