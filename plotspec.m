function [pxx,f,cm]=plotspec(p,fs)
%  [pxx,f,cm]=plotspec(p,fs)
%	p = output from SPECTRUM
%	fs = sample frequency
%  PLOTSPEC plots the autospectrum from SPECTRUM function.
%  Differs from SPECPLOT provided w/ Matlab as follows:
%   *  'Square' loglog instead of 'normal' semilog plot
%   *  Ordinate and abscissa have same number of decades
%   *  Scales the Fourier coefficients with fs so that ordinate
%	properly indicates the units X^2/Hz, X^2/cph, X^2/cpd etc,
%	based on fs.
%   *  Plots a single confidence interval, based on the mean of the
%	intervals estimated by SPECTRUM at each frequency.
%   *  Axis labels and title are not written.
%
%  Returns re-scaled pxx, frequency axis f and cm=mean((pxx+c)/pxx)
%   where c is the vector of confidence estimates from SPECTRUM
%
%  ***  This version only plots Pxx.
%
%  ***  Version 1  16/Jul/91  G.lagerloef

[n,m]=size(p);
if nargin < 2, fs=1; end;

%  Because the first 2 elements Pxx returned by SPECTRUM are equal, only
%  points (2:n) should be plotted, hence length f-axis is n-1.

%  Determine frequency scale
df=(fs/2-fs/2/n)/(n-2);  %   frequency interval
f=(fs/2/n:df:fs/2)';  %  frequency axis

%  Re-scale units of p, get rid of first row
dt=1/fs;  p=(2*dt).*p(2:n,:);
%  then, let
pxx=p(:,1);  c=p(:,2);

%  Determine the axis scales
prange=[floor(min(log10(pxx))) ceil(max(log10(pxx)))];
frange=[floor(min(log10(f))) ceil(max(log10(f)))];
pdec=prange(2)-prange(1); fdec=frange(2)-frange(1);
ndecad=max(pdec,fdec);
frange(2)=frange(2)+1;  frange(1)=frange(2)-ndecad;
prange(1)=prange(2)-ndecad;
axis('square'); axis([frange prange]);

%  Determine confidence limits as ratio to spectral estimates
%  [ref: Jenkins & Watts, pp 254-255], and then average:
%  This is really a kludge way of using the confidence estimate from
%  Spectrum, which assumed the spectral estimators are Gaussian
%  rather than Chi-sqrd.  Lower lim = 1/(upper lim) is clumsy way
%  of approximating Chi-sq.
cm=mean((pxx+c)./pxx);
ton=ones(2,1).*10^(prange(1)+2);
chi=ton*cm;  
clo=ton/cm; 
conf=[clo chi];
fc=(1:2).*.5.*10.^(frange(1)+1);  % dummy f-scale for confidence interval plot

%  Generate an f^-2 line
line=(f.^(-2))*10.^(prange(1)+2);

%  Now plot:
tx=10^(frange(1)+1.1); ty=10^(prange(1)+2);
loglog(f,pxx,f,line,fc,conf,'-g',fc,ton,':g'),text(tx,ty,'95%'),

%  Free the axis
axis('normal'),axis;