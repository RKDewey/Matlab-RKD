function [tsout,tout]=cleanx(tsin,tin);
%
%  Function [tsout,tout]=cleanx(tsin,tin)
%   or
%  Function [tsout]=cleanx(tsin)
%  Fills in the NaN's in a data set by using linear interpolation,
%
%  4/7/94 RKD - chunk end NaN values first.
% Chunk off NaN values.
n=length(tsin);
if nargin == 1, tin=[1:n]; end
tsout=tsin; tout=tin;
ist=min(find(isnan(tsin)==0));
iend=max(find(isnan(tsin)==0));
if isempty(ist), 
    % disp('No good data in this time series (cleanx.m)'); 
    return; 
end;
if ist ~= 1 | iend ~= n
   newn=iend-ist+1;
   if newn <= 1, return, end;
   tsnew(1:newn)=tsin(ist:iend);
   tnew(1:newn)=tin(ist:iend);
   tsin=tsnew;
   tin=tnew;
end
%
nn  = 0;                                   % counter for NaNs filled
lt = length(tsin);                         % length of input array
%if lt ~= n, fprintf(1,'%5d NaNs truncated from time series\n',(n-lt)); end
nan1 = isnan(tsin);
nnan = sum(nan1);                          % # of NaN's to be replaced
%
% send info to screen
%
% loop through data filling in NaN's
while sum(nan1)>0,
   ii=min(find(nan1==1));
   jj = (ii-1) + ffirsti(tsin(ii:lt)); % find next good point
   kk = jj - ii;                       % number of points to fill
   delx = (tsin(jj)-tsin(ii-1))/(kk+1);
   i=[1:kk];
   tsin(ii-1+i)=tsin(ii-1)+(i*delx);
   nan1 = isnan(tsin);     % recalculate the NaN array
   nn = nn+kk;             % increment summary counter
end
%if nn > 0, fprintf(1,'%5d NaNs were filled\n',nn); end
tsout=tsin;
tout=tin;
% fini