function jd=flmoon(n,q);
% function JD=flmoon(N,Q);
% Routine to return the julian day of the Nth occurane of the 
% phase Q (0=new, 1=1st quarter,2=full, 3=3rd quarter) since 
% January 1 00:00:00 1990 UTC (middle of Julian Day 2415020)
% Taken from Numerical Recipes, Julian Days start at noon!
% RKD 6/99
rpd=pi/180.0;
c=n+q/4;
t=c/1236.85;
t2=t^2;
as=359.2242 + 29.105356*c;
am=306.0253 + 385.816918*c + 0.01073*t2;
jd=2415020 + 28*n +7*q;
xtra=0.75933 + 1.53058868*c + (1.178e-4 - t*1.55e-7)*t2;
if (q==0 | q==2),
   xtra=xtra+(0.1734 - t*3.93e-4)*sin(rpd*as) - 0.4068*sin(rpd*am);
else
   xtra=xtra+(0.1721 - t*4.0e-4)*sin(rpd*as) - 0.6280*sin(rpd*am);
end
jd=jd+xtra;
% fini
