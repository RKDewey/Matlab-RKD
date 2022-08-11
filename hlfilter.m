function [fcoef,hpp]=hlfilter(dt,tl,th,hl);
% function [fcoef,hpp]=hlfilter(dt,tl,th,hl);
% Design either a high or low pass FIR filter (coefficients).
% Input: 
%   dt sample period/rate in time units
%   tl is the low period (1/freq) or high freq (tl=1/hf) in dt units
%   th is the high period (1/freq) or low freq (th=1/lf) in dt units
%   hl = +1 for a low pass (default), -1 for a high pass
%  hi pass_______   _______low pass
%  ______/                 \_______
%      lf hf             lf hf 
% Output:
%   fcoef are the filter coeficients
%   hpp is the half power point (optional)
%
% Use: y=filter2(fcoef,x);
%
% RKD 07/07 (based on old fortran code)
% if hl==1, tl0=th;th=tl;tl=tl0; end
TH=th/dt;
TL=tl/dt;
mph=fix(1.5*(TH+TL)/(TH-TL)+1);
n=ceil((mph+1.5)*0.5*TL);
Thi=n/((mph-1.5)*0.5);
Tlow=TL;
disp([' True low and high periods: ',num2str([Tlow Thi])]);
hpp=(Thi+Tlow)/2;
nc=n+1;
fcoef(1)=mph/n;
I=[2:nc];
C2=pi*I/(2*n);
C3=pi*I*fcoef(1);
fcoef(I)=(cos(C2).^2).*sin(C3)./(2*n*sin(C2));
if hl==-1, % then this is a high pass filter
    fcoef(1)=1-fcoef(1);
    fcoef(I)=-fcoef(I);
end
f1=fcoef(nc);
I2=[nc:(2*nc-2)];
fcoef(I2)=fcoef(I2-nc+1);
fcoef(2*nc-1)=f1;
I3=[2*nc-1:-1:nc+1];
fcoef(1:nc-1)=fcoef(I3);
% fini