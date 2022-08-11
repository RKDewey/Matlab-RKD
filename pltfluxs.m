% Script to read/plot gradients and heat/salt fluxes for ARK9 data
clear all
cd d:\ark9\adcp\matfiles.3
load stat54m
load ctd5465
ctd=ctd54;
fluxes
orient tall
subplot(2,2,1)
semilogx(Kiw,-z,'w',Kpp,-z,'--w')
grid
axis([10^(-6) 10^(-2) -250 0])
title('Station 54: Kiw and Kpp')
xlabel('[m^2/s]')
ylabel('Depth (m)')
subplot(2,2,2)
plot(Sg,-z,'w',Tg,-z,'--w')
grid
title('dT/dz and dS/dz')
axis([-0.1 0.025 -250 0])
subplot(2,2,3)
plot(Sf,-z,'w',Sfpp,-z,'--w')
axis([-0.02 0 -250 0])
grid
title('Salt Flux [gm/s/m^2]')
subplot(2,2,4)
plot(Hf,-z,'w',Hfpp,-z,'--w')
grid
title('Heat Flux [W/m^2]')
axis([-75 0 -250 0])
pltdat
drawnow
print -dps d:\plots\fluxes.ps
%
%
clear all
cd d:\ark9\adcp\matfiles.3
load stat56m
load ctd5465
ctd=ctd56;
fluxes
orient tall
clf
subplot(2,2,1)
semilogx(Kiw,-z,'w',Kpp,-z,'--w')
grid
axis([10^(-6) 10^(-2) -250 0])
title('Station 56: Kiw and Kpp')
xlabel('[m^2/s]')
ylabel('Depth (m)')
subplot(2,2,2)
plot(Sg,-z,'w',Tg,-z,'--w')
grid
title('dT/dz and dS/dz')
axis([-0.1 0.025 -250 0])
subplot(2,2,3)
plot(Sf,-z,'w',Sfpp,-z,'--w')
axis([-0.02 0 -250 0])
grid
title('Salt Flux [gm/s/m^2]')
subplot(2,2,4)
plot(Hf,-z,'w',Hfpp,-z,'--w')
axis([-75 0 -250 0])
grid
title('Heat Flux [W/m^2]')
pltdat
drawnow
print -dps -append d:\plots\fluxes.ps
%
%
clear all
cd d:\ark9\adcp\matfiles.3
load stat58m
load ctd5465
ctd=ctd58;
fluxes
clf
orient tall
subplot(2,2,1)
semilogx(Kiw,-z,'w',Kpp,-z,'--w')
grid
axis([10^(-6) 10^(-2) -250 0])
title('Station 58: Kiw and Kpp')
xlabel('[m^2/s]')
ylabel('Depth (m)')
subplot(2,2,2)
plot(Sg,-z,'w',Tg,-z,'--w')
grid
title('dT/dz and dS/dz')
axis([-0.1 0.025 -250 0])
subplot(2,2,3)
plot(Sf,-z,'w',Sfpp,-z,'--w')
axis([-0.02 0 -250 0])
grid
title('Salt Flux [gm/s/m^2]')
subplot(2,2,4)
plot(Hf,-z,'w',Hfpp,-z,'--w')
axis([-75 0 -250 0])
grid
title('Heat Flux [W/m^2]')
pltdat
drawnow
print -dps -append d:\plots\fluxes.ps
%
%
clear all
cd d:\ark9\adcp\matfiles.3
load stat59m
load ctd5465
ctd=ctd59;
fluxes
clf
orient tall
subplot(2,2,1)
semilogx(Kiw,-z,'w',Kpp,-z,'--w')
grid
axis([10^(-6) 10^(-2) -250 0])
title('Station 59: Kiw and Kpp')
xlabel('[m^2/s]')
ylabel('Depth (m)')
subplot(2,2,2)
plot(Sg,-z,'w',Tg,-z,'--w')
grid
title('dT/dz and dS/dz')
axis([-0.1 0.025 -250 0])
subplot(2,2,3)
plot(Sf,-z,'w',Sfpp,-z,'--w')
axis([-0.02 0 -250 0])
grid
title('Salt Flux [gm/s/m^2]')
subplot(2,2,4)
plot(Hf,-z,'w',Hfpp,-z,'--w')
axis([-75 0 -250 0])
grid
title('Heat Flux [W/m^2]')
pltdat
drawnow
print -dps -append d:\plots\fluxes.ps
%
%
clear all
cd d:\ark9\adcp\matfiles.3
load stat60m
load ctd5465
ctd=ctd60;
fluxes
clf
orient tall
subplot(2,2,1)
semilogx(Kiw,-z,'w',Kpp,-z,'--w')
grid
axis([10^(-6) 10^(-2) -250 0])
title('Station 60: Kiw and Kpp')
xlabel('[m^2/s]')
ylabel('Depth (m)')
subplot(2,2,2)
plot(Sg,-z,'w',Tg,-z,'--w')
grid
title('dT/dz and dS/dz')
axis([-0.1 0.025 -250 0])
subplot(2,2,3)
plot(Sf,-z,'w',Sfpp,-z,'--w')
axis([-0.02 0 -250 0])
grid
title('Salt Flux [gm/s/m^2]')
subplot(2,2,4)
plot(Hf,-z,'w',Hfpp,-z,'--w')
axis([-75 0 -250 0])
grid
title('Heat Flux [W/m^2]')
pltdat
drawnow
print -dps -append d:\plots\fluxes.ps
%
%
clear all
cd d:\ark9\adcp\matfiles.3
load stat62m
load ctd5465
ctd=ctd62;
fluxes
clf
orient tall
subplot(2,2,1)
semilogx(Kiw,-z,'w',Kpp,-z,'--w')
grid
axis([10^(-6) 10^(-2) -250 0])
title('Station 62: Kiw and Kpp')
xlabel('[m^2/s]')
ylabel('Depth (m)')
subplot(2,2,2)
plot(Sg,-z,'w',Tg,-z,'--w')
grid
title('dT/dz and dS/dz')
axis([-0.1 0.025 -250 0])
subplot(2,2,3)
plot(Sf,-z,'w',Sfpp,-z,'--w')
axis([-0.02 0 -250 0])
grid
title('Salt Flux [gm/s/m^2]')
subplot(2,2,4)
plot(Hf,-z,'w',Hfpp,-z,'--w')
axis([-75 0 -250 0])
grid
title('Heat Flux [W/m^2]')
pltdat
drawnow
print -dps -append d:\plots\fluxes.ps
%
%
clear all
cd d:\ark9\adcp\matfiles.3
load stat64m
load ctd5465
ctd=ctd64;
fluxes
clf
orient tall
subplot(2,2,1)
semilogx(Kiw,-z,'w',Kpp,-z,'--w')
grid
axis([10^(-6) 10^(-2) -250 0])
title('Station 64: Kiw and Kpp')
xlabel('[m^2/s]')
ylabel('Depth (m)')
subplot(2,2,2)
plot(Sg,-z,'w',Tg,-z,'--w')
grid
title('dT/dz and dS/dz')
axis([-0.1 0.025 -250 0])
subplot(2,2,3)
plot(Sf,-z,'w',Sfpp,-z,'--w')
axis([-0.02 0 -250 0])
grid
title('Salt Flux [gm/s/m^2]')
subplot(2,2,4)
plot(Hf,-z,'w',Hfpp,-z,'--w')
axis([-75 0 -250 0])
grid
title('Heat Flux [W/m^2]')
pltdat
drawnow
print -dps -append d:\plots\fluxes.ps
%
%
clear all
cd d:\ark9\adcp\matfiles.3
load stat65m
load ctd5465
ctd=ctd65;
fluxes
clf
orient tall
subplot(2,2,1)
semilogx(Kiw,-z,'w',Kpp,-z,'--w')
grid
axis([10^(-6) 10^(-2) -250 0])
title('Station 65: Kiw and Kpp')
xlabel('[m^2/s]')
ylabel('Depth (m)')
subplot(2,2,2)
plot(Sg,-z,'w',Tg,-z,'--w')
grid
title('dT/dz and dS/dz')
axis([-0.1 0.025 -250 0])
subplot(2,2,3)
plot(Sf,-z,'w',Sfpp,-z,'--w')
axis([-0.02 0 -250 0])
grid
title('Salt Flux [gm/s/m^2]')
subplot(2,2,4)
plot(Hf,-z,'w',Hfpp,-z,'--w')
axis([-75 0 -250 0])
grid
title('Heat Flux [W/m^2]')
pltdat
drawnow
print -dps -append d:\plots\fluxes.ps
%
