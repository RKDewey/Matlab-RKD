function pscalendar(imon,iyear,sp,location)
% function pscalendar(imon,iyear,[m,n,p],location)
% 
% function to generate a plot (postscript file) with
% a calendar month or year on a single page. For a single
% month, the plot is landscape, while for a year,
% the orientaion is portrait (tall).
% For an entire year, pscalendar(iyear), or set imon=0
% or just pscalendary for the present year.
% If subplot parameters are passed [m,n,p], orientation is user defined. 
% Optional parameter structure location, used by sun_position.m where (default)
%   location.latitude=48 (+N) location.longitude=-123 (+E)
%   location.altitude=0 [m] location.UTC=-8 [hrs to desired time zone for ST]
%   OR [] (empty) for no sun-rise sun-set times
% RKD 6/99
if nargin<1, cyear=date; iyear=str2num(cyear(end-3:end)); imon=0; sp=[]; location=[]; end
if nargin==1, iyear=imon; imon=0; sp=[]; location=[]; end
if nargin==2, sp=[]; location=[]; if (imon>1900&iyear<13),iy=imon;imon=iyear;iyear=iy;end; end
if nargin==3, 
    location.latitude=48;
    location.longitude=-123;
    location.altitude=0;
    location.UTC=-8;
end
mon=[' January ';
     'February ';
     '  March  ';
     '  April  ';
     '   May   ';
     '   June  ';
     '   July  ';
     '  August ';
     'September';
     ' October ';
     'November ';
     'December '];
day=['Sun';'Mon';'Tue';'Wed';'Thu';'Fri';'Sat'];
%
mm=2*29.5306;
fs0=20;
if ~isempty(sp),
   totn=sp(1)*sp(2);
   if totn>4, fs0=16; end
   if totn>6, fs0=12; end
end
fs1=fix(fs0*0.8);
fs2=fix(fs0*0.6);
fs3=fix(fs0*0.5);
fs4=fix(fs0*0.4);
fs5=fix(fs0*0.3);
if imon==0, % then do an entire year
   if isempty(sp), figure(1);clf; orient tall; end
   for jmon=1:12
      A=calendar(iyear,jmon);
      [m,n]=size(A);
      subplot1(4,3,jmon,0.1,0.1,0.1,0.1);hold on
      for i=0:7
         plot([i i],[0 6],'k');
      end
      for j=0:6
         plot([0 7],[j j],'k');
      end
      axis([0 7 0 7]);axis off
      th=text(3.5,6.95,mon(jmon,:));
      set(th,'FontSize',fs2,'FontName','times','HorizontalAlignment','center');
      for iday=1:7
         th=text((iday-0.5),6.3,day(iday,:));
         set(th,'FontSize',fs3,'FontName','times','HorizontalAlignment','center');
      end
      irow=6;
      for idm=1:m
         irow=irow-1;
         for idn=1:7
            if A(idm,idn)~=0,
               th=text(idn-0.7,irow+0.7,num2str(A(idm,idn)));
               set(th,'FontSize',fs4,'FontName','times','HorizontalAlignment','center');
               jd=julian([A(idm,idn) jmon iyear],[0 0 0]);
               if ~isempty(location),
                   suntime=getriseset(datenum(iyear,imon,A(idm,idn)),location);
                   th(1)=text(idn-0.75,irow+0.45,suntime(1,:));
                   th(2)=text(idn-0.25,irow+0.45,suntime(2,:));
                   set(th(:),'FontSize',fs5/1.6,'FontName','times','HorizontalAlignment','center');
               end
               th=text(idn-0.3,irow+0.2,num2str(fix(jd)));
               set(th,'FontSize',fs5,'FontName','times','HorizontalAlignment','center');
               nq=moonphase(datenum(iyear,jmon,A(idm,idn),12,0,0));
               if nq<(1/mm) | abs(nq-0.25)<(1/mm) | abs(nq-0.5)<(1/mm) | abs(nq-0.75)<(1/mm) | abs(nq-1) <(1/mm),
                  pltmphase(idn-0.15,irow+0.85,0.075,nq);
               end
            end
         end
      end
      if jmon==2,
         th=text(3.5,8,num2str(iyear));
         set(th,'FontSize',fs1,'FontName','times','HorizontalAlignment','center');
      end
   end
