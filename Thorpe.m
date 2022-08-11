function [Th,ptb,thinfo]=Thorpe(P,T,S,tests,dp,dd,rl,zeta);
% function [Th,ptb,thinfo]=Thorpe(P,T,S,tests,dp,dd,rl,zeta);
% 
% Function to calculate the Thorpe scale for a CTD cast
% Input parameters are:
% 		P = pressure or depth vector (only down cast is analyzed)
% 		T = temperature values
%		S = salinity values
% Optional Input:
%		dp = vertical resolution of pressure sensor (default = 0.1 m)
%		dd = density resolution for CTD (default = 0.001 kg/m^3)
%		rl = run-length parameter in points. Zero (0) to estimate (otherwise = 7)
%		zeta = T-S tightness parameter (default = 0.5)
%		tests = input 1 to check for spurious overturns, and 0 to accept all overturns
% Output:
%		Th(1:N) The N Thorpe scales from this cast
%		ptb(1:N,1:2) The top and bottom pressures of the Thorpe Overturns
%		thinfo is a structure containing -
%			dzth:  A cell array of the thorpe displacements corresponding to each overturn
%			prof and profs:  The unsorted and sorted profile that was used to find overturns
%			p:  The corresponding pressures for prof and profs
%			csdz: The cumulative sum of the thorpe displacements
%
% Note: The program works assuming that the profile increases with depth. If this is not the case
% there is a flag called 'neg' within the code that can be set to 1. If the profile increases with
% depth, then 'neg' should be set to 0.
%
% RKD + Conor Shaw 5/02
%
% References:
% Stansfield, Garrett and Dewey, Journal of Physical Oceanography, vol. 31, pp. 3421-3434
% Galbraith,P.S. and D.E. Kelley, J. Atmos. Oceanic Technol., vol. 13, pp. 688-702
%
if nargin < 4, tests=1; end
if nargin < 5, dp=0.1; end
if nargin < 6, dd=0.001; end
if nargin < 7, rl=7; end
if nargin < 8, zeta=0.5; end
%
cs=1; % This is the run length of cumsum(dz)
neg=0; % This is a flag to indicate whether the profile decreases with depth or not.
%
% Now calculate the Thorpe scales...
%
P=flt(P,5); %Filter the pressure to remove some of the pressure reversals
ip=1;pmax=P(1);p(1)=P(1);t(1)=T(1);s(1)=S(1);
% Take only first occurence of each pressure to eliminate the rocking of the boat.
for i=2:length(P),
   if P(i)>pmax,
      ip=ip+1;
      p(ip)=P(i);
      t(ip)=T(i);
      if S~=0, s(ip)=S(i); end
      pmax=P(i);
   end
end
%
dzbar=(max(p)-min(p))/(length(p)-1); %Average separation between pressure entries
%
skip=0; % set skip = 1 to do interpolation
if skip==1,
   pp=[p(1):dzbar:p(end)]; % use the effective vertical resolution in the data
   ti=interp1(p,t,pp); %interpolate data to give a uniformly spaced pressure and temp. series.
   if S==0
	   p=pp;
	else
      si=interp1(p,s,pp); %interpolate data to give a uniformly spaced pressure and salin. series.
      p=pp;
	end
t=ti; if s~=0, s=si; end
end  % skip interpolation
%
if S==0   %if 0 salinity has been passed, then use the temperature profile to calculate thorpe overturns.
   prof=t;
else
	sigt=Th_sigmat(Th_pot_t(s,t,p,0),s);  %call Th_sigmat routine to calculate sigma_t from t and s.
   prof=sigt;
end
%
if neg==1,			%sort profile that decreases with depth and keep record of original indices.
   prof1=-prof;
   [profs,indxs]=sort(prof1);
   profs=-profs;
else
   [profs,indxs]=sort(prof); %sort profile that increases with depth and keep record of original indices.
