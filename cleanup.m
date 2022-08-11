function [y, t]=cleanup(x,t)
%
%    function cleanup
%    purpose:  interpolates over data gaps indicated by -999's
%              
%    usage: [y, t]=cleanup(x,t)
%    where:    x= input time series vector
%              y= output time series vector
%              t= time base of vector

% First find inital -999
% Look for data gaps specified as -999.
% For each one use spline to linearly interpolate over each gap
%    for now don't limit the gap size to any minimum

y=x;
g1=min(find(x==-999.))-1;
while g1<=max(find(x==-999))

%    check for obvious problem
     if g1<1
          error('Error gap starts at begining of data in CCOR')
          return
     end

%    next look for good data to start again
     g2=g1+min(find(x(g1+1:length(x))~=-999.));

%    interpolate over gap
     y(g1:g2)=spline([t(g1) t(g2)],[x(g1) x(g2)],t(g1:g2));

%    find start of next gap
     g1=g2+min(find(x(g2+1:length(x))==-999.))-1;
end