function [ID,IM]=dmy(JULN1,IYYY);
%function [id im]=dmy(julian,IYYY)
%
% function TO GO FROM JULIAN (JAN 1=1.#) TO ID,IM
%	R.DEWEY (02/03/90)
NDP=[0 31 59 90 120 151 181 212 243 273 304 334 365];
MM=max(find(NDP<fix(JULN1)));
  IGREG=15+31*(10+12*1582);
  if IYYY==0, error('There is no Year Zero.'); end
  JY=IYYY-1;
  JM=14;
  JULDAY=fix(365.25*JY)+fix(30.6001*JM)+1+1720995;
  if (1+31*(MM+12*IYYY) > IGREG),
     JA=fix(0.01*JY);
     JULDAY=JULDAY+2-JA+fix(0.25*JA);
  end
  JAN1=JULDAY-1;
  JULIAN=JULN1+JAN1;
  IGREG=2299161;
  if (JULIAN >= IGREG),
    JALPHA=fix(((JULIAN-1867216)-0.25)/36524.25);
    JA=JULIAN+1+JALPHA-fix(0.25*JALPHA);
  else
    JA=JULIAN;
  end
  JB=JA+1524;
  JC=fix(6680.+((JB-2439870)-122.1)/365.25);
  JD=365*JC+fix(0.25*JC);
  JE=fix((JB-JD)/30.6001);
  ID=JB-JD-fix(30.6001*JE);
  IM=JE-1;
  if (IM > 12),IM=IM-12; end
 % fini
