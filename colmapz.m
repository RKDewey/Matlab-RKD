function [cmap]=colmapz(mapsize,idev);
%    function cmap=colmap(mapsize,idev)
%
%    purpose: create colormap that simulates visible spectrum
%    usage: cmap=colmap(mapsize,idev)
%    where: cmap = output array (num rows by 3 columns)
%           mapsize is the number of colors in cmap
%           idev = 1 for screen and 2 foor color postscript printer 
%    version 1.0 JGunn
%    version 2.0 - RKD 20/10/94
if (nargin < 1), mapsize = 64; end
if (nargin < 2), idev = 1; end

mapsize=mapsize-1; %allow for a black/white at the end for NaN's
cmid=mapsize/2;

% Basic color weighting is based on default hsv colormap
% transitions between colors are forced to portions of sine
% curve. This more evenly weights various portions of spectrum
% to various "pure" colors (red, yellow, green, aqua, blue and 
% magenta).

% Spectrum is truncated at magenta (4.5 out of 6).

% first, given size desired figure out of range of pure colors
%    basically 1/6 of total range (3 colors, RGB, with 2 slopes each)

np=fix(mapsize/6)+1;

% create zero and one arrays for this size
top=ones(1,np);
bot=zeros(1,np);

% create an array of size np that is a portion (slope) of a sine wave
% from 0 to pi

x=0.5:1:4*np-0.5;
if idev == 1,
  wave=sin((x./max(x))*pi);  % for print to screen
else
  wave=(1-cos((x./max(x))*2*pi))/2;  % for color postscript
end
np2=4*np;
st=[np+1:np2];
en=[1:np2-np];
red=[wave(st) bot bot bot];
grn=[bot wave bot];
blu=[bot bot bot wave(en)];
size(red),size(grn),size(blu)
colmap0=[red' grn' blu'];
cmap(1:mapsize,:)=flipud(colmap0(1:mapsize,:));
cmap(mapsize+1,:)=[1 1 1];

% fini