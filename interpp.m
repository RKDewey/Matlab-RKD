function [X,T]=interpp(x,t,dt);
% [X,T]=interpp(x,t,dtn)
% linear interpolates data in array x(t) with spacing 
% defined by (irregular but monotonic) t to new 
% array with uniform spacing/time base dtn (default dt/10) smaller than old spacing.
% arrays must be at least 3 elements long, with no NaNs
% RKD 5/9/94, redone 5/02
%     ALSO SEE pinterp.m, interpt.m and interps.m
X=[];T=[];
if nargin < 3, dt=mean(diff(t))/10; end
if length(x) < 3, disp(['x must be at least 3 long']); return; end
if sum(isnan(x)) > 0, disp(['Data has NaN''s.']); return; end

if length(dt)==1, 
    T=[t(1)+dt/2:dt:t(end)-dt/2]; 
else
    T=dt;
end
X=T*NaN; % just initializes array (faster)
I=length(T);j=0;
Ip=ceil(I/100);
disperc(0,0);
for i=1:I,
   disperc(i,I); 
   i1=max(find(t<=T(i)));
   i2=min(find(t>=T(i)));
   if ~isempty(i1) & ~isempty(i2),
      if (T(i)-t(i1))~=0,
         X(i)=x(i1) + ((x(i2)-x(i1))/(t(i2)-t(i1)))*(T(i)-t(i1));
      else
         X(i)=x(i1);
      end
   end
end
disperc(I,I);
% fini
