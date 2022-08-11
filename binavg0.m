function [xa,ta]=binavg(x0,t0,ta0)
% function [xa,ta]=binavg(x0,t0,ta0)
%   function to bin average data from original time series (x0,t0) into
%   time series (xa,ta). ta0 must have new time base upon entry.
%	x0 = original data
%	t0 = original time base
%	ta0= new time base, will get truncated by available data into ta
%		ta0 MUST BE PASSED WITH VALUES
%	xa = bin averaged data
%	ta = time base at center of bins
% RKD 23/9/94
i0e=length(t0);
iae=length(ta0);
%
for i=1:1:iae-1
  dt=ta0(i+1)-ta0(i);
  if t0(1) < (ta0(i)-dt/2), break, end
end
% starting new bin at ta0(ia0)
ia0=i;
for i=iae:-1:2
   dt=ta0(i)-ta0(i-1);
   if t0(i0e) > (ta0(i)+dt/2), break, end
end
% new last bin at ta0(iae)
iae=i;
j0=1;
j=0;
dt2=(mean(diff(ta0)))/2;
for i=ia0:iae
    j=j+1;
    ta(j)=ta0(i);
    avg=0;
    navg=0;
    for jj=j0:i0e
      if (t0(jj) >= (ta(j)-dt2)) & (t0(jj) <= (ta(j)+dt2))
         if isnan(x0(jj))==0
            navg=navg+1;
            avg=avg+x0(jj);
         end
      end
      if t0(jj) > (ta(j)+dt2)
        j0=jj-1;
        break;
      end
    end
    if navg > 0
      xa(j)=avg/navg;
    else
      xa(j)=NaN;
    end
end
%
