function [cmap]=colmap(mapsize,idev);
%    function cmap=colmap(mapsize,idev)
%
%    purpose: create colormap that simulates visible spectrum
%             including a green, which "jet" omits
%    usage: cmap=colmap(mapsize,idev)
%    where: cmap = output array (num rows by 3 columns)
%           mapsize is the number of colors in cmap (suggest 64).
%           idev = 1 for screen or 2 for color postscript printers
%           (ps printers need more green, than viewed on a monitor.
%  Use MATLABs rgb to view the color combinations
%
%    version 1.0 JGunn
%    version 2.0 - RKD 20/10/94
if (nargin < 1), mapsize = 64; end
if (nargin < 2), idev = 1; end

mapsize=mapsize-1; %allow for a black/white at the end for NaN's
cmid=mapsize/2;

% Basic color weighting is based on default hsv colormap
% transitions between colors, forced to portions of sine
% curve. This more evenly weights various portions of spectrum
% to various "pure" colors (red, yellow, green, aqua, blue and 
% magenta).

% Spectrum is truncated at magenta (4.5 out of 6).

% first, given size desired figure out of range of pure colors
%    basically 1/6 of total range (3 colors, RGB, with 2 slopes each)

np=fix(mapsize/5)+1;

% create zero and one arrays for this size
top=ones(1,np);
bot=zeros(1,np);

% create an array of size np that is a portion (slope) of a sine wave
% from pi/2 to pi

x=0.5:2*np-0.5;
if idev == 1,
  wave=sin((x./max(x))*pi);  % for print to screen
else
  wave=(1-cos((x./max(x))*2*pi))/2;  % for color postscript
end

% wave will be transition from high to low
wave = wave(np+1:2.*np);

% evaw will be transition from low to high
evaw=fliplr(wave);

red = [evaw.^3 top wave bot bot bot];
grn = [bot evaw top top wave bot];
blu = [bot bot bot evaw top wave.^3];

colmap0 = [red' grn' blu'];
cmap=flipud(colmap0(fix(np/2):fix(np*6-np/2),:));
cmap=cmap.^(1);

[mapsize,m]=size(cmap);
% set end value to black or white for Nans
cmap(mapsize+1,:)=[1 1 1];

% fini