function [Cchif,tlag,chif]=cchifilt(chi,at,ar)
% function [Cchif,tlag,chif]=cchifilt(chi,at,ar)
% function to calculate the flitered log-amplitude chif and
%    the filtered log-amplitude covariance C_chif 
%    and time lags tlag
% where chi(Nchannel,Npoints)
%       at = alpha_t transmit coefficients for filter #f
%       ar = alpha_r receiver coefficients for filter #f
%  RKD 4/96

nt=length(at);
nr=length(ar);
nch=0;
chif=zeros(size(chi(1,:)));
for it=1:nt
for ir=1:nr
    nch=nch+1;
    chif=chif + (at(it)*ar(ir))*chi(nch,:);
end
end
time=(0.1:0.1:0.1*length(chif));
X=[time; chif]';
[xbar,stdd,xmin,xmax]=stats(chif);
var=stdd^2;
dt=[time(1) time(length(time))];
[xc,stats]=runccor(X,dt);
Cchif=xc(:,2)*var;
tlag=xc(:,1);
%
