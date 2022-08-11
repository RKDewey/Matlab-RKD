function ph=tsplot(t,s,isigt,z);
% function ph=tsplot(t,s,isigt,z) 
% where t=temperature, s=salinity
% optional: 
%    isigt = 0 do not plot sigma-t lines
%    isigt = 1 plot lines, no labels
%    z (depth array) to plot about 5 depth spaced symbols 
% No arguments plots a full scale T-S+sigma_t plot
% ph are the plot point handles
% RKD 12/95

if nargin < 1, t=[0 28];s=[0 40]; isgt=2; end
if nargin < 3, isigt = 2; end
if nargin < 4, z=ones(size(t)); end
axpos=get(gca,'Position');
if axpos(3)>.25 | axpos(4) >.25,
    titon=1; % Labels on
else
    titon=0; % labels off
end
idxz=[];
if nargin == 4,
   zp=round((1:5)*(ceil(max(z)/100)/5)*100);
   for i=1:length(zp),
      idxz(i)=round(mean(find(round(z) == zp(i)))); 
   end
   idxz=idxz(find(isnan(idxz) == 0)); % just save the non NaN indecies
end
%
if isigt > 0,
   tmm=minmax(t);tmin=tmm(1);tmax=tmm(2);
   smm=minmax(s);smin=smm(1);smax=smm(2);
   dt=(tmax-tmin)/6;ds=(smax-smin)/6;
   tg=[(tmin-dt):(tmax-tmin)/40:(tmax+dt)];
   sg=[(smin-ds):(smax-smin)/40:(smax+ds)];
   if min(sg)<0, idx=find(sg >= 0); sg=sg(idx); tg=tg(idx); end
   if max(sg)>46, idx=find(sg <= 46); sg=sg(idx); tg=tg(idx); end
   if min(tg)<-3, idx=find(tg >= -3); tg=tg(idx); sg=sg(idx); end
   if max(tg)>32, idx=find(tg <= 32); tg=tg(idx); sg=sg(idx); end
   [S,T]=meshgrid(sg,tg);
   rho=sigmat(T,S);
   drho=[.0001 .001 .002 .005 .01 .02 .05 .1 .2 .5 1. 2. 5.];
   minrho=min(min(rho));maxrho=max(max(rho));
   dr=(maxrho-minrho)/5;
   if isempty(dr), dr=0.1; end
   dr=max(drho(find(drho <= dr)));
   if isempty(dr), dr=0.01; end
   v=[floor(minrho):dr:ceil(maxrho)];
   if isigt==1,
      [c,ch]=contour(sg,tg,rho,v);
   elseif isigt==2,
      [c,ch]=contour(sg,tg,rho,v);
      set(ch(:),'LineWidth',1);
      if titon, title('T-S Plot with Sigma_t'); end
      clabel(c,ch);
	   hold on
	   axis(axis)
       if titon,
	   ylabel('Temperature [ \circ C]');
	   xlabel('Salinity [psu]');
       else
           set(gca,'FontSize',6);
       end
	   % plot line of maximal density
	   for i=1:length(sg),
	      tmax(i)=tg(find(rho(:,i)==max(rho(:,i))));
	   end
	   plot([0 24.7],[4 -1.332],'k');
	   plot(sg,sw_fp(sg,zeros(size(sg))),'b');
	   grid on
   end
end
hold on
if nargin > 1, 
   ph=plot(s,t,'k');
   if  ~isempty(idxz),
      plot(s(idxz),t(idxz),'r+'); 
   end
end

%