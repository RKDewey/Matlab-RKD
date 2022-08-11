function [ny]=clean(y,ms,Nmad,mdormn,plotflag)
% CLEAN Performs a robust cleaning of a time series to remove outliers
%       CLEAN(T,LEN,NMAD,mdormn,plotflag) uses a median filter of length LEN to filter the
%       series T, replacing outliers further than NMAD median absolute
%       deviations away from the current median value with that value.
%       Missing data values (signified by NaN) are also replaced with the
%       current median value.
%
%       LEN and NMAD are optional parameters that default to 5 and 3
%       respectively. LEN should be an odd number.
%       mdormn = 1 for median [default], 2 for mean
%       plotflag=1 to plot before and after

% Changes: 23/9/93 - modified to use with redefined 'median' which
%                    returns NaN. The #$&^#$&. What we do is replace
%                    the NaNs with Infs (with alternating sign). This is not
%                    optimal but OK if there aren't too many NaNs.

if nargin==1, ms=5; Nmad=3; mdormn=1; plotflag=0; end;
if nargin==2, Nmad=3; mdormn=1; plotflag=0; end;
if nargin==3, mdormn=1; plotflag=0; end
if nargin==4, plotflag=0; end

if (rem(ms,2)~=1), 
%%%%%error('median filter length must be an ODD number');
 ms=ms+1;
end;

% Replace the NaN with +/- Infs. This is a sort of fudgey way to
% get reasonable results.

kk=find(isnan(y));
y(kk)=(rem([1:length(kk)],2)-.5)*Inf;


[Ny,My]=size(y);
y=y(:)';
N=max(Ny,My);

ny=y;
% Set up a matrix with shifted versions of y so we can vectorize all the
% median calculations along columns

yy=zeros(ms,N-ms+1);
ym=zeros(1,N);
ybar=ym;
for i=1:ms,              % Do the middle bits
  yy(i,:)=y(i:N-ms+i);
end;
ym(fix(ms/2)+1:N-fix(ms/2))=median(yy); 
ybar(fix(ms/2)+1:N-fix(ms/2))=mean(yy); 
for i=1:fix(ms/2),       % Fix the ends
   ym(i)=median(y(1:2*i-1));
   ym(N-i+1)=median(y(N-2*i+2:N));
   ybar(i)=mean(y(1:2*i-1));
   ybar(N-i+1)=mean(y(N-2*i+2:N));
end;
% MAD calculation - we want to get rid of Inf-Inf terms (which give NaN).
kk=~isnan(y-ym);
if mdormn==1,
    smad=median(abs(y(kk)-ym(kk))');    % MAD estimate about running median
    ii=find(abs(y-ybar)> Nmad*smad);  % Guess the outliers as being really far away
    ny(ii)=ym(ii);               % replace outliers with interpolated values.
elseif mdormn==2,
    sd=mean(abs(y(kk)-ybar(kk))');    % StDev estimate about running mean
    ii=find(abs(y-ybar)> Nmad*sd);  % Guess the outliers as being really far away
    ny(ii)=ybar(ii);               % replace outliers with interpolated values.
end
%
if plotflag, plot(1:N,y,1:N,ny,ii,ny(ii),'.g'); end;
ny=reshape(ny,Ny,My);
% fini

