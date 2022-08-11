function jd=julian(date,time,~)
%
%	function julian
%	purpose: to convert date and time arrays to fractional day of year
%	usage:    jd=julian(date,time)
%	where:    date = array of date in form [dd mm yy]
%		     time = array of time in form [hh mm ss]
%   Alternately, to convert a julian day to a date, given the year
%   usage:    mdate=julian(jd,year,1);
%
%    structure allows multiple rows for inputs
%
%    Passing over year boundary is handled by allowing days to be greater
%     than 365.
%

%	J Gunn 3/18/94 version 2.0
%   R Dewey 11/2/22 version 3.0
%   J Gunn 5/25/92   version 1.0 - original
%    ver 1.2   modified 12/23/93 jtg w/ ideas from MDM's julianmt.m
%                   - input array format changed to decrease processing
%                   - re-did logic and array use for faster processing
%    ver 2.0   modified 3/18/94 jtg - allowed pass over of year boundary
%    ver 3.0   modified 11/2/22 rkd - invert julian day to date

% check for input format from version 1.0
if nargin < 3,
[nr,nc]=size(date);
if nc ~= 3
     error('Input format for julian.m incorrect - check help')
     return
end
[nr,nc]=size(time);
if nc ~= 3
     error('Input format for julian.m incorrect - check help')
     return
end
   

% first break out parts of date
day=date(:,1); mnth=date(:,2); yr=date(:,3);

% convert time to fraction of day
hr=time(:,1); mn=time(:,2); sec=time(:,3);
fday=(hr./24) + (mn./1440) + (sec./86400);

% create julian day array to save time
jd=zeros(nr,1).*NaN;

% calc month ends
if floor((yr(1)./4)).*4 == yr(1)
     lpyr=1;
     mend=cumsum([0 31 29 31 30 31 30 31 31 30 31 30 31]);
else
     lpyr=0;
     mend=cumsum([0 31 28 31 30 31 30 31 31 30 31 30 31]);
end

% number of days to add for change of year (starts out at 0)
yradd=0;

% establish a check for logic loops below
yrsave= yr(1);

% find proper julian day
% first establish if leap year
for k=1:length(yr)

% check for end of year boundary
if yr(k) ~= yrsave
     yrsave = yr(k);
     yradd = yradd + 365 +lpyr;
     
%    if so re-calc month ends
     if floor((yr(k)./4)).*4 == yr(k)
          lpyr=1;
	     mend=cumsum([0 31 29 31 30 31 30 31 31 30 31 30 31]);
     else
          lpyr=0;
	     mend=cumsum([0 31 28 31 30 31 30 31 31 30 31 30 31]);
     end
end
jd(k) = mend(mnth(k)) + day(k) + fday(k) + yradd;
end
else % then invert julian day to date
    jd=date;
    year=time;
    leapyears=[1904:4:2096]; % expand if needed
    daysinmonth=[31 28 31 30 31 30 31 31 30 31 30 31];
    isly=[];
    isly=find(leapyears==year);
    date=NaN;
    if isempty(isly), % then not a leap year, no Feb 29 (365)
        for m=1:12,
            for d=1:daysinmonth(m),
                jd1=julian([d m year],[0 0 0]);
                if jd1==jd,
                    date=datenum(year,m,d,12,0,0);
                    m=12;
                end
            end
        end
    else % then leap year, which has Feb 29 (366)
        daysinmonth(2)=29;
        for m=1:12,
            for d=1:daysinmonth(m),
                jd1=julian([d m year],[0 0 0]);
                if jd1==jd,
                    date=datenum(year,m,d,12,0,0);
                    m=12;
                end
            end
        end
    end
    jd=date;
end
