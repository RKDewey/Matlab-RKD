function kk = ffirsti(xdata);
%
% Function FFIRSTI.M
% Finds the index of the first good data point in xdata.
%
%       Usage:  index = ffirsti( xdata )
%       Where:  index = output index
%               xdata = input data column

%   MDM  29 Dec 93   Original (FFIRST)
%   MDM  18 Jan 94   Modified FFirst to output index instead of time.
%   JTG  12 Dec 94   Changed to use FIND instead of a loop
%                    Send message if no good data exists and returns 0
%

kk=min(find(~isnan(xdata)));
if isempty(kk)
     kk=0;
     disp('No good data in array')
     return
else
%      fprintf(1,'First good index is %6d \n',kk);
end     
