function [result,machines,times] = bench(count)
%BENCH	MATLAB Benchmark
%
%	BENCH times five different MATLAB tasks and compares the execution
%	speed with the speed of several other computers.  The five tasks are:
%	
%	 Loops     For loops and "zeros".   Strings and "malloc".
%	 LU        MATLAB's "LINPACK".      Primarily floating point.
%	 Sparse    Solve sparse system.     Mixed integer and floating point.
%	 3-D       Surf plot of "peaks".    3-D polygonal fill graphics.
%	 2-D       plot(fft(eye)).          2-D line drawing graphics.
%
%	BENCH runs each of the five tasks 10 times.
%	BENCH(N) runs each of the five tasks N times.
%	T = BENCH(N) returns a vector with the five execution times.
%	BENCH(0) just reports the comparison times for the other computers.
%
%	The problem sizes were chosen so that each task required about one
%	second with MATLAB 4.0 on a Sun SPARC-2 in 1992.  On this machine,
%	BENCH(N) nominally produces [N N N N N], so the default BENCH would
%	require 50 seconds and produce [10 10 10 10 10].
%
%	A final bar chart shows speed, which is inversely proportional to 
%	time.  Here, longer bars are faster machines, shorter bars are slower.
%
%	NOTE (August, 1994):  New comparison times were measured with
%	MATLAB 4.2c in early August, 1994.  The SPARC-2 baseline times
%	are retained for historical consistency.
%
%	CAVEAT: Fluctuations of five or 10 percent in the measured times
%	of repeated runs on a single machine are not uncommon.
%	Your own mileage may vary.

%	C. Moler, 1-5-92, 8-26-92, 11-23-92, 5-14-93, 8-11-94.
%	Copyright (c) 1984-94 by The MathWorks, Inc.


machines = str2mat( ...
   'SPARC-2', ...
   'SPARC-20/62',...
   'SPARC-10/41',...
   'HP 735', ...
   'IBM RS6000/590', ...
   'SGI Indy, R4000', ...
   'DEC Alpha, 3500');

machines = str2mat(machines, ...
   'PC Pentium/60', ...
   'PC Pentium/90', ...
   'PC 486DX2/66', ...
   'PC Laptop, 486DX2/40', ...
   'Mac PowerPC, 8100', ...
   'Mac Quadra, 700', ...
   'Mac PowerBook, 165C');

times = [ ...
    10.    10.    10.    10.    10.;
   2.18   1.94   3.41   2.73   2.53;
   3.48   2.89   4.78   5.06   5.23;
   1.35   1.34   2.52   2.43   2.14;
   1.38   0.67   1.93   2.60   1.78;
   3.55   2.40   4.12   5.20   5.25;
   2.88   2.58   2.68   5.67   4.22];

times = [times;
   6.45   5.26   4.80   9.17   8.99;
   4.69   3.96   3.45   7.24   6.28;
   5.59   9.96   8.26  13.70  12.77;
  14.10  15.40  13.20  30.50  25.00;
   4.78   3.99   3.53   7.77   7.91;
  26.30  18.40  20.60  36.50  29.50;
  34.00  84.60  74.80  65.40  65.40];

if nargin < 1, count = 10; end;
close all;

if count > 0

   help bench
   t = 0
   pause(ceil(count/4));
   fig1 = figure;
   set(fig1,'pos','default')
   axes('pos',[0 0 1 1])
   axis off
   
% The problem size, n, for each task has been chosen 
% so that the task takes about one second on a SPARC-2.
   
% Loops
   
   imtext(.33,.5,'MATLAB Benchmark','left')
   imtext(.40,.42,'Loops','left')
   drawnow
   
   n = 375;
   A = [];
   r = 1;
   tic
   for k = 1:count
      for j = 1:n
         clear A;
         r = rem(pi*r,1);
         m = fix(100*r);
         A = zeros(m,m);
      end
   end
   t(1) = toc
   
% LU
   
   cla
   imtext(.33,.5,'MATLAB Benchmark','left')
   imtext(.45,.42,'LU','left')
   drawnow
   
   n = 167;
   A = randn(n,n);
   tic
   for k = 1:count
      lu(A);
   end
   t(2) = toc
   
% Sparse
   
   cla
   imtext(.33,.5,'MATLAB Benchmark','left')
   imtext(.42,.42,'Sparse','left')
   drawnow
   
   n = 36;
   A = delsq(numgrid('L',n));
   b = sum(A)';
   spparms('autommd',0);
   tic
   for k = 1:count
      x = A\b;
   end
   t(3) = toc
   
% 3-D
   
   clf reset
   n = 24;
   [x,y,z] = peaks(n);
   ax = [-3 3 -3 3 -8 8];
   tic
   for k = 1:count
      surf(x,y,z);
      axis(ax);
      drawnow;
   end
   t(4) = toc
   
% 2-D
   
   clf
   n = 52;
   tic
   for k = 1:count
      plot(fft(eye(n)));
      axis('square')
      drawnow;
   end
   t(5) = toc

   machines = str2mat(machines,'This computer');
   times = [times; 10/count*t];
end
   
% Compare with other machines.

totals = sum(times')';
speeds = 50./totals;
[speeds,k] = sort(speeds);
machines = machines(k,:);
times = times(k,:);
m = size(machines,1);

% Horizontal bar chart
% Highlight this machine with another color.

clf
[x,y] = bar(speeds);
plot(y,x,'y',[0 0],[min(x) max(x)],'y');
axis([-2.1 max(speeds)+.1 0 m+1])
set(gca,'xtick',0:max(speeds))
title('Relative Speed')
hold on
if count > 0
   this = find(k==length(k));
   k = 5*this;
   plot(y(k-4:k),x(k-4:k),'m')
else
   this = 0;
end

% Add machine names

for j = 1:m
   s = [machines(j,:) ','];
   h = text(-2,j,s(1:min(find(s==','))-1));
   if j == this, set(h,'color','m'), end
end
hold off

% Display report in new figure

fig2 = figure('pos',get(gcf,'pos')+[50 -150 0 0]);
axes('pos',[0 0 1 1])
axis off
x0 = .08;
y0 = .975;
dx = .10;
dy = (y0-.25)/(m-1.25);
imtext(x0+.3,y0,'Execution Time','left')
s = sprintf(' Loops   LU  Sparse  3-D   2-D');
h = imtext(x0+3*dx,y0-5/4*dy,s,'left');
set(h,'fontname','courier')
drawnow
for j = m:-1:1
   y = y0-(m-j+9/4)*dy;
   x = x0;
   h = imtext(x,y,machines(j,:),'left');
   if j == this, set(h,'color','m'), end
   x = x + 3*dx;
   s = sprintf('%6.1f',times(j,:));
   h = imtext(x,y,s,'left');
   set(h,'fontname','courier')
   if j == this, set(h,'color','m'), end
end
drawnow
print -dps c:\temp\mlbench.ps -f1
print -dps -append c:\temp\mlbench.ps -f2
% Output if requested.
if nargout >= 1, result = t; end
