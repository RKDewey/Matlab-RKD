function e=sentinel
% function e=sentinal
% Calculate the energy consumption for an RDI Sentinel ADCP
% RKD 3/96

% setup constants
alpha=4.6e-5;beta=1.4e-6;gamma=9e-7;
delta=1e-4;lam=2.4e-3;

% set up defalt values
Nppe=30;
T=60;
Nb=30;
B=4;
%
for i=1:300
  disp(['Default values:'])
  disp([' 1) Number of pings per ensemble = ',num2str(Nppe)]);
  disp([' 2) Time between ensembles (seconds) ',num2str(T)]);
  disp([' 3) Number of bins = ',num2str(Nb)]);
  disp([' 4) Size of bins (m) = ',num2str(B)]);
  disp(['  ']);
  ic=input('Change # or 0: ');
  if ic == 1, Nppe=input(' Enter # pings per ensemble = '); end
  if ic == 2, T=input(' Enter # seconds between ensembles = '); end
  if ic == 3, Nb=input(' Enter # bins = '); end
  if ic == 4, B=input(' Enter size of bins = '); end
  if ic == 0, break; end
  if (4*T) < Nppe, disp([' Too Many pings per ensemble. Please reduce.']); end
end
D=input(' Enter the deployment duration (days) = ');
%
R=B*2+2 + (Nb-1)*B; % first bin depth plus rest of bins
Np=(D*24*3600)*Nppe/T;
accur=(12/B)/sqrt(Nppe);
disp([' Approximate Standard Deviation = ',num2str(accur),' (cm/s)']);
disp([' Maximum range = ',num2str(R), ' (m)']);
disp([' Total number of pings = ',num2str(Np)]);
e=Np*(alpha*B+beta*Nb+gamma*R+delta) + lam*D;
disp([' Energy consumption = ',num2str(e),'  W-hours']);
% fini