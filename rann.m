function r=rann(m,n)
% function r=rann(m,n)
% generates a matrix (m,n) of randon numbers 
% using the computer clock as the seed
% RKD 1/97
seed=rand('seed',sum(100*clock));
r=rand(m,n);
% fini
