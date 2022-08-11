function bmbeams=binmap(varargin);
% function bmbeams=binmap(beams,El,Az,H,P,R,gr,WF,WS,UD,SS,iplt);
% Function to binmap the ADCP raw beam velocities into horizontal planes
%
% Output: bmbeams(M,N,1:#beams) binmapped velocities (typically in mm/s)
%           where M is the ensemble/profile number, 
%           and N is the number of bins/length of each profile
%
% Input: beams(M,N,1:#beams) original raw beam coordinate ADCP measured currents
% Optional Input: 
%   El = Elavation angles of beams, default = [-70 -70 -70 -70] length = #beams
%   Az = Azimuthal angle of beams, default = [270 90 0 180] length = #beams
%   H(M) = heading from compass (degrees from north), default = 0
%   P(M) = pitch from pitch sensor (+degrees beam 3 up) default = 0
%   R(M) = roll from roll sensor (+degrees beam 1 down) default = 0
%   gr = gimballed roll sensor, default = 1 (yes RDI workhorse) otherwise 0
%   WF = blank distance after transmission in cm, default = 176
%   WS = bin size in cm, default = 200
%   UD = Up (-1) or Down (1), default = down (1)
%   SS = Average Speed of Sound, default = 1500 m/s, fractional correction is SS/1500
%   iplt = beam number to plot diagnostics (default = 0 (no plotting)
%
% RKD 03/06, folloing Michael Ott thesis/paper (JTech 2002 v19 p1738)
beams=varargin{1};
SIZ=size(beams);
WN=SIZ(2);M=SIZ(1);x=ones(M,1)';
el=-[70 70 70 70];az=[270 90 0 180];H=0*x;P=0*x;R=0*x;gr=1;WF=176;WS=200;UD=1;SS=1500;iplt=0;
lv=length(varargin);
if lv>1,
    for i=2:lv, switch i
        case 2, el=varargin{i};
        case 3, az=varargin{i};
        case 4, H=varargin{i};
        case 5, P=varargin{i};
        case 6, R=varargin{i};
        case 7, gr=varargin{i};
        case 8, WF=varargin{i};
        case 9, WS=varargin{i};
        case 10, UD=varargin{i};
        case 11, SS=varargin{i};
        case 12, iplt=varargin{i};
    end;end
end
d2r=pi/180;
el=el*d2r;az=az*d2r;H=H*d2r;P=P*d2r;R=R*d2r;
if gr==1, % pitch fixed, roll gimballed (RDI)
    H=H+asin(sin(P).*sin(R) ./ sqrt((cos(P)).^2 + (sin(P).*sin(R)).^2));
else % ptich and roll rigidly fixed wrt transducers
    P = asin( sin(P).*cos(R) ./ sqrt( 1 - (sin(P).*sin(R)).^2));
end
% ----- calculate Beam Directional Matrix from passed azimuth and elevation --
for i=1:SIZ(3),
   if SIZ(3) == 3,
       BeamCalc(i,:) = [ -cos(el(i))*sin(az(i)) -cos(el(i))*cos(az(i))  -sin(el(i))];
   elseif SIZ(3) == 4,
       BeamCalc(i,:) = [ -cos(el(i))*sin(az(i)) -cos(el(i))*cos(az(i))  -sin(el(i))   0];
   elseif SIZ(3) == 5,
       BeamCalc(i,:) = [ -cos(el(i))*sin(az(i)) -cos(el(i))*cos(az(i))  -sin(el(i))   0    0];
   end
end
if SIZ(3)==4,
   BeamCalc(:,4) = orthog(BeamCalc(:,1:3),[1 2])'; % make the error term mathematically orthogonal to xyz
end
MATRIX = inv(BeamCalc);
bmbeams = NaN * ones(SIZ); % initialize all NaNs
if iplt>0, figure(1);clf; end
for j = 1:SIZ(1), % for each ensemble
	H2 = H(j);
    P2 = P(j);
    if UD == -1, % then upward looking
      R2 = R(j) + pi; % use this roll if upward looking
    else
      R2 = R(j); % use this roll if downward looking
    end
    % ----- calculate rotation matrices ----------------------------------
    Mh = [cos(H2) sin(H2) 0;-sin(H2) cos(H2) 0;0 0 1];
    Mp = [1 0 0;0 cos(P2) -sin(P2);0 sin(P2) cos(P2)];
    Mr = [cos(R2) 0 sin(R2);0 1 0;-sin(R2) 0 cos(R2)];
    %  This is used to convert from instrument coordinates to Earth
    Mtot = Mh * Mp * Mr ;  % equation (9) in RDI Coordinate Transformation Help Document

	% ----- bin mapping --------------------------------------------------
    for kk=1:SIZ(3),
 	  bintemp = Mr * Mp * [-cos(el(kk))*sin(az(kk));cos(el(kk))*cos(az(kk));-sin(el(kk))];
 	  fracHGHT(kk)=bintemp(3); % vertical component only
      nomHGHT(:,kk) = (WF/100 + WS/100/2 + WS/100*[0:WN-1])*(-sin(el(kk))); % These are the hieghts/depth of original bins
    end
    fixHGHT = ((WF/100 + WS/100/2 + WS/100*[0:WN-1])*sin(-70*d2r)*UD)'; % interpolate to these fixed heights/depths
 	fracHGHT = fracHGHT ./ sin(abs(el)) * SS/1500;
    for kk=1:SIZ(3),
        if UD==-1, % upward
           actHGHT(:,kk) = nomHGHT(:,kk) * (-fracHGHT(kk));  % these are the actual heights
        else % downward
           actHGHT(:,kk) = nomHGHT(:,kk) * fracHGHT(kk); % these are the actual depths
        end
    end
    if iplt>0 & j < 5,
        mm=minmax([nomHGHT actHGHT]);
        figure(1);subplot(2,SIZ(1),j);plot(nomHGHT,actHGHT,'-o',fixHGHT,fixHGHT,'ok');
        for kk=1:SIZ(3), text(nomHGHT(end)+.5,actHGHT(end,kk),num2str(kk)); end
        title(['Pitch: ',num2str(P(j)/d2r),'  Roll: ',num2str(R(j)/d2r)]);
        axis(fix([mm(1) mm(2)+1 mm(1) mm(2)+1]));grid on;
        if j==1, ylabel('Actual Height of Bins (Mapped)'); end
        xlabel('Un-mapped');
    end
    for kk = 1:SIZ(3),
		bmbeams(j,:,kk) = interp1(actHGHT(:,kk),beams(j,:,kk),fixHGHT,'linear'); % interpolate to fix heights/depths
    end
end
if iplt>0,
    cv=minmax(minmax(beams(:,:,iplt)));
    cmap=colmap(64,1);cmap(1,:)=[1 1 1];
    subplot(223);imagesc([1:SIZ(1)],nomHGHT(:,iplt),beams(:,:,iplt)',[cv(1)-0.2*cv(1) cv(2)*1.02]);set(gca,'YDir','normal');
    title(['Original Vertical Mapping Beam: ',num2str(iplt)]);colormap(cmap);colorbar;
    xlabel('Time/Ensemble');ylabel('Un-mapped Height/Bin');
    subplot(224);imagesc([1:SIZ(1)],fixHGHT,bmbeams(:,:,iplt)',[cv(1)-0.2*cv(1) cv(2)*1.02]);set(gca,'YDir','normal');
    title(['Bin Mapped Velocities, Beam: ',num2str(iplt)]);colormap(cmap);colorbar;
    xlabel('Time/Ensemble');ylabel('Mapped Height/Bin');
end
% fini binmap
% ----------------
function VECT = orthog(X,MAG)

% function VECT = orthog(X,MAG)
%      eg. VECT = orthog([2 0 0;0 1 0],[1 2])		returns [0 0 1.5]
%
% /matlab/tools/orthog.m
%
% calculates the vector orthogonal to:
%	the n-1 row    vectors of length n (for   n-1 by n   matrix X)
%		or
%	the n-1 column vectors of length n (for   n by n-1   matrix X)
%
% normalizes vector to have the same rms magnitude as:
%	a unit vector					for MAG = 0
%	the mean of magnitudes of the vectors in MAG	for MAG = [i ... j]
%		i and j must be > 0 and < n
%	default = 0
%
% Michael Ott
% 13 Jan 1997

if nargin < 2
	MAG = 0;				% default: unit length
end

[m,n] = size(X);				% format: vectors as rows
if m == n-1
	x2 = X;
elseif m == n+1
	x2 = X';
else
	error('Matrix is not   n by n-1   or   n-1 by n')
end
siz = max(m,n);

if MAG ~= 0					% invalid magnitude choice
	if max(MAG) > siz-1
		error('Vector index for magnitude too large')
	elseif min(MAG) < 1
		error('Vector index for magnitude too small')
	end
end

for i = 1:siz					% every dimension for VECT
	j2 = 0;
	for j1 = 1:siz
		if (j1 ~= i)			% omit VECT dimension from det
			j2 = j2 + 1;
			for k1 = 1:siz-1		% each existing vector
				mat(k1,j2) = x2(k1,j1);	% determinant matrix
			end
		end
	end
	VECT(i) = det(mat) * (-1)^(i+1);	% un-normalised VECT components
end

if all(VECT == 0)					% zero vector
	error('Vectors are not all linearly independent')
end

for i = 1:siz-1
	if sum( x2(i,:) .* VECT ) > 1e-8		% orthog. condition
		errror('Cannot find orthogonal vector')
	end
	rmsmag(i)  = sum( x2(i,:) .* x2(i,:) );	
end
rmsmag = sqrt( rmsmag );			% root mean square magnitude

VECT = VECT / sqrt( sum(VECT .* VECT) );	% normalise (unit length)

if MAG ~= 0
	VECT = VECT * mean(rmsmag(MAG));	% match the rms magnitude
end
%
function y = minmax(x)
%
% MINMAX      find the minimum and maximum of a vector or a matrix
%             Robust with respect to NaN.
y=[min(min(x)) max(max(x))];
%
% fini
function [cmap]=colmap(mapsize,idev);
%    function cmap=colmap(mapsize,itype)
%                  default cmap=colmap(64,1);
%    purpose: create colormap that simulates visible spectrum
%             including a green, which "jet" omits
%    where: cmap = output array (mapsize rows by 3(rgb) columns)
%  Note: End color is white for any NaNs. If undesired, reduce size by 1
%
%  Optional parameters:
%   mapsize is the number of colors in cmap (suggest 64).
%   itype    = 1 (default) for screen or 2 for color postscript printers
%                (ps printers need more green, than viewed on a monitor.
%            = 3 for a fade to black at blue end
%            = 4 for a fade to white at blue end
%   (b&w)    = 10 or 11 for a gray scale colormap
%              10 = from black (low) to white (high)
%              11 = from black (low) to white (mid) to black (high)
%  If itype is negative (i.e. -10), then flip colormap
%  Use MATLABs rgbplot(cmap) to view the color combinations
%    or test with >>image([1:nc]);colormap(colmap(nc,idev,bw))

%    version 1.0 JGunn
%    version 2.0 - RKD 20/10/94
%            2.1 - ps printers need more green, and steeper roll-offs
if (nargin < 1), mapsize = 64; end
if (nargin < 2), idev = 1; end

iflip=0;
if idev < 0, iflip=1; idev=abs(idev); end

if idev < 10,  % then a color map
%mapsize=mapsize-1; %allow for a black/white at the end for NaN's
cmid=mapsize/2;

% Basic color weighting is based on default hsv colormap
% transitions between colors, forced to portions of sine
% curve. This more evenly weights various portions of spectrum
% to various "pure" colors (red, yellow, green, aqua, blue and 
% magenta).
% Spectrum is truncated at magenta (5 out of 6 segments).

% first, given size desired figure out of range of pure colors
%    basically 1/6 of total range (3 colors, RGB, with 2 slopes each)

np=fix((mapsize+1)/5);

% create zero and one arrays for this size
top=ones(1,np);
bot=zeros(1,np);

% create an array of size np that is a portion (slope) of a sine wave
% from pi/2 to pi

x=1:2*np+1;
if idev ~= 2,  % set the color map for a 256 color screen
  wave=sin((x./max(x))*pi);  % for print to screen
  slope1=1.5; % adjust the slopes of the outer (slope1) and 
  slope2=1;   % inner (slope2) transition regions for color transitions.
else  % set the color map for a postscript printer (broader green)
   wave=((1-cos((x./max(x))*2*pi))/2).^1;  % for color postscript
   slope1=1;
   slope2=2;
end

% wave will be transition from high to low
wave = wave(np+1:2.*np);
% evaw will be transition from low to high
evaw=fliplr(wave);
red = [evaw.^slope1 top wave.^slope2 bot bot bot];
grn = [bot evaw top top wave bot];
blu = [bot bot bot evaw.^slope2 top wave.^slope1];
colmap0 = [red' grn' blu'];
[mc,nc]=size(colmap0);
dif=fix((mc-mapsize)/2);
if dif>0,
   cmap=flipud(colmap0(dif:mc-dif,:));
else
   cmap=flipud(colmap0);
end

if idev == 3,  % then slide to black at blue end of jet spectraum
    b1=cmap(1,3)*0.9;
    zbk=[b1/8:b1/8:b1]';
    z(1:8)=0;z=z';
    cmbk(:,1:3)=[z z zbk];
    z0(1:4)=0;z0=z0';
    cmb(:,1:3)=[z0 z0 z0];
    cmap=[cmb;cmbk;cmap];
elseif idev == 4, % then add some room and fade to white
   [m,n]=size(cmap);
   mm=fix(0.15*m)+1;
   cmap=cmap(fix(mm/1.5):m,:);
   sgr=[1:-1/mm:0]';
   b1=cmap(1,3);
   sb=[1:-(1-b1)/mm:b1]';
   red=[sgr ; cmap(:,1)];grn=[sgr ; cmap(:,2)];blu=[sb ; cmap(:,3)];
   cmap=[red grn blu];
end

[mc,nc]=size(cmap);
% set end value to black or white for Nans
cmap(mc+1,:)=[1 1 1];

elseif idev > 9, % then use a gray scale
   maxblk=0.2;
   if idev == 10,
% 'gray' scale
    grey0=[maxblk+(1-maxblk)/mapsize:(1-maxblk)/mapsize:1];
    cmap=[grey0',grey0',grey0'];
   elseif idev == 11,
    nc2=fix(mapsize/2);
% 2-sided grey scale (mapsize), dark grey at high (+/-) amplitudes
    grey1=[[maxblk+(1-maxblk)/nc2:(1-maxblk)/nc2:(1-(1-maxblk)/nc2)] [1:-(1-maxblk)/nc2:maxblk+(1-maxblk)/nc2]];
    cmap=[grey1',grey1',grey1'];
    [mc,nc]=size(cmap);
    cmap(mc+1,:)=1.0; % so NaN's are white, not black
   end
end
if iflip==1, cmap=flipud(cmap); end
% fini
