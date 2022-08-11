function artillery(bearing,elev,mvel,parameters);
%function artillery(bearing,elev,mvel,parameters);
% where bearing is the compass bearing relative to North
%       elev is the elevation angle relative to Earth
%       mvel is the initial mussel velocity in m/s
% Optional parameters=[Cd radius mass];
% where Cd is the drag coefficient (0-2, default 1 for a cannon ball) 
%       radius is the shell radius (default 0.05 m)
%       mass is the mass of the projectile in kg (default 1)
% Plots the trajectory of a cannon ball from a 10m cannon
% RKD 08/10

if nargin < 4,
    Cd=1;
    radius=0.05;
    mass=1.0;
else
    if length(parameters)==3,
        Cd=parameters(1);
        radius=parameters(2);
        mass=parameters(3);
    elseif length(parameters)==2
        Cd=parameters(1);
        radius=parameters(2);
        mass=1;
    else
        Cd=parameters(1);
        radius=0.05;
        mass=1.0;
    end
end
g=-9.81;
cl=10;
d2r=pi/180;
theta=(90-bearing)*d2r;;
phi=(90-elev)*d2r;

x0=cl*cos(theta)*sin(phi);
y0=cl*sin(theta)*sin(phi);
z0=cl*cos(phi);

clf;

plot3([0 x0],[0 y0],[0 z0],'b','LineWidth',3);
hold on;axis equal;grid on
dcx=x0/cl;
dcy=y0/cl;
dcz=z0/cl;

velx=dcx*mvel;
vely=dcy*mvel;
velz=dcz*mvel;

t=0;
dt=0.1;  % increment by 1/10 of a second calcualtions

x=x0;y=y0;z=z0;
rho=1.2;  % air
A=pi*radius.^2;  % Frontal Area = pi*r*r
drag=(1/2)*rho*Cd*A; % (1/2)*rho*Cd*A
T=0;
zmax=0;
while z>0,
    T=T+dt;
    x=x+velx*dt;  % x = xo + a*dt
    y=y+vely*dt;
    velz=velz + 0.5*g*dt;  % v = vo + 1/2*a*dt, the 1/2 is the average gain between 0 and dt.
    z=z+velz*dt;
    zmax=max([z zmax]);
    plot3(x,y,z,'ro','MarkerSize',2);
    axis equal
    drawnow;
    vel=sqrt(velx.^2 + vely.^2 + velz.^2);
    velx=velx-0.5*drag*vel*velx*dt/mass; % v = vo - 1/2*(Fdrag/mass)*dt 
    vely=vely-0.5*drag*vel*vely*dt/mass;
    velz=velz-0.5*drag*vel*velz*dt/mass;
end
distance=sqrt(x.^2 + y.^2)
Max_Height=zmax
Time=T
% fini