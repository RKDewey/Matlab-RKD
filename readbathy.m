% script to read bathy extractor file=filename
%  # -b depth
%  long lat
clear LON LAT COUNT
fid = fopen(filename);
COUNT = 0;
test = fscanf(fid,'%s',[1 1]);  % read first #
test = fscanf(fid,'%s',[1 1]);  % read '-b'
while ~isempty(test),
	COUNT = COUNT + 1;
   LAT(COUNT) = fscanf(fid,'%d',[1 1]);  % read the depth of this contour
   c1=COUNT;
   test = fscanf(fid,'%s',[1 1]);
   cnt=0;
   while ~isempty(test),
	while ~strcmp(test(1),'#'),
      COUNT = COUNT + 1;
		LON(COUNT) = -str2num(test);
      LAT(COUNT) = fscanf(fid,'%f',[1 1]);
      cnt=cnt+1;
		test = fscanf(fid,'%s',[1 1]);
	end
   test = fscanf(fid,'%s',[1 1]);  % read '-b'
   LON(c1) = cnt;
   disp([num2str(LAT(c1)),'   ',num2str(LON(c1))]);
   end
end

fclose(fid)
clear COUNT ans fid i test
save bathy
