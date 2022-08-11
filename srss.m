function suntime=srss(jd,location,strornum);
% function suntime=srss(jday,location,strornum);
% Caculate the time of sun-rise and sun-set for a given integer mtime julian day
%   location.latitude=48 (+N) location.longitude=-123 (+E)
%   location.altitude=0 [m] location.UTC=-8 [hrs to desired time zone for ST]
% is strornum==1, then pass back datestr, ==2 datenum
% uses sun_position(mtime(UTC),location)
disp(['Calculating sunrise/set wall clock time for day: ',datestr(jd)]);
t=jd+[1:1440]/(24*60);
a=sun_position(t,location);
b=a.zenith-90;
sr=t(find(min(abs(b(1:720)))==abs(b(1:720))));
ss=t(find(min(abs(b(720:1440)))==abs(b(720:1440)))+719);
utc=location.UTC;
if strornum==1,
   suntime(1,:)=datestr(sr+utc/24+dls(sr)/24,0);
   suntime(2,:)=datestr(ss+utc/24+dls(ss)/24,0);
   if sr<ss,
      st1=suntime(1,:);
      suntime(1,:)=suntime(2,:);
      suntime(2,:)=st1;
   end
else
   suntime(1)=(sr+utc/24+dls(sr)/24);
   suntime(2)=(ss+utc/24+dls(ss)/24);
end
% fini