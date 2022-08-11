function [Y,P,R2]=linfit(x,y)
% function [Y,P,R2]=linfit(x,y)
% Perform a simple linear fit ofr y(x)=P(1)*x + P(2);
% where x and y are equal length vectors
%       Y is the linear fit
%       P is the slope and intercept
%       R2 is the r-squared goodness of fit
% plot(x,y,x,Y)
% RKD 06/12
if length(x)~=length(y),
    disp('Vectors must be of same length');
    return
end
[P,S]=polyfit(x,y,1);
[Y,D]=polyval(P,x,S);
yresid=y-Y; % the residuals
SSresid=sum(yresid.^2);
SStotal = (length(y)-1)*var(y);
R2=1-SSresid/SStotal;
% fini