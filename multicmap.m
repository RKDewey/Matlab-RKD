function [cmp,caxis1,caxis2,caxis3,caxis4]=...
  multicmap(arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8);
%
% MULTICMAP - concatenate as many as four colourmaps and calculate caxes.
%
% [cmp,cax1,...,cax4]= multicmap(cmp1,...,cmp4,caxis1,...caxis4);
%
% returns a concatenated colourmap cmp and the caxis that will need to be
% appended to each axis in order to get the mapping into the colormap to
% work properly. cmp# are the colormaps, caxis# are data ranges.
%
% i.e. 
%  >> [cmp,cax1,cax2]=multicmp(jet(64),bone(64),[1 10],[10 50]);
%  >> colormap(cmp);
%  >> subplot(2,1,1); surface(A); caxis(cax1);
%  >> subplot(2,1,2); surface(B); caxis(cax2);
%
%  should yield the images in A and B coloured by jet and bone respectively.
%  You will run into problems if A is greater than 10, or B is less than 50,
%  in which case it is advisable to trim the data before sending it to image
%  (or contour etc).  However, there is a buffer built into the colormap to
%  accomodate reasonable excursions from the caxis entry.
%  Note: Colormap can be limited to 256 colors in certain video modes (MS-Windows).
%
%  SEE ALSO:  COLORMAP SURFACE IMAGESC EXTCONTOUR JET (etc)
%  J. Klymak Jan 97

nout=nargin/2;
if nargout ~= nout+1
  error(...
      'Usage:[cmp,caxis1,...,caxis4]=multicmap(cmp1,...,cmp4,caxis1,...caxis4)');
end;
for i=1:nout
  eval(['cmp',int2str(i),'=arg',int2str(i),';']);
  eval(['cax',int2str(i),'=arg',int2str(nout+i),';']);
end;

% first concatenate the colormaps...
cmp=[];
buffer_len = 2;
buff=ones(buffer_len,1)*[1 1 1]; %cm(1,:)
for i=1:nout,
   eval(['cm=cmp',int2str(i),';']);
   cmp=[cmp;buff;cm;buff];
end;
% figure(10);clf;colormap(cmp);rgbplot(cmp);colorbar;drawnow %return % for testing

[M,n]=size(cmp);
if M>256, disp('Warning: Your colormap now has more than 256 colors. Check ScreenDepth.'); end
f=2 + buffer_len; %
% calculate where the first value fits into the map.
for i=1:nout
  eval(['cm=cmp',int2str(i),';']);
  eval(['ca=cax',int2str(i),';']);
  [L,N]=size(cm);
  a=ca(1);
  b=ca(2);
  % calculate the minimum cax...
  m = (a*(f-1+L)-b*(f-1))./L;
  n = (M/(f-1+L))*(b-m)+m;
  eval(['caxis',int2str(i),'=[m n];']);
  f=f+L+2*buffer_len;
end;
% fini