end
dz=p(indxs)-p; %calculate difference of sorted pressure from recorded pressure
thinfo.dz=dz; %Send dz to thinfo structure
Lt_wc=Th_rms(dz); %calculate the Thorpe Scale of the entire water column
csdz=cumsum(dz); %find the cumulative sum of the pressure differences
csdz(end)=0; %ensures that the sum goes back to zero at the end of the profile
%
%The following code finds where the csdz is more than a threshold of cs and identifies the endpoints
%between these regions as the end of an overturn. The threshold of cs is used in order to minimize noise
%picked up as an overturn.
%
eps=1e-3;
ind1=find(csdz > cs);
ind0=find(csdz < eps);
if isempty(ind1) %If there are no large enough overturns
   disp('There are no large enough Thorpe overturns for the given runlength.')
   Th=[];
   ptb=[];
   thinfo.rlot={0};thinfo.rlght=0;
   return
end
%
%The next few lines identifies the endpoints of the regions greater than cs (found above) as the end of an overturn.
%The length of ind1 is made the last entry of ind2 to ensure that the final overturn is identified.
%
ind2=[find(diff(ind1)>1) length(ind1)]; 
indx(1,:)=[1 ind2(1)];
if length(ind2)>1,
   for i=1:length(ind2)-1
      indx(i+1,:)=[ind2(i)+1 ind2(i+1)];
   end
end
ithot=ind1(indx); %The indices of the beginning and end of the overturns are found in terms of ind1.
extra=ithot;
%This loop finds the true beginnings and ends of the overturns, which should be where the cumsum is equal to zero.
%Because the cumsum doesn't always come back exactly to zero, the beginnings and ends are marked as the points where
%the cumsum comes below eps.
for i=1:length(ithot(:,1))
   i01=max(find(ind0<ithot(i,1)));
   i02=min(find(ind0>ithot(i,2)));
   if isempty(i01),itop=1;  
   else itop=ind0(i01); end
   ibot=ind0(i02); 
   ithot(i,:)=[itop ibot];
end
%
idel=find(diff(ithot(:,1))==0); %This finds any overturns that have been identified more than once.
del=idel+1;
ithot(del,:)=[]; %Delete the repeated overturns.
if length(ithot(:,1))>1
	for i=1:length(ithot(:,1))-1    %This finds any spots where an overturn ends and another begins
   	rpt(i)=ithot(i+1,1)-ithot(i,2); %on the same point.
	end
	rpti=find(rpt==0);rpti=rpti+1; 
	ithot(rpti,1)=ithot(rpti,1)+1; %The beginning index of the overturn that begins on the same point as 
   										 %the last one ended on is shifted forward one point.
end
[m,n]=size(ithot);
for i =1:m,
   Th(i)=Th_rms(dz(ithot(i,1):ithot(i,2))); %The Thorpe Scales are calculated.
   dzth(i)= {dz(ithot(i,1):ithot(i,2))};