else
% The Num Rec routines flmoon.m and jday.m can be used to
% figure out the phases of the moon in terms of absolute Julian Day.
% flmoon(1236,0)-(jday(7,12,1999) - 0.5 + 23/24 + 1/(24*60) + 44.15491/(24*60*60)) = 0
% tells us that Dec 7, 1999 at 23:02:44.15491 UTC is a new moon
% The synodic month (time between exact phases is 
% flmoon(2,0) - flmoon(1,0) = 29.41908687679097 days
% or (roughly) 2541809.106 seconds. 
% So now we can calculate the moon phases for noon on any date/time.
% Namely,
   if isempty(sp), 
      figure(1);
      clf; 
      orient landscape; 
   elseif sp(3)==1,
      figure(1);
      clf;
   end
   jmon=imon;
   A=calendar(iyear,jmon);
   [m,n]=size(A);
   if sum(A(m,:))==0, m=m-1; end
   if isempty(sp), 
      subplot1(1,1,1,0.1,0.1,0.1,0.1);
   else
      subplot1(sp(1),sp(2),sp(3),.25,.25,.25,.25);
   end
   hold on
   for i=0:7
       plot([i i],[0 m],'k');
   end
   for j=0:m
       plot([0 7],[j j],'k');
   end
   axis([0 7 0 m+.5]);axis off
   th=text(3.5,m+0.6,[mon(jmon,:),'  ',num2str(iyear)]);
   if isempty(sp),
      set(th,'FontSize',fs0,'FontName','times','HorizontalAlignment','center');
   else
      set(th,'FontSize',fs1,'FontName','times','HorizontalAlignment','center');
   end
   
   for iday=1:7
      th=text((iday-0.5),m+0.2,day(iday,:));
      set(th,'FontSize',fs2,'FontName','times','HorizontalAlignment','center');
   end
   irow=m;
   for idm=1:m
      irow=irow-1;
      for idn=1:7
         if A(idm,idn)~=0,
            th=text(idn-0.7,irow+0.7,num2str(A(idm,idn)));
            set(th,'FontSize',fs2,'FontName','times','HorizontalAlignment','center');
            jd=julian([A(idm,idn) jmon iyear],[0 0 0]);
            if ~isempty(location),
                suntime=getriseset(datenum(iyear,imon,A(idm,idn)),location);
                th(1)=text(idn-0.8,irow+0.9,suntime(1,:));
                th(2)=text(idn-0.2,irow+0.9,suntime(2,:));
                set(th(:),'FontSize',fs4,'FontName','times','HorizontalAlignment','center');
            end
            th=text(idn-0.3,irow+0.15,['JD',num2str(fix(jd))]);
            set(th,'FontSize',fs4,'FontName','times','HorizontalAlignment','center');
             nq=moonphase(datenum(iyear,jmon,A(idm,idn),12,0,0));
             if nq<(1/mm) | abs(nq-0.25)<(1/mm) | abs(nq-0.5)<(1/mm) | abs(nq-0.75)<(1/mm) | abs(nq-1) <(1/mm),
                pltmphase(idn-0.15,irow+0.75,0.075,nq);
             end
          end
      end
   end
end
%======
function pm=moonphase(mtime);
% function pm=moonphase(mtime);
% Determine if phase of Moon for any day (UTC)
% Base on 
%   J.Chapront, M.Chapront-Touzé, G.Francou: 
%     "A new determination of lunar orbital parameters, precession content, 
%     and tidal acceleration from LLR measurements". 
%     Astron. Astrophys. 387, 700..709 (2002)
m0=datenum(2000,1,1,0,0,0);  % This formula uses Jan 1 2000 as start
dt=mtime-m0; % number of days since Jan 1 2000
aN=fix(dt/29.4); % approximate number of new moons
N=[aN-2:aN+20]; % N is the integer number of new moons since 2000-1-1 00:00:00 
% D are the julian days since Jan 1 2000 of the new moons 
D=(5.597661-0.000739)+29.530588861.*N +((1.02026-2.35)*1e-14).*N.^2;
n1=max(find(D<dt)); % find last new moon
pm=(dt-D(n1))/(D(n1+1)-D(n1)); % this is phase of moon between 0 - 1.
%
function pltmphase(x,y,r,nq);
% function pltmphase(x,y,r,nq);
% Routine to plot a circle representing the moon at a particular phase,
% centred at (x,y) with plot units radius r
% Phases are relative to a new moon (nq=0) and range from full at -0.5 and 0.5
% to 3rd (last) quarter at -0.25 and 1st quarter at 0.25
hold on
[xs,ys,zs]=sphere(359);
xs=xs*r;zs=zs*r;
[xc,yc]=vector(r*ones(size([0:360])),[0:360]*(pi/180),1);
plot(x+xc,y+yc,'k'); % plot the moon (outside line)
nf=abs(nq)*2; % determine the fraction to fill (0-1)
mm=2*29.5306;
if nq<(1/mm) | abs(nq-1.0) < (1/mm), % new moon, all filled
   fill(x+xc,y+yc,'k');
elseif abs(nq-0.25) < (1/mm), % last quarter
   xc1=xs(:,1);yc1=zs(:,1); % fill from left to ...
   nd=180-floor(90); % this fraction of semi-sphere
   xc2=flipud(xs(:,nd));yc2=flipud(zs(:,nd));
   fill(x+[xc1;xc2],y+[yc1;yc2],'k');
elseif abs(nq-0.5) < (1/mm),
   return % full moon, no fill    
elseif abs(nq-0.75) < (1/mm), % first quarter
   xc1=xs(:,180);yc1=zs(:,180); % fill from right to ...
   nd=ceil(90); % this fraction of a semi-sphere
   xc2=flipud(xs(:,nd));yc2=flipud(zs(:,nd));
   fill(x+[xc1;xc2],y+[yc1;yc2],'k');
end
% fini
function suntime=getriseset(jd,location);
% function suntime=getriseset(jd,location);
% function to pass back suntime(1:2,5)=sunrise/sunset (HH:MM)
% uses sun_position(mtime(UTC),location)
disp(['Calculating sunrise/set for day: ',num2str(jd)]);
t=jd+[1:1440]/(24*60);
a=sun_position(t,location);
b=a.zenith-90;
sr=t(find(min(abs(b(1:720)))==abs(b(1:720))));
ss=t(find(min(abs(b(720:1440)))==abs(b(720:1440)))+719);
utc=location.UTC;
suntime(1,:)=datestr(sr+utc/24+dls(sr)/24,15);
suntime(2,:)=datestr(ss+utc/24+dls(ss)/24,15);
jd1=datenum(suntime(1,:),'HH:MM');
jd2=datenum(suntime(2,:),'HH:MM');
if jd2<jd1,
    st1=suntime(1,:);
    suntime(1,:)=suntime(2,:);
    suntime(2,:)=st1;
end
% fini
