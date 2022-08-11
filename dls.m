function idls=dls(mtime);
% function idls=dls(mtime);
% Determine if the present mtime is in ST or DT (British Columbia)
% If ST, then idls=0 (hours), e.g. PST=UTC-8/24 = UTC-8/24+dls(mtime)/24
% If DT, then idls=1,         e.g. PDT=UTC-7/24 = UTC-8/24+dls(mtime)/24
year=str2num(datestr(mtime,'yyyy'));
if year<2007, 
   A=calendar(year,4);
   day=min(A(find(A(:,1)>0),1)); % thru 2006, first Sunday in April
   sdls=datenum(year,4,day,2,0,0); % 2 AM
   A=calendar(year,10);
   day=max(A(:,1)); % last Sunday in October
   edls=datenum(year,10,day,2,0,0); % 2 AM
else 
   A=calendar(year,3);
   day=min(A(find(A(:,1)>7),1)); % starting 2007, second Sunday in March
   sdls=datenum(year,3,day,2,0,0); % 2 AM
   A=calendar(year,11);
   day=min(A(find(A(:,1)>0),1)); % first Sunday in November
   edls=datenum(year,11,day,2,0,0); % 2 AM
end
idls=1;
if mtime < sdls | mtime > edls, idls=0; end
% fini