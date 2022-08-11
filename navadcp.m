Pfunction[U,V,su,sv,Usub,Vsub]=navadcp(Vx,Vy,dir,speed,heading,z,depth,dr)
% [U,V,shipu,shipv,Usub,Vsub]=navadcp(Vx,Vy,dir,speed,heading,z,depth,dr)
%  Navigate and rotate ADCP data for ship motion (and heading).
% where: Vx=measured (cm/s) cross-track current speed matrix (1,1=top left)
%	Vy=measured (cm/s) along-track current speed matrix
% 	dir=direction (deg) of ship movement relative to North (+clockwise)
%	speed=ship speed in m/s (m/s=knots*0.51477)
%Optional heading=array of ship headings (bearing in deg) from N (+clockwise)
%	z=depth of adcp bins (positive)
%	depth=bottom depth time series (used to "blank" near bottomvalues) 
%	dr=depth range of ADCP values to subtract from vertical profiles.
%Output: ------------------------------------------------------------------
%         U=absolute east-west current speed (cm/s)
%         V=absolute north-south current speed (cm/s)
%         su,sv are the estimated ship velocities (try ploting Usub vs su)
%Optional Usub,Vsub are the velocities subtracted from bins bounded by dr 
% Uses external routines vrotate.m and flt.m
%	1.0  RKD  3/18/94, 2.0 12/8/94

[m,n]=size(Vx);
% ship direction from true north converted to radians
dtor=(2.*pi)./360;
dirr=dir*dtor;
% ship speed converted to cm/s from m/s
ssp=speed*100;
%
% Now make filtered row arrays with the east and north ship velocities
%
su=flt((sin(dirr).*ssp),5);
sv=flt((cos(dirr).*ssp),5);
%
if nargin >= 5
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
% assume already in ture north/east coordinates
else
  Ut=Vx;
  Vt=Vy;
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
      if nargin >= 7
        if z(m) > depth(i)
           zdep=(depth(i) - z(1))*(1.0-0.134)
% RDI states that one looses (13.4% of water column above bottom +1bin)
        end
      end
      for j=1:m
          suc(j)=su(i);
          svc(j)=sv(i);
          if nargin >= 7
             if z(j) > zdep
                suc(j)=NaN;
                svc(j)=NaN;
             end
          end
      end
      if su(i) == NaN
         U(:,i) = NaN;
      else
         for j=1:m
             if suc(j) == NaN
                U(j,i)=NaN;
             else
                U(j,i)=Ut(j,i)+suc(j);
             end
         end
      end
      if sv(i) == NaN
         V(:,i) = NaN;
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
if nargout == 4 & nargin == 8
% subtract average velocity between bins bounded in dr (i.e. =[300 350]).
  Usub=zeros(1,n);
  Vsub=zeros(1,n);
  for i=1:n
    avgu=0;
    avgv=0;
    navgu=0;
    navgv=0;
    for j=1:m
      if z(j) >= dr(1) & z(j) <= dr(2)
        if U(j,i)~=NaN
        if abs(U(j,i)) < 100
% exclude noise!
           avgu=avgu+U(j,i);
           navgu=navgu+1;
        end
        end
        if V(j,i)~=NaN
        if abs(V(j,i)) < 100
% exclude noise!
           avgv=avgv+V(j,i);
           navgv=navgv+1;
        end
        end
      end
    end
    if navgu>0
      Usub(i)=avgu/navgu;
    else
      Usub(i)=NaN;
    end
    if navgv>0
      Vsub(i)=avgv/navgv;
    else
      Vsub(i)=NaN;
    end
  end
% Now subtract the bin averaged velocities from each profile
  for i=1:n
      for j=1:m
          U(j,i)=U(j,i) - Usub(i);
          V(j,i)=V(j,i) - Vsub(i);
      end
  end
end
