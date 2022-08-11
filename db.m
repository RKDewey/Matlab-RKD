function xdb=db(x)
% function xdb=db(x)
% returns the db of x where
% xdb = 20*log10(|x|)
% RKD 1/97
xdb = 20*log10(abs(x));
% xdbmm = minmax(xdb);
% if xdbmm(1) < 0, xdb = xdb - xdbmm(1); end
% fini