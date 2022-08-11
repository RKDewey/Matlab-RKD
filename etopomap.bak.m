function [values,lats,lngs]=etopomap(axes,maxlat,mcolr);
% ETOPOMAP makes map of the world.
%
%        ETOPOMAP([LONG_MIN LONG_MAX LAT_MIN LAT_MAX]) draws a
%        map of the world at about 1/2 degree
%        resolution. ETOPOMAP (called without arguments) draws
%        the whole world with the Pacific in the center. 
% 
%        ETOPOMAP('north',MAXLAT) draws a polar projection from the North
%        pole out to latitude MAXLAT. ETOPOMAP('south') does the same for 
%        the South pole (MAXLAT is optional in both cases, but is taken
%        to lie in the same hemisphere as the pole).
%
%        ETOPOMAP(...,[MIN MAX]) sets the limits for colouring. A nice
%        colormap that looks sort of like land and water is used.
      

%Notes: RP (WHOI) 6/Dec/91
%                 7/Nov/92  Changed for matlab4.0
%                 17/Oct/93 New outline file.
%                 14/Mar/94 Fixed polar projections, and changed name
%                           to 'worldmap'.
%                 15/Jul/94 Converted to use etopo5 database


proj='rec';


if (nargin>0),
   if (isstr(axes)),
      if (nargin<2), maxlat=40; else maxlat=abs(maxlat); end;
      if (maxlat>90); error('MAXLAT greater than 90!'); end;
      if (axes(1:3)=='nor'),
         proj='npl';
         axes=[0 359.9157 maxlat 89.9167];
      elseif (axes(1:3)=='sou'),
         proj='spl';
         axes=[0 359.9157 -89.9167 -maxlat];
      else
         error('map: Unrecognized projection!');
      end;
      if (nargin<3), mcolr=[-1e6 1e6]; end;
   else         
      axes=axes(:)';
      if (max(size(axes)) ~= 4), 
         error('map: wrong number of limit args!');
      end;
      if ( (axes(4)-axes(3))>180. ),
         error('map: Lat range greater than 180 degrees');
      end;
      if ( (axes(2)-axes(1))>360. ),
         error('map: Long range greater than 360 degrees');
      else
         if (axes(1)<0. & axes(2)<0. ),
            axes(1:2)=axes(1:2)+360;
         end;
      end;
   if (nargin<2), mcolr=[-1e6 1e6]; 
   else 
      mcolr=maxlat;
       if isnan(mcolr(1)), mcolr(1)=-1e6; end;
       if isnan(mcolr(2)), mcolr(2)=1e6; end;
   end;
   end;
else
   axes=[-334 25 -89.9167 89.9167];
end;
    
eaxes=floor([axes(1:2) 90-axes(3:4)]*12);

efid=fopen('/usr/local/etopo5/etopo5.int2','r');


if (axes(1)<0. & axes(2)>=0. ),   % Read it in in 2 pieces!


  nlat=round((eaxes(3)-eaxes(4)))+1;
  nlng=round((eaxes(2)-eaxes(1)))+1;
  nlgr=round( eaxes(2) )+1;
  nlgl=nlng-nlgr;

  values=zeros(nlat,nlng);
  for ii=[1:nlat],
   fseek(efid,(ii-1+eaxes(4))*360*12*2,'bof');
   values(ii,nlng+[-nlgr:-1]+1)=fread(efid,[1 nlgr],'int16');
   fseek(efid,(ii-1+eaxes(4))*360*12*2+eaxes(1)*2,'bof');
   values(ii,1:nlgl)=fread(efid,[1 nlgl],'int16');
  end;

else  % Read it in one piece

  nlat=round((eaxes(3)-eaxes(4)))+1;
  nlng=round((eaxes(2)-eaxes(1)))+1;
  values=zeros(nlat,nlng);
  for ii=[1:nlat],
   fseek(efid,(ii-1+eaxes(4))*360*12*2+eaxes(1)*2,'bof');
   values(ii,:)=fread(efid,[1 nlng],'int16');
  end;

end;


