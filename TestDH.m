% Script to test the Device Headingof an ADCP, using the beam coordinate data
% The "dominant" direction of the flood tide at the thre SoG sites are:
% DDL: 344 TN
% SoGE: 327 TN
% SoGC: 340 TN
%
% e.g. load RDIADCP300WH2940_20110614T000001.801Z-1B78C.mat
PF=344;  % this is my target flood tide direction.
range=adcp.range;
d=find(range>20, 1 );  % get the index for the bin nearest 20m height
P=adcp.pitch;R=adcp.roll;H=adcp.compassHeading; % pitch, heading, etc.
WF=config.blank_WF;WN=config.nbins_WN;WS=config.cellSize_WS;
beam=adcp.velocity;time=adcp.time; % get beam velocities and time
% now get UVW for a device heading of zero, only do this step first time
if ~exist('UVW0'),
  UVW0=beam2uvw(beam,0,P,R,[],[],[100],[1 2 0 0 5 3],[1 1]*1485,WF,WN,WS,1,1);
  U0=UVW0(:,d,1);V0=UVW0(:,d,2);
end
% now estimate the principal (major and minor) axes of the flow with DH=0
thmm0=principal(U0,V0,[1 0 1])  % theta major and minor DH=0
rot1=PF-thmm0(1); % the first estimate of what the rotation might be.
rot2=rot1-180; % or the other direction
[Ur1,Vr1]=vrotate(U0,V0,rot1);
[Ur2,Vr2]=vrotate(U0,V0,rot2);
[Ur1m,Vr1m]=vrotate(U0,V0,-rot1);
[Ur2m,Vr2m]=vrotate(U0,V0,-rot2);
% t_xtide uses local (PST) time, PST = UTC -8/24
Ut=t_xtide('Second Narrows',time-8/24,'Units','m/s')/4; % get an estimate of the predicted tide
clf;
plot(time,Ut,time,flt(Vr1,55),time,flt(Vr2,55),time,flt(Vr1m,55),time,flt(Vr2m,55));
hold on;grid on;axdate(13);
fVr1=flt(Vr1,55);fVr2=flt(Vr2,55);fVr1m=flt(Vr1m,55);fVr2m=flt(Vr2m,55);
imax=find(fVr1==max(fVr1),1);text(time(imax)-0.5/24,fVr1(imax)+0.05,'rot1');
imax=find(fVr2==max(fVr2),1);text(time(imax)-0.5/24,fVr2(imax)+0.05,'rot2');
imax=find(fVr1m==max(fVr1m),1);text(time(imax)-0.5/24,fVr1m(imax)+0.05,'-rot1');
imax=find(fVr2m==max(fVr2m),1);text(time(imax)-0.5/24,fVr2m(imax)+0.05,'-rot2');
% Assess which rotation is the best fit?
disp(' Assess which is best, type rot=rot1, rot2, -rot1, -rot2');
disp(' Or, enter a test/alternate DH, rot=#; ');
disp(' Then type return.');
keyboard
% i.e. rot=rot1;
% return
DH=rot;
if rot<0, DH=360+rot, end
[Ur,Vr]=vrotate(U0,V0,DH);
thmmr=principal(Ur,Vr,[1 0 1])
clf;plot(time,Ut-avg(Ut),time,flt(Vr,55)-avg(Vr)); % use avg in case of NaNs
title('Rotated ADCP data and Tides');
text(time(1)+1/24,0.5,['DH=',num2str(DH)]);
grid on;axdate(13);
% confirm
