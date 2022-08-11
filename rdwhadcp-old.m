function [adcp,cfg]=rdwhadcp(name,num_av,nens);
% RDWHADCP  Read (raw binary) RDI ADCP files, 
%  [ADCP,CFG]=RDWHADCP(NAME) reads the binary RDI Workhorse file NAME and
%  puts all the relevant data into a data structures CFG (for configuration data)
%  and ADCP (for measured data).
%
%  [..]=RDWHADCP(NAME,NUMAV) averages NUMAV ensembles together in the result.
%  [..]=RDWHADCP(NAME,NUMAV,NENS) reads only NENS ensembles.
%  [..]=RDWHADCP(NAME,NUMAV,[NFIRST NEND]) reads only the specified range
%   of ensembles. This is useful if you want to get rid of bad data before/after
%   the deployment period.
%
%  Note - sometimes the ends of files are filled with garbage. In this case you may
%         have to rerun things explicitly specifying how many records to read (or the
%         last record to read). I don't handle bad data very well.
%

% R. Pawlowicz - 17/Oct/99 
%          5/july/00 - handled byte offsets (and mysterious 'extra" bytes) slightly better, Y2K
%          5/Oct/00 - bug fix - size of ens stayed 2 when NUMAV==1 due to initialization,
%                     hopefully this is now fixed.
%          10/Mar/02 - #bytes per record changes mysteriously,
%                      tried a more robust workaround. Guess that we have an extra
%                      2 bytes if the record length is even?
%          28/Mar/02 - added more firmware-dependent changes to format; hopefully this
%                      works for everything now (put previous changes on firmer footing?)


if nargin==1,
  num_av=5;   % Block filtering and decimation parameter (# ensembles to block together).
  nens=-1;
elseif nargin==2,
  nens=-1;
end;
 
%%Spike parameters used if nmedian calls uncommented below
%      horiz  vert  error
vels=[.3 .3 .3];

century=2000;  % ADCP clock does not have century prior to firmware 16.05.


% Check file information first

naminfo=dir(name);

if isempty(naminfo),
  fprintf('ERROR******* Can''t find file %s\n',name);
  return;
end;

fprintf('\nOpening file %s\n\n',name);
fd=fopen(name,'r','ieee-le');

% Read first ensemble to initialize parameters

[ens,hdr,cfg]=rd_buffer(fd,-2); % Initialize and read first two records
fseek(fd,0,'bof');              % Rewind
 
if cfg.prog_ver(1)<16,
  fprintf('**************Assuming that the century begins year*********** %d\n\n',century);
else
  century=0;  % century included in clock.  
end;

dats=datenum(century+ens.rtc(1,:),ens.rtc(2,:),ens.rtc(3,:),ens.rtc(4,:),ens.rtc(5,:),ens.rtc(6,:)+ens.rtc(7,:)/100);
t_int=diff(dats);
fprintf('Record begins at %s\n',datestr(dats(1),0));
fprintf('Ping interval appears to be %s\n',datestr(t_int,13));


% Estimate number of records (since I don't feel like handling EOFs correctly,
% we just don't read that far!)


if length(nens)==1,
  if nens==-1,
    nens=fix(naminfo.bytes/(hdr.nbyte+2));
    fprintf('\nEstimating %d ensembles in this file\nReducing by a factor of %d\n',nens,num_av);  
  else
    fprintf('\nReading %d ensembles in this file\nReducing by a factor of %d\n',nens,num_av); 
  end; 
else
  fprintf('\nReading ensembles %d-%d in this file\nReducing by a factor of %d\n',nens,num_av); 
  fseek(fd,(hdr.nbyte+2)*(nens(1)-1),'bof');
  nens=diff(nens)+1;
end;


% Number of records after averaging.

n=fix(nens/num_av);

% Structure to hold all ADCP data 
% Note that I am not storing all the data contained in the raw binary file, merely
% things I think are useful.

adcp=struct('name','wh-adcp','mtime',zeros(1,n),'number',zeros(1,n),'pitch',zeros(1,n),...
            'roll',zeros(1,n),'heading',zeros(1,n),'pitch_std',zeros(1,n),...
            'roll_std',zeros(1,n),'heading_std',zeros(1,n),'depth',zeros(1,n),...
            'temperature',zeros(1,n),'salinity',zeros(1,n),...
            'pressure',zeros(1,n),'pressure_std',zeros(1,n),...
            'orientation',zeros(1,n)*NaN,...      % RKD 01/03 added due to periodic bug in ADCP
            'east_vel',zeros(cfg.n_cells,n),'north_vel',zeros(cfg.n_cells,n),'vert_vel',zeros(cfg.n_cells,n),...
            'error_vel',zeros(cfg.n_cells,n),'corr',zeros(cfg.n_cells,4,n),'intens',zeros(cfg.n_cells,4,n),...
	         'bt_range',zeros(4,n),'bt_vel',zeros(4,n));

% Calibration factors for backscatter data

clear global ens
% Loop for all records
for k=1:n,

  % Gives display so you know something is going on...
    
  if rem(k,50)==0,  fprintf('\n%d',k*num_av);end;
  fprintf('.');

  % Read an ensemble
  
  ens=rd_buffer(fd,num_av);


  if ~isstruct(ens), % If aborting...
    fprintf('Only %d records found..suggest re-running RDWHADCP using this parameter\n',(k-1)*num_av);
    break;
  end;
    
  dats=datenum(century+ens.rtc(1,:),ens.rtc(2,:),ens.rtc(3,:),ens.rtc(4,:),ens.rtc(5,:),ens.rtc(6,:)+ens.rtc(7,:)/100);
  adcp.mtime(k)=median(dats);  
  adcp.number(k)      =ens.number(1);
  adcp.heading(k)     =mean(ens.heading);
  adcp.pitch(k)       =mean(ens.pitch);
  adcp.roll(k)        =mean(ens.roll);
  adcp.heading_std(k) =mean(ens.heading_std);
  adcp.pitch_std(k)   =mean(ens.pitch_std);
  adcp.roll_std(k)    =mean(ens.roll_std);
  adcp.depth(k)       =mean(ens.depth);
  adcp.temperature(k) =mean(ens.temperature);
  adcp.salinity(k)    =mean(ens.salinity);
  adcp.pressure(k)    =mean(ens.pressure);
  adcp.pressure_std(k)=mean(ens.pressure_std);
  adcp.orientation(k) =mean(ens.orientation);

%  adcp.east_vel(:,k)    =nmedian(ens.east_vel  ,vels(1),2);
%  adcp.north_vel(:,k)   =nmedian(ens.north_vel,vels(1),2);
%  adcp.vert_vel(:,k)    =nmedian(ens.vert_vel  ,vels(2),2);
%  adcp.error_vel(:,k)   =nmedian(ens.error_vel,vels(3),2);
  adcp.east_vel(:,k)   =nmean(ens.east_vel ,2);
  adcp.north_vel(:,k)  =nmean(ens.north_vel,2);
  adcp.vert_vel(:,k)   =nmean(ens.vert_vel ,2);
  adcp.error_vel(:,k)  =nmean(ens.error_vel,2);
  adcp.corr(:,:,k)     =nmean(ens.corr,3);        % added correlation RKD 9/02
  adcp.intens(:,:,k)   =nmean(ens.intens,3);
  adcp.bt_range(:,k)   =nmean(ens.bt_range,2);
  adcp.bt_vel(:,k)     =nmean(ens.bt_vel,2);
    
end;  

fprintf('\n');
fclose(fd);


%-------------------------------------
function hdr=rd_hdr(fd);
% Read config data

cfgid=fread(fd,1,'uint16');
if cfgid~=hex2dec('7F7F'),
 warning('Cnfig ID incorrect - data corrupted or not a processed file?');
end; 

hdr=rd_hdrseg(fd);

%-------------------------------------
function cfg=rd_fix(fd);
% Read config data

cfgid=fread(fd,1,'uint16');
if cfgid~=hex2dec('0000'),
 warning('Cnfig ID incorrect - data corrupted or not a processed file?');
end; 

cfg=rd_fixseg(fd);



%--------------------------------------
function [hdr,nbyte]=rd_hdrseg(fd);
% Reads a Header

hdr.nbyte          =fread(fd,1,'int16'); 
fseek(fd,1,'cof');
ndat=fread(fd,1,'int8');
hdr.dat_offsets    =fread(fd,ndat,'int16');
nbyte=4+ndat*2;


%-------------------------------------
function [cfg,nbyte]=rd_fixseg(fd);
% Reads the configuration data from the fixed leader

%%disp(fread(fd,10,'uint8'))
%%fseek(fd,-10,'cof');

cfg.name='wh-adcp';
cfg.prog_ver       =fread(fd,2,'uint8');
config         =fread(fd,2,'uint8');  % Coded stuff
 freqs=[75 150 300 600 1200 2400];
 angs=[15 20 30];
 cfg.beam_angle     =angs(rem(config(2),8)+1);
 cfg.beam_freq      =freqs(rem(config(1),8)+1);
 cfg.beam_pattern   =bitand(config(1),8)==8;        % 1=convex,0=concave
 cfg.orientation    =bitand(config(1),128)==128;    % 1=up,0=down
cfg.simflag        =fread(fd,1,'uint8');            % Flag for simulated data
fseek(fd,1,'cof'); 											 % spare
cfg.n_beams        =fread(fd,1,'uint8');
cfg.n_cells        =fread(fd,1,'uint8');
cfg.pings_per_ensemble=fread(fd,1,'uint16');
cfg.cell_size      =fread(fd,1,'uint16')*.01;	 % meters
cfg.blank          =fread(fd,1,'uint16')*.01;	 % meters
cfg.prof_mode      =fread(fd,1,'uint8');         %
cfg.corr_threshold =fread(fd,1,'uint8');
cfg.n_codereps     =fread(fd,1,'uint8');
cfg.min_pgood      =fread(fd,1,'uint8');
cfg.evel_threshold =fread(fd,1,'uint16');
cfg.time_between_ping_groups=sum(fread(fd,3,'uint8').*[60 1 .01]'); % seconds
coord_sys      =fread(fd,1,'uint8');                                % Lots of bit-mapped info
cfg.coord_sys      =rem(bitshift(coord_sys,-3),4); % 0=beam,1=instr,2=ship,3=earth.
cfg.use_pitchroll  =bitand(coord_sys,4);           % 1=yes,0=no
cfg.xducer_misalign=fread(fd,1,'int16')*.01;    % degrees
cfg.magnetic_var   =fread(fd,1,'int16')*.01;	% degrees
cfg.sensors_src    =fread(fd,1,'uint8');
cfg.sensors_avail  =fread(fd,1,'uint8');
cfg.bin1_dist      =fread(fd,1,'uint16')*.01;	% meters
cfg.xmit_pulse     =fread(fd,1,'uint16')*.01;	% meters
cfg.water_ref_cells=fread(fd,2,'uint8');
cfg.fls_target_threshold =fread(fd,1,'uint8');
fseek(fd,1,'cof');
cfg.xmit_lag       =fread(fd,1,'uint16')*.01; % meters
nbyte=40;

if cfg.prog_ver(1)>8 | cfg.prog_ver(2)>=14,  % Added serial number with v8.14
  cfg.serialnum      =fread(fd,8,'uint8');
  nbyte=nbyte+8; 
end;

if cfg.prog_ver(1)>8 | cfg.prog_ver(2)>=24,  % Added 2 more bytes with v8.24 firmware
  cfg.sysbandwidth  =fread(fd,2,'uint8');
  nbyte=nbyte+2;
end;

if cfg.prog_ver(1)>=16,                      % Added 1 more bytes with v16.05 firmware
  cfg.syspower      =fread(fd,1,'uint8');
  nbyte=nbyte+1;
end;

% It is useful to have this precomputed.

cfg.ranges=cfg.bin1_dist+[0:cfg.n_cells-1]'*cfg.cell_size;
if cfg.orientation==1, cfg.ranges=-cfg.ranges; end
	
	
%-----------------------------
function [ens,hdr,cfg]=rd_buffer(fd,num_av);

% To save it being re-initialized every time.
global ens hdr

% If num_av<0 we are reading only 1 element and initializing
if num_av<0 | isempty(ens),
 n=abs(num_av);
 pos=ftell(fd);
 hdr=rd_hdr(fd);
 cfg=rd_fix(fd);
 fseek(fd,pos,'bof');
 clear global ens
 global ens
 
 ens=struct('number',zeros(1,n),'rtc',zeros(7,n),'BIT',zeros(1,n),'ssp',zeros(1,n),'depth',zeros(1,n),'pitch',zeros(1,n),...
            'roll',zeros(1,n),'heading',zeros(1,n),'temperature',zeros(1,n),'salinity',zeros(1,n),...
            'mpt',zeros(1,n),'heading_std',zeros(1,n),'pitch_std',zeros(1,n),...
            'roll_std',zeros(1,n),'adc',zeros(8,n),'error_status_wd',zeros(1,n),...
            'pressure',zeros(1,n),'pressure_std',zeros(1,n),...
            'orientation',zeros(1,n),...  % RKD 01/03
            'east_vel',zeros(cfg.n_cells,n),'north_vel',zeros(cfg.n_cells,n),'vert_vel',zeros(cfg.n_cells,n),...
            'error_vel',zeros(cfg.n_cells,n),'intens',zeros(cfg.n_cells,4,n),'percent',zeros(cfg.n_cells,4,n),...
            'corr',zeros(cfg.n_cells,4,n),'status',zeros(cfg.n_cells,4,n),'bt_range',zeros(4,n),'bt_vel',zeros(4,n));
  num_av=abs(num_av);
end;

k=0;
while k<num_av,
   
   id1=dec2hex(fread(fd,1,'uint16'));
   if ~strcmp(id1,'7F7F'),
	if isempty(id1),  % End of file
	 ens=-1;
	 return;
	end;    
    error(['Not a workhorse file or bad data encountered: ->' id1]); 
   end;
   startpos=ftell(fd)-2;  % Starting position.
   
   
   % Read the # data types.
   [hdr,nbyte]=rd_hdrseg(fd);      
   byte_offset=nbyte+2;
   %length(hdr.dat_offsets) % check the number of data types (0000,0008,0001,0002,0003,0004,0005,0006)

   % Read all the data types.
   for n=1:length(hdr.dat_offsets),

    id=fread(fd,1,'uint16');
    %disp(dec2hex(id,4)); % display the data type ID for debugging purposes
    
    % handle all the various segments of data. Note that since I read the IDs as a two
    % byte number in little-endian order the high and low bytes are exchanged compared to
    % the values given in the manual.
    %
    
    switch dec2hex(id,4),           
     case '0000',   % Fixed leader
      [cfg,nbyte]=rd_fixseg(fd);
      ens.orientation(k+1)=cfg.orientation;   % a check on ADCP bug when oriention flips 
      nbyte=nbyte+2;
      
     case '0080'   % Variable Leader
      k=k+1;
      ens.number(k)         =fread(fd,1,'uint16');
      ens.rtc(:,k)          =fread(fd,7,'uint8');
      ens.number(k)         =ens.number(k)+65536*fread(fd,1,'uint8');
      ens.BIT(k)            =fread(fd,1,'uint16');
      ens.ssp(k)            =fread(fd,1,'uint16');
      ens.depth(k)          =fread(fd,1,'uint16')*.1;   % meters
      ens.heading(k)        =fread(fd,1,'uint16')*.01;  % degrees
      ens.pitch(k)          =fread(fd,1,'int16')*.01;   % degrees
      ens.roll(k)           =fread(fd,1,'int16')*.01;   % degrees
      ens.salinity(k)       =fread(fd,1,'int16');       % PSU
      ens.temperature(k)    =fread(fd,1,'int16')*.01;   % Deg C
      ens.mpt(k)            =sum(fread(fd,3,'uint8').*[60 1 .01]'); % seconds
      ens.heading_std(k)    =fread(fd,1,'uint8');     % degrees
      ens.pitch_std(k)      =fread(fd,1,'int8')*.1;   % degrees
      ens.roll_std(k)       =fread(fd,1,'int8')*.1;   % degrees
      ens.adc(:,k)          =fread(fd,8,'uint8');
      ens.error_status_wd(k)=fread(fd,1,'uint32');
      nbyte=2+44;
      
      if cfg.prog_ver(1)>8 | cfg.prog_ver(2)>=13,  % Added pressure sensor stuff in 8.13
          fseek(fd,2,'cof');   
          ens.pressure(k)       =fread(fd,1,'uint32');  
          ens.pressure_std(k)   =fread(fd,1,'uint32');
          nbyte=nbyte+10;  
      end;
      
      if cfg.prog_ver(1)>8 | cfg.prog_ver(2)>=24,  % Spare byte added 8.24
	  		fseek(fd,1,'cof');
	  		nbyte=nbyte+1;
      end;
  	      
      if cfg.prog_ver(1)>=16,   % Added more fields with century in clock 16.05
	  		cent=fread(fd,1,'uint8');
	  		ens.rtc(:,k)=fread(fd,7,'uint8');
	  		ens.rtc(1,k)=ens.rtc(1,k)+cent*100;
	  		nbyte=nbyte+8;
      end;
  	   
    case '0100',  % Velocities
      vels=fread(fd,[4 cfg.n_cells],'int16')'*0.001;     % mm/s *0.001--> m/s
      ens.east_vel(:,k) =vels(:,1);
      ens.north_vel(:,k)=vels(:,2);
      ens.vert_vel(:,k) =vels(:,3);
      ens.error_vel(:,k)=vels(:,4);
      nbyte=2+4*cfg.n_cells*2;
      
    case '0200',  % Correlations
      ens.corr(:,:,k)   =fread(fd,[4 cfg.n_cells],'uint8')';
      nbyte=2+4*cfg.n_cells;
      
    case '0300',  % Echo Intensities  
      ens.intens(:,:,k)   =fread(fd,[4 cfg.n_cells],'uint8')';
      nbyte=2+4*cfg.n_cells;

    case '0400',  % Percent good
      ens.percent(:,:,k)   =fread(fd,[4 cfg.n_cells],'uint8')';
      nbyte=2+4*cfg.n_cells;
   
    case '0500',  % Status
      ens.status(:,:,k)   =fread(fd,[4 cfg.n_cells],'uint8')';
      nbyte=2+4*cfg.n_cells;

    case '0600', % Bottom track
      fseek(fd,14,'cof'); % Skip over a bunch of stuff
      ens.bt_range(:,k)=fread(fd,4,'uint16')*.01; %
      ens.bt_vel(:,k)  =fread(fd,4,'uint16');
      fseek(fd,78-33,'cof');
      ens.bt_range(:,k)=ens.bt_range(:,k)+fread(fd,4,'uint8')*655.36;
      nbyte=2+79;
     
    otherwise,
      fprintf('Unrecognized ID code: %sh\n Aborting read...\n',dec2hex(id,4));
      ens=-1;
      return;      
      
    end;
   
    % here I adjust the number of bytes so I am sure to begin
    % reading at the next valid offset. If everything is working right I shouldn't have
    % to do this but every so often firware changes result in some differences.

    % fprintf('#bytes is %d, original offset is %d\n',nbyte,byte_offset);
    byte_offset=byte_offset+nbyte;   
      
    if n<length(hdr.dat_offsets),
      if hdr.dat_offsets(n+1)~=byte_offset,    
        fprintf('%s: Adjust location by %d\n',dec2hex(id,4),hdr.dat_offsets(n+1)-byte_offset);
        fseek(fd,hdr.dat_offsets(n+1)-byte_offset,'cof');
      end;	
      byte_offset=hdr.dat_offsets(n+1); 
    end;
  end;

  % Now at the end of the record we have two reserved bytes, followed
  % by a two-byte checksum = 4 bytes to skip over.

  readbytes=ftell(fd)-startpos;
  offset=(hdr.nbyte+2)-byte_offset; % The 2 is for the checksum
  if offset ~=4, 
    fprintf('Adjust location by %d (readbytes=%d, hdr.nbyte=%d)\n',offset,readbytes,hdr.nbyte);
  end;  
  fseek(fd,offset,'cof'); 
  
  % removed by RKD 02/2003
  %if cfg.prog_ver(1)>=16,    % I have a v16.19 firmware file that has an extra two bytes. Really!
	%  fseek(fd,2,'cof');
  %end;
  	   
end;

% Blank out stuff bigger than error velocity
% big_err=abs(ens.error_vel)>.2;
big_err=0;
	
% Blank out invalid data	
ens.east_vel(ens.east_vel==-32.768 | big_err)=NaN;
ens.north_vel(ens.north_vel==-32.768 | big_err)=NaN;
ens.vert_vel(ens.vert_vel==-32.768 | big_err)=NaN;
ens.error_vel(ens.error_vel==-32.768 | big_err)=NaN;




%--------------------------------------
function y=nmedian(x,window,dim);
% Copied from median but with handling of NaN different.

if nargin==2, 
  dim = min(find(size(x)~=1)); 
  if isempty(dim), dim = 1; end
end

siz = [size(x) ones(1,dim-ndims(x))];
n = size(x,dim);

% Permute and reshape so that DIM becomes the row dimension of a 2-D array
perm = [dim:max(length(size(x)),dim) 1:dim-1];
x = reshape(permute(x,perm),n,prod(siz)/n);

% Sort along first dimension
x = sort(x,1);
[n1,n2]=size(x);

if n1==1,
 y=x;
else
  if n2==1,
   kk=sum(finite(x),1);
   if kk>0,
     x1=x(max(fix(kk/2),1));
     x2=x(max(ceil(kk/2),1));
     x(abs(x-(x1+x2)/2)>window)=NaN;
   end;
   x = sort(x,1);
   kk=sum(finite(x),1);
   x(isnan(x))=0;
   y=NaN;
   if kk>0,
    y=sum(x)/kk;
   end;
  else
   kk=sum(finite(x),1);
   ll=kk<n1-2;
   kk(ll)=0;x(:,ll)=NaN;
   x1=x(max(fix(kk/2),1)+[0:n2-1]*n1);
   x2=x(max(ceil(kk/2),1)+[0:n2-1]*n1);

   x(abs(x-ones(n1,1)*(x1+x2)/2)>window)=NaN;
   x = sort(x,1);
   kk=sum(finite(x),1);
   x(isnan(x))=0;
   y=NaN+ones(1,n2);
   if any(kk),
    y(kk>0)=sum(x(:,kk>0))./kk(kk>0);
   end;
  end;
end; 

if 0,
  ll=find(kk==0);
  if any(ll), y(ll)=NaN; end;

  ll=find(kk==1);
  if any(ll), y(ll)=x(1+[ll-1]*n1); end;

  ll=find(kk==2);
  if any(ll), y(ll)=(x( 2+[ll-1]*n1) + x(1+[ll-1]*n1))/2; end;

  ll=find(kk==3);
  if any(ll), y(ll)=x(2+[ll-1]*n1); end;

  for n=4:max(kk),
   ll=find(kk==n);
   if any(ll),
     y(ll)=sum(reshape(x([2:n-1]'*ones(1,length(ll)) + ones(n-2,1)*[ll-1]*n1),n-2,length(ll)))/(n-2);
   end;
  end;
end;

%y(ll)=(x( fix(kk(ll)/2)+[ll-1]*n1) + x( ceil(kk(ll)/2)+[ll-1]*n1))/2;
%y(ll)=x(1,ll);

% Permute and reshape back
siz(dim) = 1;
y = ipermute(reshape(y,siz(perm)),perm);

%--------------------------------------
function y=nmean(x,dim);

kk=finite(x);
x(~kk)=0;

if nargin==1, 
  % Determine which dimension SUM will use
  dim = min(find(size(x)~=1));
  if isempty(dim), dim = 1; end
end;

if dim>length(size(x)),
 y=x;              % For matlab 5.0 only!!! Later versions have a fixed 'sum'
else
  ndat=sum(kk,dim);
  indat=ndat==0;
  ndat(indat)=1; % If there are no good data then it doesn't matter what
                 % we average by - and this avoid div-by-zero warnings.

  y = sum(x,dim)./ndat;
  y(indat)=NaN;
end;


