end
ptb=p(ithot); %This finds the pressure at the beginning and end of each overturn.
%
if tests==1
	% Now check for pressure and density resolution 
	%
	if length(Th)>0,
	% pressure resolution
	if dp > 0.0,  % then check pressure resolution
	   indx=find(abs(ptb(:,2)-ptb(:,1))<dp);
	   if ~isempty(indx);
	      disp([num2str(length(indx)),' Thorpe Overturns below Pressure resolution.']);
         ii=0;igood=[];ib=0;ibad=[];
         for i=1:length(Th),
            if isempty(find(indx==i)), ii=ii+1;igood(ii)=i;else ib=ib+1; ibad(ib)=i; end;
         end
	      Thgood=Th(igood);Th=Thgood; %Keep only Thorpe scales of overturns that passed the test.
	      ptbgood=ptb(igood,:);ptb=ptbgood; %Keep only depth ranges of overturns that passed.
         dzthgood=dzth(igood);dzth=dzthgood; %Keep only Thorpe fluctuations of overturns that passed.
         ithotbad=ithot(ibad,:);%Keep record of top and bottom indices of rejected overturns (For recalculating Lt_wc later)
      end
	end
	end
	ddp=2; % depths range +/- ddp to test Density resolution
   
   if length(Th)>0 & exist('sigt'),
	% T-S tightness test
	if zeta ~= 0.0, % then perform T-S Test
	   indx=[]; % assume none to throw away
	   ii=0;
	   for i=1:length(Th),  % for each Thorpe scale
         inpfit=find(p>(ptb(i,1)) & p<(ptb(i,2))); %Find indices within overturning region
         denstf=sigt(inpfit)-sort(sigt(inpfit)); %Find Thorpe fluctuations within region
	     	[ct,sct]=polyfit(t(inpfit),sigt(inpfit),1);%Fit temperature to linear density curve
	      ddt=sigt(inpfit)-polyval(ct,t(inpfit));%Find difference between fitted curve and actual density.
	     	[cs,scs]=polyfit(s(inpfit),sigt(inpfit),1);%Fit salinity to linear density curve
	     	dds=sigt(inpfit)-polyval(cs,s(inpfit));%Find difference between new fitted curve and actual density.
	      rmstf=Th_rms(denstf);  %Calculate rms Thorpe fluctuation of the region
	      zt=Th_rms(ddt)/rmstf; %Calculate zt(zeta_t)
         zs=Th_rms(dds)/rmstf; %Calculate zs(zeta_s)
	     	z=max([zt zs]);%Find max value of zeta
	     if z > zeta, ii=ii+1; indx(ii)=i; end %Compare to max value of zeta.
	  end
	  if ~isempty(indx);
	     disp([num2str(length(indx)),' Thorpe Overturns unresolved by loose T-S relation.']);
        ii=0;igood=[];ib=0;ibad=[];
        for i=1:length(Th),
           if isempty(find(indx==i)), ii=ii+1;igood(ii)=i; else ib=ib+1;ibad(ib)=i;end;
        end
	     Thgood=Th(igood);Th=Thgood;
	     ptbgood=ptb(igood,:);ptb=ptbgood;
        dzthgood=dzth(igood);dzth=dzthgood;
        ithotbad=ithot(ibad,:);
	   end
	end
	end
	if length(Th)>0,
	% profile resolution (sigma t, temperature,...)
	if zeta ~= 0.0, % then check profile resoution
	   indx=[]; % assume none to throw away
	   ii=0;
	   for i=1:length(Th),  % for each Thorpe scale
	      clear smoothprof smoothp dddz inp
	      inp=find(p>(ptb(i,1)-ddp) & p<(ptb(i,2)+ddp)); %Find depths within overturning range +/- ddp
	      smoothprof=Th_flt(profs(inp),7); %smooth the profile
	      smoothp=Th_flt(p(inp),7); %smooth the pressure
	      dddz=mean(diff(smoothprof)/mean(diff(smoothp)));%Calculate rate of change of density with depth
	      if Th(i)<2*abs(dd/dddz), ii=ii+1; indx(ii)=i; end %Find overturns below Density resolution
	   end
	   if ~isempty(indx);
	      disp([num2str(length(indx)),' Thorpe Overturns below Density resolution.']);
         ii=0;igood=[];ib=0;ibad=[];
         for i=1:length(Th),
            if isempty(find(indx==i)), ii=ii+1;igood(ii)=i;else ib=ib+1;ibad(ib)=i;end;
         end
	      Thgood=Th(igood);Th=Thgood;
	      ptbgood=ptb(igood,:);ptb=ptbgood;
         dzthgood=dzth(igood);dzth=dzthgood;
         ithotbad=ithot(ibad,:);
	   end
	end
	end
   
   % Runlength Test
   if length(Th)>0,
      if rl==0,
         [rld,rlght,rlprob]=Th_rlength(p,prof,neg);
         %code to determine cut off rl
         bins=[1:max(rlght)];thinfo.rlght=rlght;
         noise=2.^(-bins);
         i0=find(rlprob==0);   
			expon=(log10(1/length(rlght)))-1;
         rlprob(i0)=1*10^expon;
         coind=max(find(rlprob<2*noise & rlprob~=1*10^expon));
         nonzero=find(rlprob~=1*10^expon);
         coind1=min(find(nonzero>coind));
         rlco=bins(nonzero(coind1));
     	else
         rlco=rl; %Assign default value of cutoff runlength
      end
      for j=1:length(Th), %For each overturn
         irl(j)={find(p>=ptb(j,1)&p<=ptb(j,2))}; %Find indices within each overturning region
    	   [rldi,rlghti,rlprobi]=Th_rlength(p(irl{j}),prof(irl{j}),neg); rlot(j)={rlghti}; %Find runlengths of overturn. Keep log of runlengths.
         RL(j)=round(Th_rms(rlghti)); %Calculate rms runlength.
      end
      thinfo.rlot=rlot; %store runlengths for each overturn
	   % Runlength check - Gets rid of overturns with RL less than rlco (cutoff runlength)
      if ~isempty(rlco) %If there is a cutoff runlength
	      drl=RL-rlco;
         indx=find(drl<0); %Find runlengths that are less than cutoff runlength.
         if ~isempty(indx)
            idz0=irl{indx(1)};for i=2:length(indx),idz0=[idz0 irl{indx(i)}]; end
         else
            idz0=[];
         end
         dz(idz0)=0; %Set all Thorpe fluctuations of overturns rejected by RL test to 0. Assume any Thorpe flucuations in region are due to noise.
         ltwcrl=Th_rms(dz); %Calculate Lt_wc ignoring Thorpe fluctuations of overturns rejected by RL test.
      else
         indx=find(RL);
         ltwcrl=0; %If all overturns are rejected, Lt_wc is set to 0.
      end
   	%
	   if ~isempty(indx);
	      %disp([num2str(length(indx)),' Thorpe Overturns below RunLength resolution.']);
         ii=0;igood=[];ib=0;ibad=[];
         for i=1:length(Th),
            if isempty(find(indx==i)), ii=ii+1;igood(ii)=i;else ib=ib+1;ibad(ib)=i;end;
         end
	      %Thgood=Th(igood);Th=Thgood;
	      %ptbgood=ptb(igood,:);ptb=ptbgood;
         %dzthgood=dzth(igood);dzth=dzthgood;
         ithotbad=ithot(ibad,:);
	   end
   end
   clear idz0;
   if ~isempty(indx);
      idz0=[ithotbad(1,1):ithotbad(1,2)];
   	for y=2:length(ithotbad(:,1))
         idz0=[idz0 ithotbad(y,1):ithotbad(y,2)]; %Log indices of Thorpe fluctuations of rejected overturns
      end
      dz(idz0)=0; %Set Thorpe fluctuations of rejected overturns to 0. Assume any Thorpe fluctuations in region are due to noise.
      ltwc=Th_rms(dz); %Recalculate Lt_wc
      thinfo.ltwc1=ltwc; %store it.
   else
      thinfo.ltwc1=Lt_wc; %If no overturns are rejected, Lt_wc equals previously calculated Lt_wc
   end
