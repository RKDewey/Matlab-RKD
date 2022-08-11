function pm=moonphase(mtime);
% function pm=moonphase(mtime);
% Determine if phase of Moon for any day (UTC)
% Base on 
%   J.Chapront, M.Chapront-Touzé, G.Francou: 
%     "A new determination of lunar orbital parameters, precession content, 
%     and tidal acceleration from LLR measurements". 
%     Astron. Astrophys. 387, 700..709 (2002)
m0=datenum(2000,1,1,0,0,0);  % This formula uses Jan 1 2000 as start
dt=mtime-m0; % number of days since Jan 1 2000
aN=fix(dt/29.4); % approximate number of new moons
N=[aN-2:aN+20]; % N is the integer number of new moons since 2000-1-1 00:00:00 
% D are the julian days since Jan 1 2000 of the new moons 
D=(5.597661-0.000739)+29.530588861.*N +((1.02026-2.35)*1e-14).*N.^2;
n1=max(find(D<dt)); % find last new moon
pm=(dt-D(n1))/(D(n1+1)-D(n1)); % this is phase of moon between 0 - 1.
%
