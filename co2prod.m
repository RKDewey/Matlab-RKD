      function [q,dqdt]=co2prod(q0,dqdt0,qt,um,en,dt,t)
%     function [q.dqdt]=co2prod(q0,dqdt0,qt,um,en,dt,t)
% Function to generate production curve for CO2 burning.
%
% RKD 2/22/95
q(1)=q0;
dqdt(1)=dqdt0;
itot=t/dt;
%um=dqdt0/((1-((q0/qt)^en))*q0);
%en=(log(1-(dqdt0/(um*q0))))/(log(q0/qt));
for i=2:itot
  dqdt(i)=dt*um*(1-(q(i-1)/qt)^en)*q(i-1);
  q(i)=q(i-1)+dqdt(i);
end
return