end
%Save various values in thinfo structure (Note: Not all of these values are necessary to save. Some are used in plotting programs like
%thorpeplot.m and thorpetide.m, but some were just for use while I was debugging the program).
thinfo.rlco=rlco;
thinfo.dzth=dzth;
thinfo.prof=prof;
thinfo.profs=profs;
thinfo.p=p;
thinfo.csdz=csdz;
thinfo.ltwc=Lt_wc;
thinfo.ltwcrl=ltwcrl;
thinfo.ithot=ithot;
thinfo.extra=extra;
thinfo.bins=bins;
thinfo.rlprob=rlprob;
thinfo.rlind=nonzero(coind1);
thinfo.expon=expon;
thinfo.RL=RL;
% fini

%These are programs that are called by thorpe.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function rmsx=Th_rms(x)
% function rmsx=Th_rms(x)
% calculates the rms (root mean square) of x
% is robust to NaNs.
% RKD 1/97
nnan=~isnan(x);
xx=abs(x(nnan)).^2;
rmsx=sqrt(mean(xx));
% fini

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function sigma_t = Th_sigmat(t,s);
% SIGMA_T = Th_SIGMAT(T,S) computes sigma-t knowing t (deg C), and s (o/oo).
% From Millero and  Poisson,DSR 28(6a),625 (1981)
%
% checkvalues: s (psu)  t (deg C)  sigma +1000 (kg m^-3)
%                0         5           999.96675
%                0         25          997.04796
%                35        5          1027.67547
%                35        25         1023.34306
%
% Modified May 2, 1988 by RGL
%
% Converted to a matlab function from a fortran subroutine
% June 30, 1993 by TDM
% Function checked with their check values.

