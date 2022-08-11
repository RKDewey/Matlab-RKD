function [navdata]=readnav(fext,gpstype,ddmmyy);
% function [navdata]=readnav(fext,gpstype,[dd mm yy]);
% function to read GPS nav data
% fext is the filename (read one) or file extension to read all
% Otional gpstype is the preferred GPS string to use, either 'RMC' or 'GGA'
%  default is RMC
% if GGA then must pass the day [dd mm yy]
%
% Output: navdata.mtime 
%        navdata.long (west is negative)
%        navdata.lat (south is negative)
% Optional: ensdata.ens and ensdata.enstime
% RKD 07/03

% this is a single line in the nav files that contains time, lat, long, [and date]
% 123456789012345678901234567890123456789012345678901234567890
% $GPRMC,172230,A,4821.246,N,12407.028,W,001.5,022.7,180602,018.6,E*65
% $GPGGA,160253,4839.212,N,12327.244,W,1,11,1.2,5.7,M,-18.2,M,,*74
% $PADCP,3189,20090508,123530.02,-25195.80
% This is a VMDAS NMEA string ens#, date, PCtime, offset UTC-PC in seconds
% logged at the start of the ensemble.


if nargin<2, gpstype='RMC'; end
if nargin==3, dd=ddmmyy(1); mm=ddmmyy(2); yy=ddmmyy(3); end
if length(fext)<4,
    files=dir(['*.',fext]);
else
    files(1).name=fext;
end
i=0;j=1;
ens=ones(1,200000)*0;
enstime=ens;
time=ones(1,200000)*NaN;
lat=time;long=time;
iavg=0;latavg=0;longavg=0;timeavg=0;
for f=1:length(files),
    fid=fopen(files(f).name);
    disp(files(f).name);
    line=fgets(fid);
    while line~=-1,  % then we're not at the end-of-file yet
        if length(line)>30,
            if strcmp(line(1:6),'$PADCP'),
                j=j+1;
                ic=find(line==',');
                ens(j)=str2num(line(ic(1)+1:ic(2)-1));
                if iavg>1 & j>1,
                    enslong(j-1)=longavg/iavg;
                    enslat(j-1)=latavg/iavg;
                    enstime(j-1)=timeavg/iavg;
                    longavg=0;
                    latavg=0;
                    timeavg=0;
                    iavg=0;
                end
            end
        end
        if length(line)>57,
        if strcmp(line(1:6),'$GPRMC') & gpstype=='RMC',
            hh=str2num(line(8:9));
            mm=str2num(line(10:11));
            ss=str2num(line(12:13));
            Lat=str2num(line(17:18)) + str2num(line(19:24))/60;
            Long=str2num(line(28:30)) + str2num(line(31:36))/60;
            dd=str2num(line(52:53));
            mn=str2num(line(54:55));
            yy=str2num(line(56:57)) + 2000;
            i=i+1;
            time(i)=datenum(yy,mn,dd,hh,mm,ss);
            lat(i)=Lat;
            if line(26)=='S', lat(i)=-lat(i); end
            long(i)=Long;
            if line(38)=='W', long(i)=-long(i); end
            if mod(i,600)==0, disp([num2str(i),'  ',datestr(time(i)),'  ',num2str([lat(i),long(i)])]); end
            if enstime(j)==0, enstime(j)=time(i); end
            if j>1,
                iavg=iavg+1;
                longavg=longavg+long(i);
                latavg=latavg+lat(i);
                timeavg=timeavg+time(i);
            end
        elseif strcmp(line(1:6),'$GPGGA') & gpstype=='GGA',
            hh=str2num(line(8:9));
            mm=str2num(line(10:11));
            ss=str2num(line(12:13));
            Lat=str2num(line(15:16)) + str2num(line(17:22))/60;
            Long=str2num(line(26:28)) + str2num(line(29:34))/60;
            i=i+1;
            time(i)=datenum(yy,mn,dd,hh,mm,ss);
            lat(i)=Lat;
            if line(24)=='S', lat(i)=-lat(i); end
            long(i)=Long;
            if line(36)=='W', long(i)=-long(i); end
            if mod(i,600)==0, disp([num2str(i),'  ',datestr(time(i)),'  ',num2str([lat(i),long(i)])]); end
            if enstime(j)==0, enstime(j)=time(i); end
            if j>1,
                iavg=iavg+1;
                longaavg=longavg+long(i);
                latavg=latavg+lat(i);
                timeavg=timeavg+time(i);
            end
        end
        end
        line=fgets(fid);
    end
    if iavg>1 & j>1,
       enslong(j)=longavg/iavg;
       enslat(j)=latavg/iavg;
       enstime(j)=timeavg/iavg;
    end
    fclose(fid);
end
indx=~isnan(time);
time=time(indx);
lat=lat(indx);
long=long(indx);
navdata.mtime=time;
navdata.long=long;
navdata.lat=lat;
indx=find(ens~=0);
navdata.ens=ens(indx);
navdata.enslong=enslong;
navdata.enslat=enslat;
navdata.enstime=enstime;
% fini