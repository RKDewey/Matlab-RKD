function k=kpp(ri)
% function k=kpp(ri)
% Calculate the vertical diffusivity acording to 
% Pacanowsky and Philander JPO 1981 
% Input the richardson number Ri
	k=1e-5 + (5e-3 + 1e-4*(1+5*ri).^2)./(1+5*ri).^3;
% fini