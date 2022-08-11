function xf=vhflt(x,vfpts,hfpts)
% function to low pass filter an array of data using a FIR type filter
%    Usage: xf=lpavhflt(x,vfpts,hfpts)
%    Where:    x = input series
%	       vfpts = filter length for vertical filtering (none=1)
%	       hfpts = filter length for horizontal filtering (none=1)
% Uses Dewey's flt double filter routine.
%    1.0 - RKDewey 14/3/94: both vertical and horizontal filter cf
[m,n]=size(x);
xhf=zeros(size(x));
xvf=zeros(size(x));
if vfpts > 1
  for i=1:n
    xv=zeros(m,1);
    for j=1:m
        xv(j)=x(j,i);
    end
    xvf(:,i)=flt(xv,vfpts);
  end
else
  xvf=x;
end
if hfpts > 1
  for j=1:m
    xh=zeros(1,n);
    for i=1:n
        xh(i)=x(j,i);
    end
    xhf(j,:)=flt(xh,hfpts);
  end
else
  xhf=x;
end
if vfpts > 1
if hfpts > 1
  for i=1:n
    for j=1:m
        xf(j,i)=xhf(j,i)/2 + xvf(j,i)/2;
    end
 end
end
end
if vfpts == 1
   xf=xhf;
end
if hfpts == 1
   xf=xvf;
end
%
