
% set input filename=ifname and output filename=ofname.

fid = fopen(ifname);
fido= fopen(ofname,'w');

COASTLAT = zeros(1,10000);
COASTLON = COASTLAT;

test = fscanf(fid,'%s',[1 1]);
readata=1;
i=0;
flag=-999.;
while readata == 1,
      COUNT = 0;
      test = fscanf(fid,'%s',[1 1]);
      test = fscanf(fid,'%s',[1 1]);
      i=i+1;
      while (test(1) ~= '#'),
            COUNT = COUNT + 1;
            COASTLON(COUNT) = str2num(test);
            COASTLAT(COUNT) = fscanf(fid,'%f',[1 1]);
            test = fscanf(fid,'%s',[1 1]);
            if test == [], 
               test(1)='#';
               readata=0;
            end
      end
      disp([' Coast line segment: ',num2str(i)]);
      fprintf(fido,'%8.0f %9.4f\n',COUNT,flag);
      for j=1:COUNT
          fprintf(fido,'%8.4f %9.4f\n',COASTLAT(j),COASTLON(j));
      end
end
fclose(fid);fclose(fido);
clear COUNT ans fid fido i j test readdata COASTLAT COASTLON
%
