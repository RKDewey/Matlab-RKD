function KD=GDAY(IDD,IMM,IYY,ICC)
%function KD=GDAY(IDD,IMM,IYY,ICC)
%
%  THE DAY#, KD BASED ON THE GREGORIAN CALENDAR.
%  THE GREGORIAN CALENDAR, CURRENTLY 'UNIVERSALLY' IN USE WAS
%  INITIATED IN EUROPE IN THE SIXTEENTH CENTURY. NOTE THAT GDAY
%  IS VALID ONLY FOR GREGORIAN CALENDAR DATES.
%
%  KD=1 CORRESPONDS TO JANUARY 1, 0000
%
%	Note that the Gregorian reform of the Julian calendar 
%omitted 10 days in 1582 in order to restore the date
%of the vernal equinox to March 21 (the day after
%Oct 4, 1582 became Oct 15, 1582), and revised the leap 
%year rule so that centurial years not divisible by 400
%were not leap years.
%
%THIS ROUTINE WAS WRITTEN BY EUGENE NEUFELD, AT IOS, IN JUNE 1990.
%
  NDP=[0 31 59 90 120 151 181 212 243 273 304 334 365];
  NDM=[31 28 31 30 31 30 31 31 30 31 30 31];
%
  LP = 6;
%TEST FOR INVALID INPUT:
  if ICC<0, error('Centruy must be > 0'); end
  if IYY<0 | IYY>99, error('Year must be >=0 & <=99'); end
  if IMM<=0 | IMM>12 , error('Month must be >0 & <13'); end
  if IDD<=0, error('Day must be >=0'); end
  if IMM~=2 & IDD>NDM(IMM), error('Not a valid day on month'); end
  if IMM==2 & IDD>29, error('Not a valid day on month'); end
  if IMM==2 & IDD> 28 &((IYY/4)*4-IYY ~= 0 | (IYY==0 & (ICC/4)*4-ICC ~= 0)),
	     error('Not a valid day on month'); end
%CALCULATE DAY# OF LAST DAY OF LAST CENTURY:
  KD = ICC*36524 + (ICC+3)/4;
%CALCULATE DAY# OF LAST DAY OF LAST YEAR:
  KD = KD + IYY*365 + (IYY+3)/4;
%  ADJUST FOR CENTURY RULE:
%  (VIZ. NO LEAP-YEARS ON CENTURYS EXCEPT WHEN THE 2-DIGIT
%  CENTURY IS DIVISIBLE BY 4.)
    if (IYY > 0 & (ICC-(ICC/4)*4)~=0), KD=KD-1; end
%  KD NOW TRULY REPRESENTS THE DAY# OF THE LAST DAY OF LAST YEAR.
%  CALCULATE DAY# OF LAST DAY OF LAST MONTH:
    KD = KD + NDP(IMM);
%  ADJUST FOR LEAP YEARS:
    if (IMM>2 & ((IYY/4)*4-IYY)==0 & ((IYY ~= 0)|(((ICC/4)*4-ICC)==0))), KD=KD+1; end
%  KD NOW TRULY REPRESENTS THE DAY# OF THE LAST DAY OF THE LAST MONTH.
%
%  CALCULATE THE CURRENT DAY#:
    KD = KD + IDD;
% fini
