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
