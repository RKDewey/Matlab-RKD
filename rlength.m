function [rldepth,runlength,prob]=rlength(p,rho)
% function [rldepth,runlength,prob]=rlength(p,rho)
% rlength.m   --  Find runs in a density profile rho(p)
% Output: rldepth(1:2,cnt)=[start end] pressures of runs
%         runlength(cnt)=run length in points
%         prob(1:max(runlength)) = probability distribution of run lengths
% GK ==> KS --> RKD
[rho1,indx]=sort(rho);
tf = rho1 - rho;
oldsign=0; first=0; last=0; run=0; rms=0; cnt=0;
for i=1:length(tf),
  if (((tf(i)==0)&(oldsign~=0)) | ((tf(i)>0)&(oldsign==-1)) | ((tf(i)<0)&(oldsign==1))) 
     % end of run on previous data point
     rldepth(:,cnt)=[first ; last];
	  runlength(cnt)=run;
% prepare next run
	  if (tf(i) ~= 0) 
	    first = p(i); 
	    run = 1;
	    cnt=cnt+1;
    else
	    run = 0; % in case we finish without a new run
	  end 
   else  
     if (((tf(i) > 0) & (oldsign == 1)) | ((tf(i) < 0) & (oldsign == -1))) 
% run continues
         run = run+1; 
         last = p(i); 
     else  
       if ((tf(i) ~= 0) & (oldsign == 0)) 
% start new run
			first = p(i); 
         run = 1; 
         cnt=cnt+1; 
       end
     end
  end  
  if (tf(i) > 0) oldsign = 1; end 
  if (tf(i) < 0) oldsign = -1; end
  if (tf(i) == 0) oldsign = 0; end
  last = p(i);
end
if (run > 0)  
   % end of last run with end of file
    rldepth(:,cnt)=[first ; last];
    runlength(cnt)=run;
end
% Now calculate the run length probability distribution
bins=[1:max(runlength)];
prob=hist(runlength,bins)/cnt;
% fini
