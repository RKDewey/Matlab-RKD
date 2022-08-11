% script prtout.m
% script file to write out 'data' into a formatted column asci file
% ofile='filename.txt'

mm=minmax(data);
iform=1;
if (abs(mm(1)) < 1e-3)|(abs(mm(2))>=1e3), iform=2; end
[r,c]=size(data);
disp(['Note: Number of rows = ',num2str(r)]);
disp(['      Number of columns = ',num2str(c)]);
if iform==1,
  for k=1:r
     fprintf(ofile,'%12.6f',data(k,1:c))
     fprintf(ofile,'\n')
  end
else
  for k=1:r
     fprintf(ofile,'%14.6e',data(k,1:c))
     fprintf(ofile,'\n')
  end
end
clear mm r c iform k
% fini
