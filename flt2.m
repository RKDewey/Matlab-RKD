function xf=flt2(x,fpts,ps);
%
% function xf=flt2(x,fpts,passes) to low pass filter a time series using filtfilt 
%   passed both ways. passes = number of times (default = 1)
%   Since filtfilt passes both ways already, this ties both ends
%   of the filtered time series to the original ends.
%	x = array
%	fpts = number of points for filter length (odd) i.e. 3,5,7
%	xf = filtered array
%
%    JT Gunn 12/14/94 modified flt.m
%         - optimized code to remove "for" loops
%         - input file may contain NaN's; gaps are interpolated over, filtered
%           and masked back to NaN's for output.
% RKD allow 2D matices, filter larger dimension.
if nargin < 3, ps=1; end
% make a mask for the data that are NaN's
mask=ones(size(x));
idx=isnan(x);mask(idx)=idx(find(idx)).*NaN;
idx=isinf(x);mask(idx)=idx(find(idx)).*NaN;
x=x.*mask;
%
[mm,nn]=size(x);
if nn>mm, N=nn;M=mm; else, M=nn;N=mm; x=x'; end
for ips=1:ps,
  X=x;
  Xf=x;
  clear x
  for i=1:M
     x=X(i,:);
     % chop off leading and trailing NaN's but keep track so they can be put back
     %    later.
     npts=length(x);
     idx1=min(find(~isnan(x))); idx2=max(find(~isnan(x)));
     if idx1>1
        lnan=x(1:idx1-1);
     end
     if idx2<npts
        tnan=x(idx2+1:npts);
     end
     x=x(idx1:idx2);
     xf=x;
     if sum(~isnan(x)) > 0, % there is data to be filtered
        % clean up any interior gaps by linearly interpolating over them
        [x,tcln]=cleanx(x,1:length(x));

        % calculate filter weights
        Wn=fix(1.5*fpts);
        b=fir1(Wn,(1/(fpts*2)));
        m=length(x);
        %
        if m >= 3*length(b), % then can filter
           % set weights for forward and reverse sum
           winc=1./(m-1);
           wt1= 1:-winc :0 ;
           wt2= 0: winc :1 ;

           % calculate forward filter time series, save
           xf1=zeros(size(x));
           xf1=filtfilt(b,1,x);

           % flip (invert) time series, filter, and unflip
           xi=zeros(size(x));
           xf2=zeros(size(x));

           % flip time series but check for horizontal or vertical matrix
           [r,c]=size(x);
           if r>c
              xi=flipud(x);
           else
              xi=fliplr(x);
           end

           xi=filtfilt(b,1,xi);

           if r>c
              xf2=flipud(xi);
           else
              xf2=fliplr(xi);
           end

           if r>c
              xf=xf1.*wt2' + xf2.*wt1';
           else
              xf=xf1.*wt2 + xf2.*wt1;
           end
        end % if filter length > 3 * length of x
        % reattach leading and trailing Nan's and apply mask for interior gaps
        if r>c
           if idx1 > 1
              xf=[lnan
                 xf];
           end
           if idx2 < npts
              xf=[xf
                 tnan];
           end
        else
           if idx1 > 1,
              xf=[lnan xf];
           end
           if idx2 < npts,
              xf=[xf tnan];
           end
        end
     else
        xf=ones(size(1,npts))*NaN;
     end
     %
     Xf(i,:)=xf;
     %
  end % loop of matrix
  if ps > 1, x=Xf; end
end % number of passes

if nn>mm,
   xf=Xf.*mask;
else
   xf=Xf'.*mask;
end
% fini
