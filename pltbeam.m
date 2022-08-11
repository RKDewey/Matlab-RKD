function [D,phi]=pltbeam(R,F,an,dbmin,ispolar);
% function D=pltbeam(R,F,an,dbmin,ispolar)
% Plot the beam pattern for an ocean acoustic transducer with:
% R=radius a (m)
% F=frequency (kHz)
% Optional parameters
% an= angle range to calculate/plot over (default=20 degrees)
% dbmin = range from peak to dbmin (default dbmin = -60)
% ispolar = 0 to plot manual polar plot (default), 1 use matlabs polar
% Output: [D,phi] where D(phi) is relative sensativity 10*log(D^2) for plot
% RKD 5/00
a=R;
if nargin<3, an=20; end
if nargin<4, dbmin=-60; end
if nargin<5, ispolar=0; end
lambda=1500/(F*1000); % wavelength in m
k=2*pi/lambda; % wavenumber
phi=[-(an*pi/180):0.0001:(an*pi/180)];
J1=besselj(1,k*a*sin(phi));
D=2*J1./(k*a*sin(phi));
clf;
da=min([an/6 10]);
xt=[-an:da:an];
xtl=num2str(xt');
%if length(xt>10);da=an/5;xt=[-an:da:an];end
yt=[dbmin:10:0];
ytl=num2str(yt');
if ispolar==0,
	phi=phi+pi/2;
	X=real(cos(phi).*(10*log10(D.^2)-dbmin));
	Y=real(sin(phi).*(10*log10(D.^2)-dbmin));
	plot(X,Y);hold on
	axis off
	i1=find(Y>0);
	xm=2*max(abs(X(i1)));
	axis([-xm xm 0 abs(dbmin)]);
	plot([-xm xm xm -xm -xm],[0 0 abs(dbmin) abs(dbmin) 0],'k');
	for ann=xt*pi/180+(pi/2),
	   x=[0 abs(dbmin)]*cos(ann);
	   y=[0 abs(dbmin)]*sin(ann);
	   plot(x,y,'--k');
	   xl=length(x);
	   if abs(x(2)+sign(x(2))*(0.02*xm))<xm,
	   if ann~=(pi/2),
	      text(x(2)+sign(x(2))*(0.02*xm),y(2)-2,num2str(fix(ann*180/pi-90)));
	   end
	   end
    end
    indx=find((10*log10(D.^2))>-3.1);
    hdb=(abs(phi(indx(end)))-pi/2)*180/pi;
    plot(X(indx(1)),Y(indx(1)),'r+',X(indx(end)),Y(indx(end)),'r+');
    text(X(indx([1 end]))-0.2,Y(indx([1 end]))+1,num2str(round(hdb)));
	ang=[-an:0.1:an]*pi/180+pi/2;
	for rn=abs(yt(2:end-1)),
	   x=rn*cos(ang);
	   y=rn*sin(ang);
	   plot(x,y,'--k');
	   text(0.025*xm,max(y)+1,['-',num2str(fix(abs(dbmin)-rn)),'db']);
	end
else % then use Matlab's Polar routine (limited axis control)
	polar(phi+pi/2,(10*log10(D.^2)-dbmin));
	% axis off
	axis([-sin(an*pi/180)*abs(dbmin) sin(an*pi/180)*abs(dbmin) 0 abs(dbmin)])
	set(gca,'YLim',[0 -dbmin],'YTick',yt,'YTickLabel',ytl);
	set(gca,'XLim',[-sin(an*pi/180)*abs(dbmin) sin(an*pi/180)*abs(dbmin)],'XTick',xt,'XTickLabel',xtl);
end
% fini
