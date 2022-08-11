function DOout=convert_DO(DOin,T,S,P,cdo,Long,Lat);
% function DOout=convert_DO(DOin,T,S,P,Long,Lat);
% To convert from dissolved oxygen in ml/l to umol/kg, or back
% uses the latest GSW TESO 2010 toolboxes, assumed in path
% Required Inputs
%   DOin is the dissolved Oxygen in the original units (ml/l or umol/kg)
%   T = in situ temperature
%   S = in sito pratical salinity (psu)
%   P = pressure in db
%   cdo=1 to convert ml/l to umol/kg, cdo=-1 umol/kg to ml/l
% Optional Input: 
%   Longitude and Latitude (defaults -124 and 49) affects only 6th decimal
% Output: DO in new units.
%
%   ml/l * 1.42903 = mg/l
%   mg/l * 0.6998 = ml/l
%   ml/l * 44.660 = umol/l
%   (ml/l * 44.660)/(rho/1000) = umol/kg 
%
% RKD Dec 2021
if nargin < 6,
    Long=-124;
    Lat=49;
end
SA=gsw_SA_from_SP(S,P,Long,Lat);
CT=gsw_CT_from_t(SA,T,P);
rho=gsw_rho(SA,CT,P);
%
if cdo==1,
    DOout=(DOin*44.66)./(rho/1000);
else
    DOout=(DOin/44.660).*(rho/1000);
end
% fini

