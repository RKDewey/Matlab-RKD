function [psa,fa,ci]=binavgps(pspec,f,ndof);
% [phia,fa,ci]=binavgps(pspec,f,ndof);
% Function to binaverage a power spectra into increasing sizes of
% frequency (x) axis size bins
% if ndof passed as degrees of freedom, then
% ci.mid/low/hi are vectors of the ci.
%
if nargin<3, ndof=3; end % assume 3 overlapping spectra averaged to get original ps
n2=length(f);
fravg=10^(ceil(min(log10(f)))+0.5);
favg=0;
pca=0;
paca=0;
navg=1;
iavg=0;
inew=0;
[plow,phi]=chisqp(ndof,95.);
cmid=min(pspec)/plow;
pmaxc=cmid*phi;
for i=1:n2-1
    if f(i) <= fravg
       iavg=iavg+1;
       favg=favg+f(i);
       pca=pca+pspec(i);
       if iavg == navg
          inew=inew+1;
          fa(inew)=favg/navg;
          psa(inew)=pca/navg;
          cf(inew)=cmid;
          cfl(inew)=cmid*plow;
          cfh(inew)=cmid*phi;
          iavg=0;
          favg=0;
          pca=0;
       end
    else
       if iavg >= 1
         inew=inew+1;
         fa(inew)=favg/iavg;
         psa(inew)=pca/iavg;
         cf(inew)=cmid;
         cfl(inew)=cmid*plow;
         cfh(inew)=cmid*phi;
       end
       iavg=0;
       favg=0;
       pca=0;
       navg=navg*2;
       ndof=ndof*2;
       [plow,phi]=chisqp(ndof,95.);
       fravg=10^(log10(fravg)+0.5);
    end
end
ci.mid=cf;ci.low=cfl;ci.hi=cfh;