function [U,V,U300,V300]=corrdir(Vx,Vy,heading,hdr,dr,iflag)
%  ADCP direction corrections for ship orrientation
%  Usage: [U,V,U300,V300]=corrdir(Vx,Vy,heading,hdr,iflag)
%  where: Vx=absolute cross-track current speed
%         Vy=absolute along-track current speed
%         heading=datafile of headings from headcorr
%	  hdr=the header info matrix, columns 8,9 = ship dir and speed
%	      where dir are measured +clkwise from North
%         U=east-west current speed
%         V=north-south current speed
%         subtract average velocity (U300,V300) in bins bounded in dr=[20 26].
%         iflag=0 or 1: =1 if bottom depth (hdr(12)) is < adcp depth
%	1.0  RKD  18/3/94
dtor=(2.*pi)./360;
[m,n]=size(Vy);
if iflag == 1
   for i=1:n
       botz(i)=-hdr(i,12);
   end
end
ifilt=5;
% ship direction from true north converted to radians
dir=hdr(:,8)*dtor;
% ship speed converted to cm/s from knots
ssp=hdr(:,9)*51.477;
%
% Now make filtered row arrays with the east and north ship velocities
%
su=flt((sin(dir).*ssp),ifilt);
sv=flt((cos(dir).*ssp),ifilt);
%
% Now rotate ADCP data for relative ship heading (i.e. ship coordinates)
%	where heading is in degrees true north (+ clockwise)
%
[Ut Vt]=vrotate(Vx(:,1),Vy(:,1),heading(1));
for i=2:n
          [u v]=vrotate(Vx(:,i),Vy(:,i),heading(i));
          Ut=[Ut,u];
          Vt=[Vt,v];
end
%
% Now add back in the ship velocity components to get real earth U and V
%
U=zeros(size(Vx));
V=zeros(size(Vy));
% make column arrays full of same ship velocity
suc=zeros(m,1);
svc=zeros(m,1);
for i=1:n
      zdep=-463;
      for j=1:m
          suc(j)=su(i);
          svc(j)=sv(i);
          if iflag == 1
             zdep=zdep+8;
             if zdep <= botz(i)
                suc(j)=NaN;
                svc(j)=NaN;
             end
          end
      end
      if su(i) == NaN
         U(:,i) = NaN;
      else
         if iflag == 0
            U(:,i)=Ut(:,i);
         else
            for j=1:m
                if suc(j) == NaN
                   U(j,i)=NaN;
                else
                   U(j,i)=Ut(j,i)+suc(j);
                end
            end
         end
      end
      if sv(i) == NaN
         V(:,i) = NaN;
      else
         if iflag == 0
            V(:,i)=Vt(:,i);
         else
            for j=1:m
                if svc(j) == NaN
                   V(j,i)=NaN;
                else
                   V(j,i)=Vt(j,i)+svc(j);
                end
            end
         end
      end
end
if dr(1) ~= 0 & dr(2) ~= 0
% subtract average velocity between bins bounded in dr=[20 26].
  U300=veldpth(U,dr);
  V300=veldpth(V,dr);
  for i=1:n
      for j=1:m
          U(j,i)=U(j,i) - U300(i);
          V(j,i)=V(j,i) - V300(i);
      end
  end
end
