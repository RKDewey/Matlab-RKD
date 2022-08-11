function HH=fbox
% FBOX Draw a fancy box around a map plot, as well as degrees/minutes/seconds
%      stuff for axes. If you are doing funny things with the aspect ratio,
%      this won't look good on the screen unless you do 'wysiwyg'.
%

% Rich pawlowicz (IOS) 6/6/96
% rich@ios.bc.ca

xlm=get(gca,'XLim');
ylm=get(gca,'YLim');
tkln=get(gca,'TickLength');
xdir=get(gca,'XDir');
ydir=get(gca,'YDir');
tkln=tkln(1);

xtk=get(gca,'Xtick');
ytk=get(gca,'Ytick');

edgec=1-get(gcf,'Color');

% Handle aspect ratio stuff if this has NOT been set by the user.
asp=get(gca,'PlotBoxAspectRatioMode');
if asp(1) == 'a',
 apos=get(gca,'Position');
 fasp=apos(3)/apos(4);
 unts=get(gca,'Units');
 if (unts(1:3)=='nor'),
  ppos=get(gcf,'PaperPosition');
  fasp=fasp*ppos(3)/ppos(4);
 end;
 if (fasp>diff(xlm)/diff(ylm)*asp(2)),
   xlm=mean(xlm)+diff(ylm)*fasp/asp(2)*[-.5 .5];
 else
   ylm=mean(ylm)+diff(xlm)*asp(2)/fasp*[-.5 .5];
 end;
end;

% generate nice ticklabels and stuff.

% do xlabels
xtkmod=get(gca,'XTickMode');
if (xtkmod(1:3)=='aut' | xtkmod(1:3)=='man'),
 if (xtk(2)-xtk(1))>1,  % degrees only
   xtkl=get(gca,'XTickLabel');
   xxtkl=32*ones(size(xtkl)+[0 1]);
   ii=xtk>0;
   if xdir(1) ~= 'r',
      if (any(ii)), xxtlk(ii,:)=[xtkl(ii,:) 'E'*ones(length(ii),1)]; end;
   else
      if (any(ii)), xxtlk(ii,:)=[xtkl(ii,:) 'W'*ones(length(ii),1)]; end;
   end
   ii=xtk<0;
   if (any(ii)), xxtlk(ii,:)=[' '*ones(length(ii),1) xtkl(ii,2:size(xtkl,2)) 'E'*ones(length(ii),1)]; end;
   ii=xtk==0;
   if (any(ii)), xxtlk(ii,:)=[xtkl(ii,:) ' '*ones(length(ii),1)]; end;
 else  % Handle smaller fractions.
   allow=[1 2 3 5 10 15 20 30 60 120 180 240 300];  % Allowable increments.
   [d,I]=min(abs((xtk(2)-xtk(1))*60-allow));  
   J=sum((xlm(2)-xlm(1))*60>allow)+1;
   if J>length(allow),J=length(allow);end
   if J<1, J=1; end
   xtk=floor(xtk(1)):allow(I)/60:ceil(max(xtk));
   xtk=xtk(xtk>=xlm(1) & xtk<=xlm(2));
   xtkl=[];
   for ii=1:length(xtk);
     deg=floor(abs(xtk(ii)));
     mns=(abs(xtk(ii))-deg)*60;
     if (fix(mns/allow(J) )==mns/allow(J) );
        if xdir(1) ~= 'r',
           xtkl=str2mat(xtkl,sprintf('%.0f%1s%.0f''%1s',deg,176,mns,'E'+(xtk(1)<0)*18) );
        else
           xtkl=str2mat(xtkl,sprintf('%.0f%1s%.0f''%1s',deg,176,mns,'W'+(xtk(1)<0)*18) );
        end
     else
       xtkl=str2mat(xtkl,sprintf('    %.0f''',mns));
     end;
   end;
   set(gca,'XTick',xtk,'XTickLabel',xtkl(2:size(xtkl,1),:));
 end;
end;

ytkmod=get(gca,'YTickMode');
if (ytkmod(1:3)=='aut' | ytkmod(1:3)=='man'),
 if (ytk(2)-ytk(1))>1,  % degrees only
   ytkl=get(gca,'YTickLabel');
   yytkl=32*ones(size(ytkl)+[0 1]);
   ii=ytk>0;
   if ydir(1) ~= 'r',
      if (any(ii)), yytlk(ii,:)=[ytkl(ii,:) 'N'*ones(length(ii),1)]; end;
   else
      if (any(ii)), yytlk(ii,:)=[ytkl(ii,:) 'S'*ones(length(ii),1)]; end;
   end
   ii=ytk<0;
   if (any(ii)), yytlk(ii,:)=[' '*ones(length(ii),1) ytkl(ii,2:size(ytkl,2)) 'N'*ones(length(ii),1)]; end;
   ii=ytk==0;
   if (any(ii)), yytlk(ii,:)=[ytkl(ii,:) ' '*ones(length(ii),1)]; end;
 else  % Handle smaller fractions.
   mins=(ytk(2)-ytk(1))*60;
   allow=[1 2 3 5 10 15 20 30 60 120 180 240];    % Allowable increments.
   [d,I]=min(abs((ytk(2)-ytk(1))*60-allow));  
   J=sum((ylm(2)-ylm(1))*60>allow)+0; %%%+1;
   if J>length(allow),J=length(allow);end
   if J<1, J=1; end
   ytk=floor(ytk(1)):allow(I)/60:ceil(max(ytk));
   ytk=ytk(ytk>=ylm(1) & ytk<=ylm(2));
   ytkl=[];
   for ii=1:length(ytk);
     deg=floor(abs(ytk(ii)));
     mns=(abs(ytk(ii))-deg)*60;
     if (fix(mns/allow(J))==mns/allow(J));
        if ydir(1) ~= 'r',
           ytkl=str2mat(ytkl,sprintf('%.0f%1s%.0f''%1s',deg,176,mns,'N'-(ytk(1)<0)*5) );
        else
           ytkl=str2mat(ytkl,sprintf('%.0f%1s%.0f''%1s',deg,176,mns,'S'-(ytk(1)<0)*5) );
        end
     else
       ytkl=str2mat(ytkl,sprintf('   %.0f''',mns));
     end;
   end;
   set(gca,'YTick',ytk,'YTickLabel',ytkl(2:size(ytkl,1),:));
 end;
