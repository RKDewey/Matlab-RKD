% script file to mount and read nodc analyzed (1x1 degree) data into 
% slab files. First create temperature slabs, then ADD salinity slabs
% So each file. Make one file for each slab, otherwise, mat files too big.
% 1.0 RKD 1/9/95
z=[0 10 20 30 50 75 100 125 150 200 250 300 400 500 600 700 800 900 1000 ...
1100 1200 1300 1400 1500 1750 2000 2500 3000 3500 4000 4500 5000 5500];
cd k:\analyzed\salinity
%
cdio=fopen('sal00.obj');
%
S0=fscanf(cdio,'%8f',[360,180]);
clear S0
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS0010
save d:\data\nodc\TS0010 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS0020
save d:\data\nodc\TS0020 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS0030
save d:\data\nodc\TS0030 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS0050
save d:\data\nodc\TS0050 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS0075
save d:\data\nodc\TS0075 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS0100
save d:\data\nodc\TS0100 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS0125
save d:\data\nodc\TS0125 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS0150
save d:\data\nodc\TS0150 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS0200
save d:\data\nodc\TS0200 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS0250
save d:\data\nodc\TS0250 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS0300
save d:\data\nodc\TS0300 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS0400
save d:\data\nodc\TS0400 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS0500
save d:\data\nodc\TS0500 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS0600
save d:\data\nodc\TS0600 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS0700
save d:\data\nodc\TS0700 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS0800
save d:\data\nodc\TS0800 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS0900
save d:\data\nodc\TS0900 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS1000
save d:\data\nodc\TS1000 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS1100
save d:\data\nodc\TS1100 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS1200
save d:\data\nodc\TS1200 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS1300
save d:\data\nodc\TS1300 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS1400
save d:\data\nodc\TS1400 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS1500
save d:\data\nodc\TS1500 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS1750
save d:\data\nodc\TS1750 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS2000
save d:\data\nodc\TS2000 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS2500
save d:\data\nodc\TS2500 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS3000
save d:\data\nodc\TS3000 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS3500
save d:\data\nodc\TS3500 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS4000
save d:\data\nodc\TS4000 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS4500
save d:\data\nodc\TS4500 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS5000
save d:\data\nodc\TS5000 T S
clear S0 S T
%
S0=fscanf(cdio,'%8f',[360,180]);
S=(flag2nan(S0,-99.9999))';
load d:\data\nodc\TS5500
save d:\data\nodc\TS5500 T S
fclose(cdio)
clear all
%
