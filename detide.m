function [Ur,Vr,Ut,Vt,tr]=detide(U,V,t,UT,VT,tT,flag)
% function [Ur,Vr,Ut,Vt,tr]=detide(U,V,t,UT,VT,tT,flag)
% Detide the original currents U and V with flags and time base t
% by the continuous tides in UT and VT with time base tT
% Residuals are in Ur and Vr and interpolated tides are
% in Ut and Vt, both with (smaller) time base tr, based on tT.
% Optional: flag (default = -99999)
% Uses Dewey's pinterp local quad-fit routine (slow but good...),
%              clean.m and flag2nan.m (-99999 to NaNs)
% as a test: plot(t,U,tr,(Ur+Ut))
% RKD 4/97, 12/97
if nargin < 7, flag=-99999; end
% clean up and remove NaN's
U=flag2nan(U,flag);
V=flag2nan(V,flag);
% make a mask for the data that are NaN's or +/- Inf
mask=ones(size(U));
idx=isnan(U);if ~isempty(idx),mask(idx)=mask(idx)*NaN;end
idx=isinf(U);if ~isempty(idx),mask(idx)=mask(idx)*NaN;end
idx=isnan(V);if ~isempty(idx),mask(idx)=mask(idx)*NaN;end
idx=isinf(V);if ~isempty(idx),mask(idx)=mask(idx)*NaN;end
disp(['Number of NaNs in original U,V data ',num2str(sum(isnan(mask)))]);
U=U.*mask;
V=V.*mask;
%
ids=max(find(t<tT(1)));  % find first data value with tides
ide=min(find(t>tT(length(tT)))); % and last point + 1
%
if (tT(1)-t(ids)) > (t(ids+1)-tT(1)),
   ids=ids+1;
else
   ide=ide-1;
end
%
U=U(ids:ide);  % Restrict the data to the tide window
V=V(ids:ide);  % initialize residuals, a little big for now...
tr=t(ids:ide);
dt=(tT(length(tT))-tT(1))/(length(tr)-1);
%
disp(['Interpolating tidal velocities U.....']);
[Ut,Tr]=pinterp(UT,tT,dt);
disp(['Interpolating tidal velocities V.....']);
[Vt,Tr]=pinterp(VT,tT,dt);
Ut=Ut';Vt=Vt';
% Now form residual Ur=U-Utide
Ur=(U-Ut);
Vr=(V-Vt);
% fini