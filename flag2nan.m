function x=flag2nan(x,flag);
% function to set all data equal to flag (value) to NaN
%    usage:    newx=flag2nan(x,flag)
%    where:    x= data array (may be matrix)
%              flag = value data to convert to NaN
%              newx = array with NaN's in place of flag data
%    Version 1.0 - RKD 1/9/95
indx=find(x==flag);
x(indx)=NaN;
disp(['Number of flag values replaced: ' num2str(length(indx))]);
% fini
