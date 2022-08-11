% script file to calculate cross correlation

%    create input matrix - time and E/W wind
X=[tw uw];

%    create input matrix - time and inner breach transport
Y=[tb Tb1];

%    set time limits for computations (days)
t1=198;
t2=210;

%    calculate cross correlation
[xc,rsig,nio,its]=runccor(X,Y,t1,t2);

%    plot cross correlation
plotccor(t1,t2,xc,rsig,nio,its,'E/W wind vs Breach Transport')
