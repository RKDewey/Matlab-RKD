function [svan, sigma]=spvan(s, t, p0)
% function spvan
% usage: [svan, sigma]=spvan(s,t,p0)
%
%*********************************************************************
% Specific volume anomaly (steric anomaly) based on 1980 equation
% of state for seawater and 1978 Practical Salinity Scale (PSS-78).
% References:
%	Millero, et al, 1980, Deep-Sea Research, 27A, pp255-264.
%	Millero and Posson, 1981, Deep-Sea Research, 28A, pp 625-629.
%	Both above references are also found in UNESCO Report No. 38,
%	1981.
%
% Units:
%	Pressure	p0	decibars
%	Temperature	t	deg celcius (IPTS-68)
%	Salinity	s	(PSS-78)
%	Spec. Vol. Ano.	svan	1.0e-08 m**3/kg
%	Density Ano.	sigma	kg/m**3

% Check value: svan = 981.30210 m**3/kg for s = 40 (PSS-78),
% t = 40 deg C, p0=10000 decibars.

% Check value: sigma = 59.82037 kg/m**3 for s = 40 (PSS-78),
% t=40 deg C, p0 = 10000 decibars.
%*********************************************************************
% Data statements
	r3500=1028.1063; r4=4.8314e-04;
	dr350=28.106331;
%	-- R4 is referred to as c in Millero and Poisson (1981).
%	-- Convert pressure to bars and take square root of salinity.
	p = p0./10.;
	sr = sqrt(abs(s));
%*********************************************************************
%	-- Pure water density at atmospheric pressure:
%	Bigg, P.H., (1967) Br. J. Applied  Physics (8)pp 521-537.

	r1 = ((((6.536332e-09.*t - 1.120083e-06).*t + 1.001685e-04).*t ...
     - 9.095290e-03).*t + 6.793952e-02).*t - 28.263737;
%	-- Seawater density at atmospheric pressure:
%	Coefficients involving salinity.
%	r2 = a in notation of Millerio and Poisson (1981).
	r2 = (((5.3875e-09.*t - 8.2467e-07).*t + 7.6438e-05).*t - ...
     4.0899e-03).*t + 8.24493e-01;
%	-- r3 = b in notation of Millerio and Poisson (1981).
	r3 = ( - 1.6546e-06.*t + 1.0227e-04).*t - 5.72466e-03;
%	-- International one-atmosphere equation of state for seawater:
	sig = (r4.*s + r3.*sr + r2).*s + r1;
%	-- Specific volume at atmospheric pressure
	v350p = 1.0./r3500;
	sva = - sig.*v350p./(r3500 + sig);
	sigma = sig + dr350;
%	-- Scale specific volume anomaly to normally reported units
	svan = sva .* 1.0e+08;
	if p == 0.0 
          return
     end

%*********************************************************************
%****** NEW HIGH PRESSURE EQUATION OF STATE FOR SEAWATER *************
%*********************************************************************
%	Millero, et al, 1980, Deep Sea Res. 27A, pp255-264
%	Constant notation follows article
%*********************************************************************
%	-- Compute compression terms
	e = (9.1697e-10.*t + 2.0816e-08).*t - 9.9348e-07;
	bw = (5.2787e-08.*t - 6.12293e-06).*t + 3.47718e-05;
	b = bw + e.*s;

	d = 1.91075e-04;
	c = ( - 1.6078e-06.*t - 1.0981e-05).*t + 2.2838e-03;
	aw = (( - 5.77905e-07.*t + 1.16092e-04).*t + 1.43713e-03).*t ...
     -0.1194975;
	a = (d.*sr + c).*s + aw;

	b1 = ( - 5.3009e-04.*t + 1.6483e-02).*t + 7.944e-02;
	a1 = (( - 6.1670e-05.*t + 1.09987e-02).*t - 0.603459).*t + 54.6746;
	kw = ((( - 5.155288e-05.*t + 1.360477e-02).*t - 2.327105).*t ...
     + 148.4206).*t - 1930.06;
	k0 = (b1.*sr + a1).*s + kw;

%	-- Evaluate pressure Polynomial
%***************************************************
% k equals the secant bulk modulus of seawater
% dk = k(s,t,p) - k(35,0,p)
% k35 = k(35,0,p)
%***************************************************

	dk = (b.*p + a).*p + k0;
	k35 = (5.03217e-05.*p + 3.359406).*p + 21582.27;
	gam = p./k35;
	pk = 1.0 - gam;
	sva = sva.*pk + (v350p + sva).*p.*dk./(k35.*(k35 + dk));
%	-- Scale specific volume anomaly to normally reported units
	svan = sva.*1.0e+08;
	v350p = v350p.*pk;
%*********************************************************************
% Compute density anomaly with respect to 1000.0 kg/m**3
%   1) dr350: Density anomaly at 35 (PSS-78), 0 deg C and 0 decibars
%   2) dr35p: Density anomaly; 35 (PSS-78), 0 deg C, press variation
%   3) dvan : density anomaly variations involving specific vol. Anomaly
%*********************************************************************
%   Check value: sigma = 59.82037 kg/m**3 for s=40 (PSS-78), t=40 deg C,
%	p=10000 decibars
%*********************************************************************
	dr35p = gam./v350p;
	dvan = sva./(v350p.*(v350p + sva));
	sigma = dr350 + dr35p - dvan;
