function xf=lpavflt(x,sr,cf)

% function to low pass filter an array of data using a FIR type filter
%    Usage: xf=lpavflt(x,sr,cf)
%    Where:    x = input series
%              sr = sample frequency
%              cf = filter corner frequency
%
%    Program filters in the vertical
%    direction. Multiple runs of the filter are done over the vertical
%    array dimension. Primary use is to low pass filter a field of data
%    such as an ADCP would collect.
%
%    Sample frequency and corner frequency must be in consistent units
%         (Hz, cph, etc.)

%    Version 1.0 - JT Gunn 11/4/92
%            1.1 - JT Gunn 4/23/93: Wn forced to be integer
%	       1.2 - RK Dewey 3/14/94 : only do vertical filter.

Wn=fix(1.5*(1/cf));
b=fir1(Wn,sr*cf/2);

[r,c]=size(x);
xf=zeros(size(x));
     for k=1:c
          xf(:,k)=filtfilt(b,1,x(:,k));
     end
return