a0      =  0.824493;
a1      = -4.0899e-03;
a2      =  7.6438e-05;
a3      = -8.2467e-07;
a4      =  5.3875e-09;

b0      = -5.72466e-03;
b1      =  1.02270e-04;
b2      = -1.65460e-06;

c       =  4.8314e-04;

r0      =   -0.157406;
r1      =    6.793952e-02;
r2      =   -9.095290e-03;
r3      =    1.001685e-04;
r4      =   -1.120083e-06;
r5      =    6.536336e-09;

sigma_t = r0 + r1*t + r2*t.^2 + r3*t.^3 + r4*t.^4 + r5*t.^5 ...
        +(a0 + a1*t + a2*t.^2 + a3*t.^3 + a4*t.^4).*s ...
        +(b0 + b1*t + b2*t.^2).*sqrt(s.^3) ...
        + c*s.^2;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function theta = Th_pot_t (s,t,p,pr);
% THETA = TH_POT_T(S,T,P,PR) computes potential temperature at pr using
% Bryden 1973 polynomial for adiabatic lapse rate
% and Runge=Kutta 4 th order integration algorithm.
% Ref: Bryden,H.1973, DeepSea Research,20etc.
%
% Units:
%       p       pressur dBars
%       t       temp    deg C
%       s       salin   PSU
%       pr      ref press
%       theta   potent.temp deg C
%
% checkvalues: s (psu)  t (deg C)  p (dB)  pr (dB)  theta (deg C)
%               34.75      1.0      4500      0         0.640
%               34.75      1.0      4500     4000       0.944
%               34.95      2.5      3500      0         2.207
%               34.95      2.5      3500     4000       2.558
%
% Converted to a matlab function from a fortran function
% June 30, 1993 by TDM

h = pr-p;
xk = h.*Th_atg(s,t,p);
t = t + 0.5*xk;
q = xk;
p = p + 0.5*h;
xk = h.*Th_atg(s,t,p);
t = t + 0.29289322*(xk-q);
q = 0.58578644*xk + 0.121320344*q;
xk = h.*Th_atg(s,t,p);
t = t + 1.707106781*(xk-q);
q = 3.414213562*xk - 4.121320344*q;
p = p + 0.5*h;
xk = h.*Th_atg(s,t,p);
theta= t + (xk-2.0*q)/6.0;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function atg = Th_atg(s,t,p)
% ATG = ATG(S,T,P) computes the adiabatic temperature gradient deg C/dBar
%
%       pressure        p       dBar
%       temperature     t       Deg C
%       salinity        s       PSU
%       adiabatic       atg     deg C/dBar
%
% Converted to a matlab function from a fortran subroutine
% June 30, 1993 by TDM s = s - 35.0;
atg = (((-2.1687e-16 * t + 1.8676e-14) .* t - 4.6206e-13) .* p ...
    + ((2.7759e-12 * t - 1.1351e-10) .* s + ((-5.4481e-14 * t ...
    + 8.733e-12) .* t - 6.7795e-10) .* t + 1.8741e-8)) .* p ...
    + (-4.2393e-8 * t+1.8932e-6) .* s ...
    + ((6.6228e-10 * t - 6.836e-8) .* t + 8.5258e-6) .* t + 3.5803e-5;
 %
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %
 function xf=Th_flt(x,fpts);
%
% function xf=flt(x,fpts) to low pass filter a time series using filtfilt 
%   passed both ways. 
%   Since filtfilt passes both ways already, this ties both ends
%   of the filtered time series to the original ends.
%	x = array
%	fpts = number of points for filter length (odd) i.e. 3,5,7
%	xf = filtered array
% RKD 12/94

