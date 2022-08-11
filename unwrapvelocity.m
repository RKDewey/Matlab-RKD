function velout=unwrapvelocity(velocity,type,jump,wrap)
% function velout=unwrapvelocity(velocity,type,jump,wrap);
% Function to un-wrap Vector velocities.
% Apply this first on the beam/XYZ velocities, then transform tp ENU
% Inputs: velocity: original velocity needing unwrapping
%         type = 1 for Matlab unwrap, 2 for Dewey unwrap
%   for type 1, jump is the pi factor (default 1.5)
%   for type 2, 
%       jump: estimate of minimum velocity step/jump to unwrap (default 0.3 m/s)
%       wrap: estimate of the correction wrap (default 0.44 m/s)
%      These later two parameters may change with different nominal velocity ranges
% Output: un-wrapped velocity time series.
% NOTE: the first value in velocity must NOT be wrapped!!!
% RKD 06/12
if type==1,
    if nargin<3, jump=1.5; end
else
   if nargin<3, jump=0.3; end
   if nargin<4, wrap=0.44; end
end
velout(1)=velocity(1);
if type ==1,
   scale=max(abs(velocity));
   velout=(scale/pi)*unwrap(velocity*pi/scale,jump*pi);
else
   for i=2:length(velocity),
     dv=velocity(i)-velocity(i-1);
     if dv > jump,
         dv = dv - wrap;
     elseif dv < -jump,
         dv = dv + wrap;
     end
     velout(i)=velout(i-1)+dv;
   end
end
% fini