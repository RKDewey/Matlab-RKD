function oplogo(inum,ipos);
% function oplogo(inum,ipos);
% function to generate UVic Ocean Physics Logo
% if inum = 0, then only draw title and wave/T-S profiles
% if inum = 1 or default (call "oplogo") then add address
% if inum = 2 then print four to a page
% if inum = 3 then add address and print to eps, ps, and png files
% if inum > 3 then print inum small logos (i.e. 12 or 24) per page, no text
% Optional 
% ipos=[xo yo dx dy;...] = ipos(inum,4) 
%      are the off-sets and sizes of the boxes for each inum > 3 figure
% RKD 9/98, 7/02
clf
if nargin < 1, inum=1; end
b=[1 1 .9 .5]; % tints of blue
g=[1 .7 .5 .1]; % tints of green
r=[1/1.25 .7/1.25 .5/2.25 .1/2.25]; % tints of red (less red/majenta hues)
for ib=1:4,
   bl(ib,:)=[r(ib) g(ib) b(ib)];
end
f1=figure(1);clf
if inum ==1 | inum==3,
   fps=[.55 .2 .425 .7];
   set(f1,'Units','normalized','Position',fps);
   subplot(1.4,1,1);
   set(gca,'Units','normalized','position',[0.05 0.35 0.9 0.55]);
elseif inum==0
   fps=[.55 .45 .4 .45];
   set(f1,'Units','normalized','Position',fps);
   set(gca,'Units','normalized','position',[0.05 0.05 0.9 0.9]);
elseif inum==2 | inum>3,
   orient tall;
   ppos=get(gcf,'PaperPosition'); % most likely [0.25 0.25 8 10.5]
end
if inum < 2 | inum ==3,
   thewave(3);
elseif inum==2,
   for iplt=1:4,
      if iplt==1, axes('Position',[0.1,.625,.35,.35]);  end
      if iplt==2, axes('Position',[0.55,.625,.35,.35]); end
      if iplt==3, axes('Position',[0.1,.125,.35,.35]);  end
      if iplt==4, axes('Position',[0.55,.125,.35,.35]); end
		% plot the wave
		thewave(3);
   end
