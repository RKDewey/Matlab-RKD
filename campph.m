function [ampc,phc]=campph(chi1,ph1,chi2,ph2)
% function [ampc,phc]=campph(chi1,ph1,chi2,ph2)
% calculate the complex scattered signal given
% a point believed to be scattered (chi1,ph1) and
% the nearest "direct" path non-scattered (chi2,ph2)
% where ampc may need to be ln() and phc is in radians
% RKD 2/97
[r1 i1]=vector(exp(chi1),ph1*(pi/180),1);
[r2 i2]=vector(exp(chi2),ph2*(pi/180),1);
ccor=(r1-r2) + sqrt(-1)*(i1-i2);
[ampc phc]=vector((r1-r2),(i1-i2),0);
% fini



