function [xc, ngood, txc]=ccor(X,Y,t1,t2)
%    CCOR
%    function to calculate the cross correlation of two time series
%    allowing for interpolation of data gaps specified by -999. data 
%    values.
%
%    usage: [xc, ngood] = ccor(X,Y,t1,t2)
%    where:    xc = output vector of cross correlation
%              ngood = number of good points ( not -999)
%              t1, t2 = start and end times to calculate over
%              X,Y = 2 col matrices of time (col 1) and data (col 2)

%    pull out x and y vectors and their time bases
x=X(:,2);
tx=X(:,1);
y=Y(:,2);
ty=Y(:,1);

% Find the common time base
t1=max([min(tx) min(ty) t1]);
t2=min([max(tx) max(ty) t2]);

% for now assume sample rates are the same

% truncate to common time range
%    first for x
     idx1=min(find(tx>=t1));
     idx2=max(find(tx<=t2));

%    then for y
     idy1=min(find(ty>=t1));
     idy2=max(find(ty<=t2));

%    print out values
     T=sprintf('Start and end times for x = %g and %g',idx1,idx2);
     disp(T)
     T=sprintf('Start and end times for y = %g and %g',idy1,idy2);
     disp(T)
     
% Make sure final vectors will have same length
if (idx2-idx1)~=(idy2-idy1)
     xc=[];
     error('Vector length mismatch in CCOR')
     dx=idx2-idx1;
     dy=idy2-idy1;
     T=sprintf('dx = %g ; dy = %g',dx,dy)
     return
end

% Truncate to same time base
x=x(idx1:idx2);
tx=tx(idx1:idx2);
y=y(idy1:idy2);
ty=ty(idy1:idy2);

% return minimum number of good points
ngood = min([length(find(x~=-999.)) length(find(y~=-999.))]);

% Remove data gaps (-999's) from each series by interpolating between
%    good points

[xcln, tx]=cleanup(x,tx);
[ycln, ty]=cleanup(y,ty);

% Calculate cross correlation
xc=xcorr(xcln,ycln,'coeff');
n=length(xc);
dt=mean(diff(tx));
txc=-((n-1)/2)*dt:dt:((n-1)/2)*dt;
txc=txc';

return
