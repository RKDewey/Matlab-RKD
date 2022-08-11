function xf=lpavhflt(x,sr,cfv,cfh)

% function to low pass filter an array of data using a FIR type filter
%    Usage: xf=lpavhflt(x,sr,cfv,cfh)
%    Where:    x = input series
%              sr = sample frequency
%              cf = filter corner frequency
%
%    Program to filter along vertical direction at cfv and horizontal 
%    direction at cfh. Multiple runs of the filter are done over the vertical 
%    array dimension first. Primary use is to low pass filter a field of data
%    such as an ADCP would collect.
%
%    Sample frequency and corner frequency must be in consistent units
%         (Hz, cph, etc.)

%    Version 1.0 - JT Gunn 11/4/92
%            1.1 - JT Gunn 4/23/93: Wn forced to be integer
%             1.2 - RKDewey 14/3/94: both vertical and horizontal filter cf


[r,c]=size(x);
xf=zeros(size(x));
if cfv ~= 1.0
     Wnv=fix(1.5*(1/cfv)); 
     bv=fir1(Wnv,sr*cfv/2);
     for k=1:c
          xf(:,k)=filtfilt(bv,1,x(:,k));
     end
else
     xf=x;
end
if cfh ~= 1.0
     Wnh=fix(1.5*(1/cfh));
     bh=fir1(Wnh,sr*cfh/2);
     for k=1:r
          xf(k,:)=filtfilt(bh,1,xf(k,:));
     end
end

