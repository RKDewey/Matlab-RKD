function [zbar,zvar]=online_variance_2D(x,y,z)
% function [zbar,zvar]=online_variance_2D(x,y,z)
%
% Calculate the nunning mean and variance of 2D data, one new data point at a time.
% Input is simply the next z value on in 2D domain at [x,y]
% Output are the running mean and variance matrices zbar(I,J), zvar(I,J)
% 
% Global variables of interest: 
%  N(I,J), zbarN(I,J), zvarN(I,J), X(I), Y(J)
%  where X and Y set the grid domain
%    X=[xmin:(xmax-xmin)/(I-1):xmax] and Y=[ymin:(ymax-ymin)/(J-1):ymax]
%      with dimensions I,J (i.e. 100x100)
%  You must set the global variables X(I) and Y(J) before calling
%  i.e. >>global X Y;X=[0:100/99:100];Y=[0:100/99:100];
%
% To re-initialize; >>global N;N=[];
%
% RKD 02/15
global N zbarN zvarN X Y
%
if isempty(X) || isempty(Y), 
    disp('Must define X and Y (grid domain) first.'); 
    return; 
end
I=length(X);J=length(Y);
% initialize the variables/allocate memory
if isempty(N), N=ones(I,J)*NaN; zbarN=N; zvarN=N; end
zbar=zbarN;
zvar=zvarN;
%
%
i=ceil((x-min(X))*(I/(max(X)-min(X))));
j=ceil((y-min(Y))*(J/(max(Y)-min(Y))));
% set initial value at [x,y] to zero not NaN
if isnan(N(i,j)), N(i,j)=0; zbarN(i,j)=0; zvarN(i,j)=0; end
%
N(i,j)=N(i,j)+1;
delta=z-zbarN(i,j);
zbarN(i,j)=zbarN(i,j)+delta/N(i,j);
zvarN(i,j)=zvarN(i,j)+delta*(z-zbarN(i,j));
%
zbar(i,j)=zbarN(i,j);
if N(i,j)>1, zvar(i,j)=zvarN(i,j)/(N(i,j)-1); end
if N(i,j)==1, zvar(i,j)=NaN; end
% fini