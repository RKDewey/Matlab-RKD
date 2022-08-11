function [X,Y,T]=pvd(u,v,t);
% function [X,Y,T]=pvd(u,v,t);
% Function to calculate the Progressive Vector Diagram components
% X (E-W) and Y (N-S) with a common time series of t, t(1) must be good
% time
% The displacment units are in km assuming the velocity time series u
% and v are in m/s and the time stamps are in Matlab Julian days (mtime).
% This routine tries to handle data gaps and NaNs. Large gaps near the ends
% are tricky to handle and may crash the routine/misbehave.
% 
% To plot the PVD, simply use plot and then date the Nth point:
% plot(X,Y);
% for i=2:4:length(T),text(X(i)+10,Y(i)+10,datestr(T(i),20));end
% 
% RKD 11/11
t0=t(1);
t=(t-t0)*24*3600; % t is now in seconds
jnn=~isnan(t); % The good values
dT=diff(t(jnn));  % time gap/steps between samples
mdT=median(dT);  % this is the median dT
mindT=min(dT);maxdT=max(dT);
% Clean up gaps
U=u;V=v;T=t;
% First, if there are temporal gaps, fill with NaNs
if maxdT > 1.5 * mdT, % then there are big gaps
    for jT=(length(dT)-1):-1:1,  % start at the back and work forwards
        if dT(jT) > 1.5 * mdT,
           idT=ceil((t(jT+1)-t(jT))/mdT)-1; % how many to fill
           if idT > 0, % confirm this is a gap of at least one time step
               il=length(U);
               U(jT+1+idT:il+idT)=U(jT+1:il); % shift the good values back
               V(jT+1+idT:il+idT)=V(jT+1:il);
               T(jT+1+idT:il+idT)=T(jT+1:il);
               U(jT+1:jT+idT)=NaN; % fill the gap with NaNs
               V(jT+1:jT+idT)=NaN;
               T(jT+1:jT+idT)=T(jT)+mdT*[1:idT]; % fill the time steps
           end
        end
    end
end
jn=sum(isnan(U)+isnan(V));  % if there are NaNs, handle like gaps
jnn=~isnan(U); % The good values
mdT=median(diff(T));  % this is the median dT
mindT=min(dT);maxdT=max(dT);
% Now fill in NaN gaps in u and v
if jn > 0, % then there are NaNs to fill
    % first clip off any leading or trailing NaNs
    jnnu=~isnan(U);
    ist=min(find(jnnu==1));iend=max(find(jnnu==1));
    U=U(ist:iend);V=V(ist:iend);T=T(ist:iend);
    jnnv=~isnan(V);
    ist=min(find(jnnv==1));iend=max(find(jnnv==1));
    U=U(ist:iend);V=V(ist:iend);T=T(ist:iend);
    % these are the new clipped U V and T
    % now fill in internal NaN gaps in u
    jnnu=~isnan(U);jnu=[1:length(U)];jnu(jnnu)=[];
    if length(jnu)>1, % NaNs in u to be filled
        for j=jnu,
            if ~isnan(U(j+1)), % then only one NaN to fill
                U(j)=(U(j-1)+U(j+1))/2;
                T(j)=(T(j-1)+T(j+1))/2;
            else % then a block of NaNs to fill
                for ju=j+2:length(U),
                    if ~isnan(U(ju)), break; end
                end
                dj=ju-j; % number of NaNs to fill
                U(j:ju-1)=(mean(U([j-dj:j-1]))+mean(U([ju:ju+dj-1])))/2;
                T(j:ju-1)=T(j-1)+mdT*[1:dj];
            end
        end
    elseif length(jnu)==1,
        % need to handle a single NaN differently
        j=jnu(1);
        U(j)=(U(j-1)+U(j+1))/2;
        T(j)=(T(j-1)+T(j+1))/2;
    end
    % fill in NaN gaps in V
    jnnv=~isnan(V);jnv=[1:length(V)];jnv(jnnv)=[];
    if length(jnv)>1, % NaNs in v to be filled
        for j=jnv,
            if ~isnan(V(j+1)), % then only one NaN to fill
                V(j)=(V(j-1)+V(j+1))/2;
                T(j)=(T(j-1)+T(j+1))/2;
            else % then a block of NaNs to fill
                for jv=j+2:length(V),
                    if ~isnan(V(jv)), break; end
                end
                dj=jv-j; % number of NaNs to fill
                V(j:jv-1)=(mean(V([j-dj:j-1]))+mean(V([jv:jv+dj-1])))/2;
                T(j:jv-1)=T(j-1)+mdT*[1:dj];
            end
        end
    elseif length(jnu)==1,
        % need to handle a single NaN differently
        j=jnu(1);
        U(j)=(U(j-1)+U(j+1))/2;
        T(j)=(T(j-1)+T(j+1))/2;
    end
end
X=[0 cumsum(U)*mdT/1000];  % east-west displacment in km
Y=[0 cumsum(V)*mdT/1000];  % north-south displacment in km
T=t0+[-mdT T]/(24*3600);
% fini