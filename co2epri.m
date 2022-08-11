     function [q,dqdt]=co2epri()
%    function [q,dqdt]=co2epri()
% function to generate the EPRI CO2 production curve
% RKD 2/22/95
qq=0;
dqdt(1)=qq;
q(1)=0;
% years are from 1890 through 2500 (610 years)
for i=2:610
    if     (i<=110),         qq=qq+0.0473;
    elseif (i>111 & i<=145), qq=qq+0.17;
    elseif (i>145 & i<=170), qq=qq+0.36;
    elseif (i>171 & i<=205), qq=qq+0.38;
    elseif (i>206 & i<=220), qq=qq+0.44;
    elseif (i>221 & i<=235), qq=qq-0.44;
    elseif (i>236 & i<=270), qq=qq-0.38;
    elseif (i>271 & i<=295), qq=qq-0.36;
    elseif (i>296 & i<=310), qq=qq-0.17;
    elseif (i>311) qq=0;
    end
    dqdt(i)=qq;
    q(i)=q(i-1) + dqdt(i);
end
return
