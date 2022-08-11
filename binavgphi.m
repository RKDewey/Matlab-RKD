function [psa,fa]=binavgphi(pspec,f);
% [phia,fa]=binavgphi(pspec,f);
% Function to binaverage a power spectra into increasing sizes of
% frequency (x) axis size bins
%
n2=length(f);
fravg=10^(ceil(min(log10(f)))+0.5);
favg=0;
pca=0;
paca=0;
navg=1;
iavg=0;
inew=0;
for i=1:n2-1
    if f(i) <= fravg
       iavg=iavg+1;
       favg=favg+f(i);
       pca=pca+pspec(i);
       if iavg == navg
          inew=inew+1;
          fa(inew)=favg/navg;
          psa(inew)=pca/navg;
          iavg=0;
          favg=0;
          pca=0;
       end
    else
       if iavg >= 1
         inew=inew+1;
         fa(inew)=favg/iavg;
         psa(inew)=pca/iavg;
       end
       iavg=0;
       favg=0;
       pca=0;
       navg=navg*2;
       ndof=ndof*2;
       fravg=10^(log10(fravg)+0.5);
    end
end
