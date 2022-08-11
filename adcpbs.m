function bsdb=adcpbs(bs,range);
% function bsdb=adcpbs(bs,range);
%
% function to calcualte the acoustic back scatter in db for RDI ADCP bs
% RKD 10/08
bs1=bs*0.45;
lr=2*(20*log10((range-1)' + 0.07*range'))*ones(1,length(bs1));
bsdb=bs1+lr;
% fini
