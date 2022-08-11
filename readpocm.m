function [T,Trange,depth]=readpocm(ifile,islab)
% [T,Trange,depth]=readpocm(ifile,islab)
% script to read a slab (islab) from POCM ifile into matrix T(282,721)
% slabs: 1-20	U (long=20.5+.5*(i-1): lat=-75+(.5*(j-1)) depths=dep2
% slabs: 21-40	V (long=20.5+.5*(i-1): lat=-75+(.5*(j-1)) depths=dep2
% slabs: 41-61	W (long=20.25+.5*(i-1): lat=-75.25+(.5*(j-1)) depths=dep1
% slabs: 62-81	T (long=20.25+.5*(i-1): lat=-75.25+(.5*(j-1)) depths=dep2
% slabs: 82-101	S (long=20.25+.5*(i-1): lat=-75.25+(.5*(j-1)) depths=dep2
% dep1=[0 25 50 75 100 135 185 260 360 510 710 985 1335 1750 2200 2750
%       3300 3850 4400 4800 5200];
% dep2=[12.5 37.5 62.5 87.5 117.5 160 222.5 310 435 610 847.5 1160 1542.5
%       1975 2475 3025 3575 4125 4600 5000];
% RKD 5/5/94
dep1=[0 25 50 75 100 135 185 260 360 510 710 985 1335 1750 2200 2750 ...
      3300 3850 4400 4800 5200];
dep2=[12.5 37.5 62.5 87.5 117.5 160 222.5 310 435 610 847.5 1160 1542.5 ...
      1975 2475 3025 3575 4125 4600 5000];
if islab <= 20
   depth=dep2(islab);
elseif islab >= 21 & islab <= 40
   depth=dep2(islab-20);
elseif islab >= 41 & islab <= 61
   depth=dep1(islab-40);
elseif islab >= 62 & islab <= 81
   depth=dep2(islab-61);
elseif islab >= 82 & islab <= 101
   depth=dep2(islab-81);
end
io=fopen(ifile,'r','b');
fseek(io,((islab-1)*813296),'bof');
fseek(io,4,'cof');
[T,cnt]=fread(io,[721,282],'float');
fclose(io);
T=flipud(T');
Tmin=100000;
Tmax=-100000;
% Now set bad values (originally = 1e16) = NaN, find data range.
for j=1:282 , for i=1:721
if T(j,i) > 1e15
   T(j,i)=NaN;
else
   Tmin=min(Tmin,T(j,i)); 
   Tmax=max(Tmax,T(j,i)); 
end
end, end;
Trange=[Tmin Tmax];
