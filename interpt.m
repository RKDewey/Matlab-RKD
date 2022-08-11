function [xi,ti]=interpt(X,T,tn);
% function [xi,ti]=interpt(X,T,tn);
% Linear interpolate X values from coarse time base T 
% to finer/new time base tn
% return interpolated values xi and new time base ti
% tn can be  = dt of new time series
% RKD 7/02
%     ALSO SEE pinterp.m, interpp.m and interps.m
warning off
if length(tn) > 1,
   indx1=[min(find(tn >= T(1))):max(find(tn <= T(end)))];
   ti=tn(indx1);
else
   ti=[T(1):tn:T(end)];
end
xi=ones(size(ti))*NaN;
indx2=[max([find(T<ti(1)) 1]):(min([find(T>ti(end)) length(T)])-1)];
for i=indx2,      %max(find(T <= tn(1))):(min(find(T >= ti(end)))-1),
   indx=[min(find(ti>=T(i))):max(find(ti<=T(i+1)))];
   P=polyfit([T(i) T(i+1)],[X(i) X(i+1)],1);
	xi(indx)=polyval(P,ti(indx));
end
warning on
% fini
