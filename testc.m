function cmap=testc(del)
% function cmap=testc(del) tests color maps
r=[del:del:1];
nr=length(r);
g=r;b=r;
i=0;
for n=1:nr
for m=1:nr
for l=1:nr
i=i+1;
red(i)=r(n);
grn(i)=g(m);
blu(i)=b(l);
end;end;end;

cmap=[red' grn' blu'];
%fini
