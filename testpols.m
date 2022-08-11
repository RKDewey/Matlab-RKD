%
% Script file to read bathy3.mat (southern hemisphere GEBEC)
% data and plot it in a southern hemisphere polar projection
% I also add a few dummy text and symbols to show the use of 
% those routines.
% The bathy data must be longs between 180W abd 180E.
% RKD Jan 10, 1996

load bathy3

% Note: To make bathy3 I loaded bathy.ascm then bathy3=-bathy;
% This makes the data Lat + south, Long in degrees W.

theta0=pltpolas(-999,[55 70],[20 -10],'w');

% This sets up plot. Note long range is degrees WEST and in the 
%  order [longwest longeast]

pltbaths(theta0,bathy3,[0 250 1000 1500 2000 2500 3000 3500 4000])

% This plots said contours (if they exist) stored in bathy3

pltptexs(theta0,57,18,'Test',10)

% This plots a text string at 57S 18W, fontsize=10

pltpsyms(theta0,[60 60 60 60 60 60],(5:-1:0),'wo')

% This plots a series of symbols (white o's) at said lats/longs
% fini.

