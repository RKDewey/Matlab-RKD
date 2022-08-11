function jd=jday(id,im,iyyyy);
% function jd=jday(id,im,iyyyy);
% Routine to calculate absolute Julian Day (NumRec)
% which is defined from Oct 15, 1582 and
% STARTS at noon. 
% Julian day 1 started at noon on Jan 1, 4713 BC!
% RKD 6/99
jy=iyyyy;
if jy==0, error('There is no 0 (zero) year'); end
if jy<0, jy=jy+1; end
if im > 2, 
   jm=im+1;
else
   jy=jy-1;
   jm=im+13;
end
jd=fix(365.25*jy) + fix(30.6001*jm) + id+1720995;
if id+31*(im+12*iyyyy) > (15+31*(10+12*1582)),
   ja=fix(0.01*jy);
   jd=jd+2-ja+fix(0.25*ja);
end
% fini