lngs=[eaxes(1):eaxes(2)]/12+1/24;
lats=flipud([(90*12-eaxes(3):90*12-eaxes(4))]'/12-1/24);


if (proj=='rec'),
  lgstp=ceil(length(lngs)/200);
  ltstp=ceil(length(lats)/200);

  lt2=lats(1:ltstp:length(lats));
  lg2=lngs(1:lgstp:length(lngs));

 val2=values(length(lats):-ltstp:1,1:lgstp:length(lngs)) ;

else
  lngs=lngs-1/24;
  lats=lats-1/24;
  lgstp=ceil(length(lngs)/600);
  ltstp=ceil(length(lats)/100);

  lt2=lats(1:ltstp:length(lats));
  lg2=lngs([1:lgstp:length(lngs)-1 1]);

 val2=values(length(lats):-ltstp:1,[1:lgstp:length(lngs)-1 1]) ;
end; 

if (nargout==3), return; end;

maxh=min(max(max(val2)),mcolr(2));
minh=max(min(min(val2)),mcolr(1));
val2(val2<0)=floor(-val2(val2<0)/minh*20);
val2(val2>=0)=ceil(val2(val2>=0)/maxh*18);
val2=val2+21;

% Make a nice colormap of length 39
ww=[ones(10,2)*.2 [6:15]'/15];
ww2=[ones(10,1)*.2  [3:12]'/15 ones(10,1)];
ll=[1-sin([0:9]'/4)/2  1-sin([2:11]'/4)/3  max(0,.4-[0:9]'/10)];
ll2=[ones(9,3)-[8:-1:0]'/9*(1-ll(10,:))];

if (proj=='rec'),
   colormap([ww;ww2;ll;ll2]);
   lh=image(lg2,lt2,val2);
   set(gca,'ydir','normal','xlim',[min(lg2) max(lg2)],...
       'ylim',[min(lt2) max(lt2)]);
elseif (proj=='npl'),
   xx=(90-lt2)*cos(lg2*pi/180-pi/2);
   yy=(90-lt2)*sin(lg2*pi/180-pi/2);
   lh=pcolor(xx,yy,val2); caxis([1 39]); shading('flat');
   colormap([ww;ww2;ll;ll2]);
   set(gca,'aspect',[1 1]);

elseif (proj=='spl'),
   xx=(90+lt2)*cos(-lg2*pi/180+pi/2);
   yy=(90+lt2)*sin(-lg2*pi/180+pi/2);
   lh=pcolor(xx,yy,val2); caxis([1 39]); shading('flat');
   colormap([ww;ww2;ll;ll2]);
   set(gca,'aspect',[1 1]);
end;



if (proj=='rec'),
 axis(axes);
 xlb=get(gca,'Xticklabels');
 [Nn,Mm]=size(xlb);
 Mf=int2str(Mm);
 nxl=zeros(Nn,Mm+1);
 for kk=1:Nn,
   zz=rem(str2num(xlb(kk,:))+540,360)-180;
   if (zz<0), nxl(kk,:)=sprintf(['%' Mf '.0fW'],abs(zz));
   elseif (zz>0)  nxl(kk,:)=sprintf(['%' Mf '.0fE'],(zz));
   else nxl(kk,:)=sprintf(['%' Mf '.0f '],(zz));
   end;
 end;
 set(gca,'Xticklabels',nxl)

 yx=get(gca,'Ytick');
 ylb=get(gca,'Yticklabels');
 [Nn,Mm]=size(ylb);
 Mf=int2str(Mm);
 nyl=zeros(Nn,Mm+1);
 for kk=1:Nn,
   zz=str2num(ylb(kk,:));
   if (zz<0), nyl(kk,:)=sprintf(['%' Mf '.0fS'],abs(zz));
   elseif (zz>0)  nyl(kk,:)=sprintf(['%' Mf '.0fN'],(zz)); 
   else nyl(kk,:)=sprintf(['%' Mf '.0f '],(zz));
   end;
 end;
 set(gca,'Yticklabels',nyl)
 set(gca,'Ytick',yx);  % Need this to reset position limits
else  % polar projection
  set(gca,'visible','off');
  for kk=10:10:(90-maxlat),
    xx=kk*cos([0:10:360]*pi/180);
    yy=kk*sin([0:10:360]*pi/180);
    line(xx,yy,'color','w','linestyle',':');
  end;
  xx=(90-maxlat)*cos([0:5:360]*pi/180);
  yy=(90-maxlat)*sin([0:5:360]*pi/180);
  line(xx,yy,'color','w','linestyle','-');
  for kk=10:10:(90-maxlat-2),
    if (proj=='npl'), 
       text(0,kk,sprintf('%2.0fN',90-kk),'horizontal','center');
    else
       text(0,kk,sprintf('%2.0fS',90-kk),'horizontal','center');
    end;
  end;
  for kk=0:30:359,
    xx=[10 90-maxlat]*cos(kk*pi/180);
    yy=[10 90-maxlat]*sin(kk*pi/180);
    line(xx,yy,'color','w','linestyle',':');
    if (kk<=180),nyl=sprintf('%3.0fE',kk);
    else nyl=sprintf('%3.0fW',abs(360-kk)); end;
    if (proj=='npl'), 
text(yy(2),-xx(2),nyl,'rotation',kk,'horizontal','center','vertical','top');
    else
text(yy(2),xx(2),nyl,'rotation',-kk,'horizontal','center','vertical','bottom');
    end;
  end;
end;


if (proj=='rec'), grid; end;


