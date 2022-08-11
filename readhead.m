function hdgdata=readhead(fext);
% function hdgdata=readhead(fext);
%  function to read raw external heading file recorded during ADCP data acquisition
% Input is heading filename or just extension 'N1R' (default)
% Output: hdgdata.ens
%         hdgdata.heading (magnetic)
% RKD 05/09

% 123456789012345678901234567890
% $PADCP,1,20090508,090258.02
% $HCHDM,273.3,M*2C

if nargin<1, fext='N1R'; end
if length(fext)<4,
    files=dir(['*.',fext]);
else
    files(1).name=fext;
end
i=0;
iavg=0;hdg=0;
ens=ones(1,100000)*0;
heading=ens*NaN;
for f=1:length(files),
    fid=fopen(files(f).name);
    iread=1;
    while iread,
        line=fgets(fid);
        if line==-1,
            iread=0;
        else
            if length(line)>20,
                if strcmp(line(1:6),'$PADCP'),
                    ic=find(line==',');
                    i=i+1;
                    ens(i)=str2num(line(ic(1)+1:ic(2)-1));
                    if iavg>0 & i>1,
                        heading(i-1)=hdg/iavg;
                        iavg=0;hdg=0;
                    end
                end
            elseif length(line)<20 & length(line)>15,
                    if strcmp(line(1:6),'$HCHDM'),
                    ic=find(line==',');
                    if i>0,
                        iavg=iavg+1;
                        hdg=hdg+str2num(line(ic(1)+1:ic(2)-1));
                    end
                end
            end
        end
        if i>1 & mod(i,150*6)==0 & iavg==1, disp([' Ensembles read so far: ',num2str(i),'  Ensemble # = ',num2str(ens(i))]); end
    end
    if iavg>0,
       heading(i)=hdg/iavg;
       iavg=0;hdg=0;
    end
    fclose(fid);
end
indx=find(ens~=0);
hdgdata.ens=ens(indx);
hdgdata.heading=heading(indx);
% fini