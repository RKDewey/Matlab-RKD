% script to read and plot ctd info, one cast per page for JdF (1998)
% prof = [start end} profile numbers to plot
% RKD 12/98

iyr=1998;
tr=[6 13];
sr=[29 35];
sigtr=[21.5 27.5];
for i=prof(1):prof(2),
   clf;orient tall
   [dd mm]=dmy(time(i),iyr);
   hr=(dd-fix(dd))*24;
   min=(hr-fix(hr))*60;
   hr=fix(hr);
   sec=fix((min-fix(min))*60);
   min=fix(min);
   pos=[num2str(fix(lat(i))) '^o ' num2str((lat(i)-fix(lat(i)))*60) '   ' ...
        num2str(fix(long(i))) '^o ' num2str((long(i)-fix(long(i)))*60)];
   titl=[num2str(fix(dd)) '/' num2str(mm) '/1998'];
   mmt=minmax(T(:,i));
   mms=minmax(S(:,i));
   mmst=minmax(sigt(:,i));
   if mmt(1) < tr(1)-1 | mmt(2) > tr(2)+1 |...
         mms(1) < sr(1)-0.5 | mms(2) > sr(2)+0.5 | ...
         mmst(1) < sigtr(1)-0.25 | mmst(2) > sigtr(2) +0.25,
      plttsd3(P(:,i),T(:,i),S(:,i),sigt(:,i),[1.8 1 1],[titl '  Cast: ' num2str(cast(i))]);
   else
      plttsd3(P(:,i),T(:,i),S(:,i),sigt(:,i),[1.8 1 1],[titl '  Cast: ' num2str(cast(i))],[6 13],[29 35],[21.5 27.5],6);
   end
   grid on
   subplot(2.25,2,3);
   jdfcoast([-125 -(122+40/60) 48+5/60 49+5/60]);
   plot(abs(long(i)),lat(i),'k*');
   ht=text(125.2,47.5,'Cruise: CCCS Vector 9832');set(ht,'Clipping','off');
   ht=text(125.2,47.35,['CTD: UBC GuildLine, Cast: ' num2str(cast(i))]);set(ht,'Clipping','off');
   ht=text(125.2,47.2,['Time: ' titl ' ' num2str(hr) ':' num2str(min) ':' num2str(sec)]);set(ht,'Clipping','off');
   ht=text(125.2,47.05,['Position: ' pos]);set(ht,'Clipping','off');
   subplot(2.1,2,4);
   tsplot(T(:,i),S(:,i),1);
   pltdat
   drawnow
   if i==prof(1),
      print -dpsc2 ctdplots.ps
   else
      print -dpsc2 -append ctdplots.ps
   end
end
% fini
