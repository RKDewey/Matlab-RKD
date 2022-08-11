function [ny]=runvar(y,ms)
% function xvar=runvar(x,npts)
% function to calculate the running variance of a time series y
% calculated over running sections of length npts
% default npts=5

if (nargin==1), ms=5; end;

plotflag=0;
if (rem(ms,2)~=1), ms=ms+1;end; % make it odd

% Replace the NaNs with +/- Infs. This is a sort of fudgey way to
% get reasonable results.

kk=find(isnan(y));
y(kk)=(rem([1:length(kk)],2)-.5)*Inf;

[Ny,My]=size(y);
y=y(:)';
N=max(Ny,My);
ny=y;

% Set up a matrix with shifted versions of y so we can vectorize all the
% variance calculations along columns

yy=zeros(ms,N-ms+1);
ym=zeros(1,N);

for i=1:ms,              % Do the middle bits
  yy(i,:)=y(i:N-ms+i);
end;
ym(fix(ms/2)+1:N-fix(ms/2))=std(detrend(yy)); 

for i=1:fix(ms/2),       % Fix the ends
   ym(i)=std(detrend(y(1:2*i-1)));
   ym(N-i+1)=std(detrend(y(N-2*i+2:N)));
end;

ny=ym.^2;

if plotflag, plot(1:N,y,1:N,ny,ii,ny(ii),'.g'); end;

ny=reshape(ny,Ny,My);
%fini