% make a mask for the data that are NaN's
mask=ones(size(x));
idx=isnan(x);mask(idx)=idx(find(idx)).*NaN;
idx=isinf(x);mask(idx)=idx(find(idx)).*NaN;
x=x.*mask;
% chop off leading and trailing NaN's but keep track so they can be put back
%    later.
npts=length(x);
idx1=min(find(~isnan(x))); idx2=max(find(~isnan(x)));
lnan=[];
tnan=[];
if idx1>1
     lnan=x(1:idx1-1);
end
if idx2<npts
     tnan=x(idx2+1:npts);
end
x=x(idx1:idx2);

% clean up any interior gaps by linearly interpolating over them
[x,tcln]=cleanx(x,1:length(x));

% calculate filter weights
Wn=fix(1.5*fpts);
b=fir1(Wn,(1/(fpts*2)));
m=length(x);
% set weights for forward and reverse sum
winc=1./(m-1);
wt1= 1:-winc :0 ;
wt2= 0: winc :1 ;

% calculate forward filter time series, save
xf1=zeros(size(x));
xf1=filtfilt(b,1,x);

% flip (invert) time series, filter, and unflip
xi=zeros(size(x));
xf2=zeros(size(x));

% flip time series but check for horizontal or vertical matrix
[r,c]=size(x);
if r>c
     xi=flipud(x);
else
     xi=fliplr(x);
end

xi=filtfilt(b,1,xi);

if r>c
     xf2=flipud(xi);
else
     xf2=fliplr(xi);
end

xf=zeros(size(x));
if r>c
     xf=xf1.*wt2' + xf2.*wt1';
else
     xf=xf1.*wt2 + xf2.*wt1;
end

% reattach leading and trailing Nan's and apply mask for interior gaps
if r>c
     xf=[lnan
         xf
         tnan];
else
     xf=[lnan xf tnan];
end
xf=xf.*mask;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function [rldepth,runlength,prob]=Th_rlength(p,rho,incdec)
% function [rldepth,runlength,prob]=rlength(p,rho)
% rlength.m   --  Find runs in a density profile rho(p)
% Input: p - Pressure (dbars)
%        rho - CTD profile (density,temperature,etc.)
%        incdec - if profile decreases with depth, set to 1, otherwise, set to 0
%                 (default=0)
% Output: rldepth(1:2,cnt)=[start end] pressures of runs
%         runlength(cnt)=run length in points
%         prob(1:max(runlength)) = probability distribution of run lengths
% GK ==> KS --> RKD
if nargin<3, incdec=0; end
if incdec==0
   [rho1,indx]=sort(rho); %sorts a profile that increases with depth
else
   rhon=-rho;
   [rho1,indx]=sort(rhon); %sorts a profile that decreases with depth
   rho1=-rho1;
end
tf = rho1 - rho;
oldsign=0; first=0; last=0; run=0; rms=0; cnt=0;
for i=1:length(tf),
  if (((tf(i)==0)&(oldsign~=0)) | ((tf(i)>0)&(oldsign==-1)) | ((tf(i)<0)&(oldsign==1))) 
     % end of run on previous data point
     rldepth(:,cnt)=[first ; last];
	  runlength(cnt)=run;
% prepare next run
	  if (tf(i) ~= 0) 
	    first = p(i); 
	    run = 1;
	    cnt=cnt+1;
    else
	    run = 0; % in case we finish without a new run
	  end 
   else  
     if (((tf(i) > 0) & (oldsign == 1)) | ((tf(i) < 0) & (oldsign == -1))) 
% run continues
         run = run+1; 
         last = p(i); 
     else  
       if ((tf(i) ~= 0) & (oldsign == 0)) 
% start new run
			first = p(i); 
         run = 1; 
         cnt=cnt+1; 
       end
     end
  end  
  if (tf(i) > 0) oldsign = 1; end 
  if (tf(i) < 0) oldsign = -1; end
  if (tf(i) == 0) oldsign = 0; end
  last = p(i);
end
if (run > 0)  
   % end of last run with end of file
    rldepth(:,cnt)=[first ; last];
    runlength(cnt)=run;
end
% Now calculate the run length probability distribution
bins=[1:max(runlength)];
prob=hist(runlength,bins)/cnt;
% fini
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%