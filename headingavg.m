function ha=headingavg(h);
% function ha=headingavg(heading1,heading2);
% Function to average avector of compass heading values 
%   in vector headings.
% The length of headings must be at least 2.
% The assumpion is that the heading values are from a compass,
%   which measures positive headings as clockwise from due North.
% Valid heading values are then 0-360.
% The output is the vector average angle in compass heading units.
% NOTE: If two opposite headings are averaged, the answer is ambiguous
% RKD 03/11
h=h(:);
%
td=-(h-90);
i1=find(td>180);
if ~isempty(i1), td(i1)=-(360-td(i1)); end
i2=find(td<-180);
if ~isempty(i2), td(i2)=360+td(i2); end
% td is now theta in degrees
theta=td*pi/180; % now theta is proper radial angle in radians
z=exp(sqrt(-1)*theta); % convert to complex vector
i=~isnan(z);
az=mean(z(i)); % take the average, exluding NaNs
at=atan2(imag(az),real(az)); % the average angle
ha=90-at*180/pi; % average angle in degrees
i3=find(ha<0);
if ~isempty(i3), ha(i3)=360+ha(i3); end
i4=find(ha>=360);
if ~isempty(i4), ha(i4)=ha(i4)-360; end
% fini