elseif inum > 3,
   % page size is 8.5 x 11, so ratio of rows to columns is approximately 11/8.5
   rrtc=11/8.5;
   n=floor(sqrt(inum));
   m=ceil(inum/n);
   ipen=2;
   if inum > 12, ipen=1;end
   if (m/n)<rrtc, n=n-1; m=ceil(inum/n); end
   for i=1:inum,
      if nargin < 2,
         subplot1(m,n,i,.2,.2,.2,.2);
      else
         axes('Position',ipos(i,:)');hold on
      end
      thewave(ipen);
   end
end

if inum==1 | inum==3,
   % the text
   subplot(4,1,4);
	set(gca,'Units','normalized','position',[0.05 0.05 0.9 0.3],'Clipping','off');
	axis([-12 12 0 10.5]);
	clear txt
	txt(1)=text(0,9,'Centre for Earth and Ocean Research');
   txt(2)=text(0,7,'University of Victoria');
   txt(3)=text(0,5,'P.O. Box 3055, Victoria');
   txt(4)=text(0,3,'British Columbia, V8W 3P6 Canada');
	txt(5)=text(0,1.2,'Phone:(250)472-4010 Fax:(250)472-4030'); 
	txt(6)=text(0,0,'http://maelstrom.seos.uvic.ca/');
	tf=0.14;
	set(txt(1:4),'Fontunits','normalized','FontSize',tf,'FontWeight','bold');
	set(txt(5:6),'Fontunits','normalized','FontSize',tf-0.05);
	set(txt(:),'HorizontalAlignment','center','Clipping','off');
	axis tight
	axis off
   set(f1,'PaperUnits','inches','PaperPosition',[2 3 4.5 5]);
elseif inum ==2,
   orient tall
   for iplt=1:4
      if iplt==1, axes('Position',[0.1,.525,.35,.125]); end
      if iplt==2, axes('Position',[0.55,.525,.35,.125]); end
      if iplt==3, axes('Position',[0.1,0.025,.35,.125]); end
      if iplt==4, axes('Position',[0.55,0.025,.35,.125]); end
	set(gca,'Clipping','off');
	axis([-12 12 0 10.5]);
	clear txt
	txt(1)=text(0,9,'Centre for Earth and Ocean Research');
   txt(2)=text(0,7,'University of Victoria');
   txt(3)=text(0,5,'P.O. Box 3055, Victoria');
   txt(4)=text(0,3,'British Columbia, V8W 3P6 Canada');
	txt(5)=text(0,1.2,'Phone:(250)472-4010 Fax:(250)472-4030'); 
%	txt(6)=text(0,0,'http://maelstrom.seos.uvic.ca/');
	tf=0.14;
	set(txt(1:4),'Fontunits','normalized','FontSize',tf,'FontWeight','bold');
	set(txt(5),'Fontunits','normalized','FontSize',tf-0.05);
	set(txt(:),'HorizontalAlignment','center','Clipping','off');
	axis tight
	axis off
   end
end
if inum == 3,
   print -f1 -depsc2 oplogo.eps
   print -f1 -dpsc2 oplogo.ps
   set(f1,'Units','normalized','Position',[0.1 -0.04 0.8 1]);
   print -f1 -dpng oplogo.png
   print -f1 -dmeta
   set(f1,'Position',fps);
end
% end main program

function thewave(ipen);
% The wave
% define the wave function
if nargin < 1, ipen=3; end
theta=[0:1:360]*(pi/180);
r=exp(theta/(2*pi))-1;
[x1,y1]=vector(r,theta,1);
hold on
b=[1 1 .9 .5]; % tints of blue
g=[1 .7 .5 .1]; % tints of green
r=[1/1.25 .7/1.25 .5/2.25 .1/2.25]; % tints of red (less red/majenta hues)
for ib=1:4,
   bl(ib,:)=[r(ib) g(ib) b(ib)];
end
ymin=min(y1);ymax=max(-y1);
iymin=find(y1==ymin);
x2=[0:0.1:3];
y2=y1(iymin)*exp(-(x2.^2)/2);
x=[x1(1:iymin) x2+x1(iymin)]; 
y=[y1(1:iymin) y2];
x=[fliplr(x) -x]; % The wave, from right to left
y=[fliplr(y) -y];
%
xmin=min(x);xmax=max(x);
x3=[xmin:0.1:xmax];  % the upper Gaussian
y3=1.0+max(-y)*exp(-(x3.^2)/2);
up1x=[xmin xmin xmax xmax fliplr(x3)];
up1y=[min(y3) 0.5+max(y3) 0.5+max(y3) min(y3) fliplr(y3)];
fill(up1x,up1y,bl(1,:),'EdgeColor','none'); % fill lightest blue
up2x=[xmin xmin x3 xmax xmax x];
up2y=[0 min(y3) y3 min(y3) 0 y];
fill(up2x,up2y,bl(2,:),'EdgeColor','none'); % fill upper curl
low1x=up2x;
low1y=[0 max(-y3) -y3 max(-y3) 0 y];
fill(low1x,low1y,bl(3,:),'EdgeColor','none');% fill lower curl
fill(up1x,-up1y,bl(4,:),'EdgeColor','none');% fill darkest blue
ymin=min(-up1y);ymax=max(up1y);
% tighten up the axes
axis equal;
axis off;
axis tight;
ax=axis;

% T & S Profiles
t=[3 -.6 .3 -.3 .6 -3];
z=[ymax-0.02 .7 .1 -.1 -.7 ymin];
[t,z]=pinterp(t,z,0.01);
s=-t;
red=[0.9 0 0];
green=[0 0.9 0];
ht=plot(t,z);
set(ht,'color',red,'LineWidth',ipen);
hs=plot(s,z);
set(hs,'color',green,'LineWidth',ipen);
% now make it a T-S helix
indxr1=find((z > -1.0 & z < -0.2));
indxr2=find((z < 1 & z > 0.2));
ht1=plot(t(indxr1),z(indxr1));
set(ht1,'color',red,'LineWidth',ipen);
ht2=plot(t(indxr2),z(indxr2));
set(ht2,'color',red,'LineWidth',ipen);

% title
tall=1.3; % relative height of figure to include title text
ax(4)=ax(4)*tall; % make room for the title (within axis limits)
axis(ax);
htit=text(0.5,0.875,'UVic Ocean Physics','Units','normalized',...
   'Fontunits','normalized','FontSize',0.1,'FontWeight','bold',...
   'HorizontalAlignment','center','VerticalAlignment','bottom');
% draw boarder around wave
plot([ax(1) ax(1) ax(2) ax(2) ax(1)],...
     [ax(3) ax(4)/tall ax(4)/tall ax(3) ax(3)],'k','Clipping','off');
db=0.1; % boarder space around wave and title
plot([ax(1)-db ax(1)-db ax(2)+db ax(2)+db ax(1)-db],...
   [ax(3)-db ax(4) ax(4) ax(3)-db ax(3)-db],'k',...
   'LineWidth',1.5,'Clipping','off');
axis off
% end thewave plotting part
% fini
