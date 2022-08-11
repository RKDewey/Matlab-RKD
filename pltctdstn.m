% script to read a list of SBE CNV CTD data files in a directory
% strip off the Lat and Long and plot a figure of the cast locations
clear all
files=dir('*.cnv');
nfiles=length(files);
n=0;
for i=1:nfiles,
   fid=fopen(files(i).name);
   L=1;
   while L,
      line=fgets(fid);
      if length(line)>27,
         if line(5:9)=='GPGGA',
            n=n+1;
            lat(n)=str2num(line(18:19)) + str2num(line(20:25))/60;
            long(n)=str2num(line(29:31)) + str2num(line(32:37))/60;
            fclose(fid);L=0;
         end
         if line(8:15)=='Latitude',
            n=n+1;
            lat(n)=str2num(line(19:20)) + str2num(line(22:26))/60;
            line=fgets(fid);
            long(n)=str2num(line(20:22)) + str2num(line(24:28))/60;
            fclose(fid);L=0;   
         end
      end
   end
   % disp([n,long(n),lat(n)]);
end
mmlat=minmax(lat);
long=-long; % make it East not west.
mmlong=minmax(long);
LL=[-long;lat];

clf;
d=pwd;
jdfcoast([mmlong(1)-5/60 mmlong(2)+5/60 mmlat(1)-5/60 mmlat(2)+5/60],LL,['CTD Stations']);

% fini