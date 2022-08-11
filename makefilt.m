function [fcoef,rfilt]=makefilt(fl,fh,dt,hl);
% [fcoef,rfilt]=makefilt(fl,fh,dt,hl);
% Make FIR filter coefficients for either high or low pass filter
% The filter is "optimal" (shortest possible).
% rfilt is the approximate half power point.
% fl = low frequency to be passed/filtered
% fh = high frequency to be filtered/passed
% dt = time step of time series to which filter will be applied
% hl = 1 for low pass filter, = -1 for high pass filter
% To apply filter: y=filter(fcoef,1,x);
% To check frequency characteristics: semilogy(abs(fft(fcoef)))
% RKD 4/97
tl=1/(fl*dt);th=1/(fh*dt);
mph=fix(1.5*(tl+th)/(tl-th) + 1);
n=fix((mph+1.5)*0.5*th);
tlow=n/((mph-1.5)*0.5);
rfilt=(tlow+th)/2;
fcoef=zeros(1,n+1);
fcoef(1)=mph/n;
c2=pi*(1:n)/(2*n);
c3=pi*(1:n)*fcoef(1);
fcoef(2:n+1)=(cos(c2).^2).*sin(c3)./(2*n*sin(c2));
%
if hl < 0, % then turn this into a high pass filter
   fcoef(1)=1-fcoef(1);
   fcoef(2:n+1)=-fcoef(2:n+1);
end
fcoef=[fliplr(fcoef(2:n+1)) fcoef];
% fcoef=fcoef/sum(fcoef);  % Normalize the area=1
%

