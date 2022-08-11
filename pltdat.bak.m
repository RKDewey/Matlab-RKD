function pltdat
%
% Script file to plot the time and date at the lower right hand corner
%
clck=clock;
timdat(1:2)=sprintf('%2.0f',clck(4));
timdat(3)=':';
if clck(5) < 10
   timdat(4)='0';
   timdat(5)=sprintf('%1.0f',clck(5));
else
   timdat(4:5)=sprintf('%2.0f',clck(5));
end
timdat(6)=' ';
timdat(7:8)=sprintf('%2.0f',clck(2));
timdat(9)='/';
timdat(10:11)=sprintf('%2.0f',clck(3));
timdat(12)='/';
clck(1)=clck(1)-(100*floor(clck(1)/100));
timdat(13:14)=sprintf('%2.0f',clck(1));
axes('Position',[0 0 1 1],'Visible','off')
text('String',timdat,'FontSize',6,'Position',[0.85 0.05]);
%
