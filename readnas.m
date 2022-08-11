% script file to read Pat Nasmyths spectral data into MATLAB
fid=fopen('nasmyth.dat');
rows=fscanf(fid,'%3d',4);
for i=1:rows(1),line=fgetl(fid);disp([num2str(i) '  ' line]);,end
for i=1:rows(2),
   KKs(i)=fscanf(fid,'%e',1);
   F2(i)=fscanf(fid,'%f',1);
end
whos
for i=1:rows(3),line=fgetl(fid);,end
for i=1:rows(4),
   KKs(i)=fscanf(fid,'%e',1);
   G2(i)=fscanf(fid,'%f',1);
end
fclose(fid);figure(1);clf;
subplot(211);loglog(KKs,F2,'-o');
xlabel('Log(k/k_s)');ylabel('Universal Spectra F2(k/k_s)');
subplot(212);loglog(KKs,G2,'-o');
xlabel('Log(k/k_s)');ylabel('Universal Spectra G2(k/k_s)');
% fini


