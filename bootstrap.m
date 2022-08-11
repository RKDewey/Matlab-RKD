function btstrp=bootstrap(vector, N);
%
% Function btstrp=bootstrap(vector, N);
% calculates the mean of VECTOR and the confidence interval 
% of the estimate at the 95% level using the bootstrap method.
% N, the number of repeating times is 1000 if unspecified.

if nargin < 2, N=1000; end

vector=vector(:);
L=length(vector);
N25 = 2.5 * N / 100;
N975 = 97.5 * N / 100;

boo = zeros(N,1);
bmed=boo;
bstd=boo;

for m=1:N;
    k_rand=round(rand(1,L)*(L-1) + 1);
    v_rand=vector(k_rand);
    boo(m)=mean(v_rand);
    bmed(m)=median(v_rand);
    bstd(m)=std(v_rand);
end
junk = sort(boo);
btstrp.mean=mean(boo);
btstrp.mean25 = junk(round(N25));
btstrp.mean95 = junk(round(N975));
junk = sort(bmed);
btstrp.median=mean(bmed);
btstrp.median25 = junk(round(N25));
btstrp.median95 = junk(round(N975));
junk = sort(bstd);
btstrp.stdev=mean(bstd);
btstrp.std25 = junk(round(N25));
btstrp.std95 = junk(round(N975));
%
hist(boo);
title([' Bootstrap Distribution of Mean and 2.5% / 95% ci: ',num2str([btstrp.mean btstrp.mean25 btstrp.mean95])]);
% finis