end;
%
% Now draw black and white border
%
x1=[xlm(1) xtk(xtk>xlm(1)+1e4*eps & xtk<xlm(2)-1e4*eps) xlm(2)];lx1=length(x1);
y1=[ylm(1) ytk(ytk>ylm(1)+1e4*eps & ytk<ylm(2)-1e4*eps) ylm(2)];ly1=length(y1);
%
odx=rem(lx1,2);
ody=rem(ly1,2);
dy=tkln*diff(ylm);
dx=tkln*diff(xlm);
% draw lower x-axis
X1=[x1(1:2:lx1-1);x1(2:2:lx1);x1(2:2:lx1);x1(1:2:lx1-1)];
Y1=ylm(1)+dy*[1;1;0;0]*ones(1,length(2:2:lx1));
X1(1)=X1(1)+dx;
%
sX1=size(X1,2)-1;if sX1<1, sX1=1; end
if ~odx, X1(1,sX1)=X1(1,sX1)-dx; end;
HH=patch(X1,Y1,'k','EdgeColor',edgec);
X1=[x1(2:2:lx1-1);x1(3:2:lx1);x1(3:2:lx1);x1(2:2:lx1-1)];
Y1=ylm(1)+dy*[1;1;0;0]*ones(1,length(3:2:lx1));
if odx, X1(2,size(X1,2))=X1(2,size(X1,2))-dx; end;
HH=[HH;patch(X1,Y1,'w','EdgeColor',edgec)];
% draw upper x-axis
X1=[x1(1:2:lx1-1);x1(2:2:lx1);x1(2:2:lx1);x1(1:2:lx1-1)];
Y1=ylm(2)-dy*[1;1;0;0]*ones(1,length(2:2:lx1));
X1(1)=X1(1)+dx;
%
sX1=size(X1,2)-1;if sX1<1, sX1=1; end
if ~odx, X1(1,sX1)=X1(1,sX1)-dx; end;
HH=[HH;patch(X1,Y1,'k','EdgeColor',edgec)];
X1=[x1(2:2:lx1-1);x1(3:2:lx1);x1(3:2:lx1);x1(2:2:lx1-1)];
Y1=ylm(2)-dy*[1;1;0;0]*ones(1,length(3:2:lx1));
if odx, X1(2,size(X1,2))=X1(2,size(X1,2))-dx; end;
HH=[HH;patch(X1,Y1,'w','EdgeColor',edgec)];

% draw left y-axis
Y1=[y1(1:2:ly1-1);y1(2:2:ly1);y1(2:2:ly1);y1(1:2:ly1-1)];
X1=xlm(1)+dx*[1;1;0;0]*ones(1,length(2:2:ly1));
Y1(1)=Y1(1)+dy;
if ~ody, Y1(2,size(Y1,2))=Y1(2,size(Y1,2))-dy; end;
HH=[HH;patch(X1,Y1,'k','EdgeColor',edgec)];
Y1=[y1(2:2:ly1-1);y1(3:2:ly1);y1(3:2:ly1);y1(2:2:ly1-1)];
X1=xlm(1)+dx*[1;1;0;0]*ones(1,length(3:2:ly1));
if ody, Y1(2,size(Y1,2))=Y1(2,size(Y1,2))-dy; end;
HH=[HH;patch(X1,Y1,'w','EdgeColor',edgec)];
% draw right y-axis
Y1=[y1(1:2:ly1-1);y1(2:2:ly1);y1(2:2:ly1);y1(1:2:ly1-1)];
X1=xlm(2)-dx*[1;1;0;0]*ones(1,length(2:2:ly1));
Y1(1)=Y1(1)+dy;
if ~ody, Y1(2,size(Y1,2))=Y1(2,size(Y1,2))-dy; end;
HH=[HH;patch(X1,Y1,'k','EdgeColor',edgec)];
Y1=[y1(2:2:ly1-1);y1(3:2:ly1);y1(3:2:ly1);y1(2:2:ly1-1)];
X1=xlm(2)-dx*[1;1;0;0]*ones(1,length(3:2:ly1));
if ody, Y1(2,size(Y1,2))=Y1(2,size(Y1,2))-dy; end;
HH=[HH;patch(X1,Y1,'w','EdgeColor',edgec)];
%
set(gca,'FontName','Times');
%