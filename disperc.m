function disperc(i,I);
% function disperc(i,I);
% Display the running percentage of a index process i, with max iteration I
% Initial call with disperc(0,0);
% within loop: if mod(i,20)==0, disperc(i,I); end
% after loop: disperc(I,I);
% RKD 9/06
if i==0,
   fprintf(1,'%6.2f %%',0);  % initialize the print area
elseif i>0 & i<I,
   ip=(i*100/I);
   fprintf(1,'\b\b\b\b\b\b\b\b\b %6.2f %%',ip); % back-space and update.
   drawnow;
elseif i==I,
    disp(' '); % just advance the linefeed.
end

% fini