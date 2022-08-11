function earth = beam2uvw(BEAM,HH,PP,RR,EL,AZ,GOOD,OPTS,C,WF,WN,WS,UD,TY)

% function earth = beam2uvw(BEAM,HH,PP,RR,EL,AZ,GOOD,OPTS,C,WF,WN,WS,UD,TY)
%
% recovers earth velocities from ADCP beam velocities
% Ver. 2.0 - modified to allow processing of UVic vertical beam ADCP (Cyclops) 
%
% required inputs:
%	BEAM    - beam velocities (k x n x 4 matrix)
%			BEAM(:,:,i) is VELbeami (the ith beam velocity)
%			k is the number of ensembles
%			n is the number of bins
%			bad data denoted by NaNs (not ADCP flag of 99999)
%	HH	- ADCP heading in degrees (vector of length k)
%	PP	- ADCP pitch   in degrees (vector of length k)
%	RR	- ADCP roll    in degrees (vector of length k)
%
% optional inputs: 
%	EL	- vertical beam angle of ADCP transducers (vector length 4)
%			default is dependent on TY:  
%				TY==1 -> EL==[0];
%				TY==2 -> EL==[4];
%			if EL==[0], use [-70 -70 -70 -70]	      (nominal Janus)
%			if EL==[1], use [-69.77 -69.48 -69.65 -70.08] (Garrett)
%			if EL==[2], use [-69.96 -69.92 -70.26 -70.29] (Farmer)
%			if EL==[3], use [-70.00 -70.00 -70.00 -70.00] (MacCready)
%			if EL==[4], use [-90 -70 -70 -70] 	      (UVic Cyclops)
%           if EL==[5], use [-70 -70 -70 -70]         (UVic deep Janus)
%	AZ	- azimuthal beam angle of ADCP transducers (vector length 4)
%			default is dependent on TY:
%                               TY==1 -> AZ==[0];
%                               TY==2 -> AZ==[4];               
%			if AZ==[0], use [270 90 0 180]		      (nominal Janus)
%			if AZ==[1], use [271.44 91.43 358.57 178.56]  (Garrett)
%			if AZ==[2], use [270.20 90.19 359.81 179.81]  (Farmer)
%			if AZ==[3], use [270.00 90.00 0.01 180.00]    (MacCready)
%			if AZ==[4], use [0 180 300 60]		      (UVic Cyclops)
%           if AZ==[5], use [270 90 0.01 180]         (Uvic Deep Janus)
%	GOOD    - percent good (n x 4 matrix) of beam velocity data
%			default has [100]
%			GOOD==[100] implies OPTS(3) = GOODlim set to 0
%	OPTS	- options to use (vector length 6) see parameter list below
%			[beam3 cellmap GOODlim NaNlim interpo CASE]
%			default has [1 2 0 0 5 3]
%			BBLIST uses [1 1 0 0 0 3]
%	C	- speed of sound in water (vector length 2)
%			[Ctru Cpro]
%			for sound speed correction to velocity and beam length
%			default is [1500 1500]	ie. no correction
%			Ctru is true speed at ADCP transducers
%				use formula in Appendix F (RDI manual) 
%			Cpro is assumed speed programmed at ADCP deployment
%	WF		- distance between instrument and 1st bin in cm.
%			  (default value 176)
%
%	WN		- number of bins  (default to size(BEAM,2))
%
%	WS		- size of each bin in cm. (default value 200)
%
%	UD		- orientation of transducers
%				1: upward looking 
%				2: downward looking (default)
%	TY		- configuration of transducers
%				1: Janus (default)
%				2: Cyclops
%  Default parameters can be obtained by leaving them out or
%  inserting an empty matrix []:
%  eg. earth = beam2uvw(BEAM,HH,PP,RR,[],[],GOOD,[],[],[],[],WS,UD,TY)
%
% parameters:
%	beam3	- allows 3 beam solution (error velocity is undefined)
%			  0: do not allow 3 beam solution
%			  1: compute 3 beam solution if 1 bad beam (NaN)
%	cellmap	- corrects bin depth (pitch, roll, heading, sound speed)
%			  0: no cell mapping
%			  1: RDI ADCP cell map (nearest) for each beam
%			  2: linear interpolation to actual depth
%	GOODlim	- replaces beam data with NaNs if GOOD < GOODlim
%		  (no checking is done if GOOD is not supplied)
%		  	  range: 0 - 100
%			GOODlim == [0] implies no checking is done
%	NaNlim	- allows beam data above NaN regions to be discarded
%		  (each beam is checked independently)
%			  0: keep all data
%			  1: discard data above lowest NaN
%			n>1: discard above lowest n consecutive NaNs
%	interpo	- perform vertical interpolation over interior NaNs
%			  0: no interpolation (do not replace any NaNs)
%			  1: linearly interpolate over single NaNs
%			n>1: linearly interpolate only over interior
%				NaN strings with <= n consecutive NaNs
%	CASE	- manner in which ADCP angle sensors are attached (Appendix F)
%			ADCP has CASE == 3
%			  1: pitch   correction  (Appendix F-7)
%			  2: no      corrections
%			  3: heading correction
%
% Michael Ott 25 Apr 1997
% Appended by Keir Colbo October 5,1998
% Appended by Steven Stringer November 20, 2000
% Appended by RKDewey June 2004 include new UVic Deep (Orange) Janus
%  eg. earth = beam2uvw(BEAM,HH,PP,RR,EL,AZ,GOOD,[1 2 0 0 5 3],[1500 1500],[176],[],WS,UD,TY)

if nargin < 4  % Ensure that mininum number of inputs present.
   error('Requires at least 4 inputs')
end

% Fill missing inputs with default values
if nargin < 14
TY = 1;
disp('Default transducer configuation: Janus')
if nargin < 13
UD = 2; % default downward looking
disp('Default transducer orientation: downward looking')
   if nargin < 12
      WS = 200;
      disp('Default bin height: WS = 200cm');
      if nargin < 11
         WN = size(BEAM,2);
         disp(['Default # of bins: WN = size(BEAM,2) = ' num2str(WN)]);
         if nargin < 10
            WF = 176;
            disp('WF set to default value of 176');
            if nargin < 9 
               C = [1500 1500];
               disp('Speed of sound set to default value of 1500 m/s');
               if nargin < 8
                  OPTS = [1 2 0 0 5 3];
                  disp('Default Options:')
                  disp('  - Allow three-beam solution');
                  disp('  - Linear cell mapping');
                  disp('  - No minimum percent good');
                  disp('  - Keep all data values');
                  disp('  - Interpolate vertically only over less than 5 consecutive NaNs');
                  disp('  - Heading correction');
                  if nargin < 7
                     GOOD = 100;
                     OPTS(3) = 0;
                     disp('No percent good check performed');
                     if nargin < 6
			if TY == 1
                          AZ = [0];
                          disp('Default Janus azimuthal angles [270 90 0 180]');
			else
			  AZ = [4];
			  disp('Default Cyclops azimuthal angles [0 180 300 60]');
			end
                        if nargin < 5
			   if TY == 1
                             EL = [0];
                             disp('Default Janus elevation angles [-70 -70 -70 -70]');
			   else
			     EL = [4];
			     disp('Default Cyclops elevation angles [-90 -70 -70 -70]');
			   end
                        end
                     end
                  end
               end
            end
         end
      end
   end
end
end
if length(TY) == 0
   TY = 1;
   disp('Default transducer configuration: Janus')
end
if length(UD) == 0
   UD = 2;
   disp('Default transducer orientation: downward looking')
end
if length(WS) == 0
   WS = 200;
   disp('Default bin height: WS = 200cm');
end
if length(WN) == 0
   WN = size(BEAM,2);
   disp(['Default # of bins: WN = size(BEAM,2) = ' num2str(WN)]);
end
if length(WF) == 0
   WF = 176;
   disp('WF set to default value of 176');
end
if length(C) == 0        
   C = [1500 1500];
   disp('Speed of sound set to default value of 1500 m/s');
end
if length(OPTS) == 0
   OPTS = [1 2 0 0 5 3];
   disp('Default Options:')
   disp('  - Allow three-beam solution');
   disp('  - Linear cell mapping');
   disp('  - No minimum percent good');
   disp('  - Keep all data values');
   disp('  - Interpolate vertically only over less than 5 consecutive NaNs');
   disp('  - Heading correction');
end
if length(GOOD) == 0
   GOOD = 100;
   OPTS(3) = 0;
   disp('No percent good check performed');
end
if length(AZ) == 0
  if TY == 1
    AZ = [0];
    disp('Default Janus azimuthal angles [270 90 0 180]');
  else
    AZ = [4];
    disp('Default Cyclops azimuthal angles [0 180 300 60]');
  end             
end
if length(EL) == 0
  if TY == 1
    EL = [0];
    disp('Default Janus elevation angles [-70 -70 -70 -70]');
  else
    EL = [4];
    disp('Default Cyclops elevation angles [-90 -70 -70 -70]');
  end                                                                    
end
 
if WN > size(BEAM,2)
   error('Number of bins greater than number of columns in beam matrix')
end

SIZ = size(BEAM); % SIZ(1) number of ensembles, SIZ(2) number of bins, SIZ(3)=4 beams
if SIZ(3) ~= 4
	error('3rd dimension of BEAM must be 4 (the number of beams)')
end

% ----- defaults --------------------------------------------------------------
if EL == 0 | EL == 5,
	EL = -[70 70 70 70];			% nominal Janus
elseif EL == 1
	EL = -[69.77 69.48 69.65 70.08];	% Garrett UVic Janus
elseif EL == 2
   EL = -[69.96 69.92 70.26 70.29];		% Farmer IOS Janus
elseif EL == 3
   EL = -[70.00 70.00 70.00 70.00];		% MacCready UW Janus
elseif EL == 4
   EL = -[90 70 70 70]; 			% Vertical Beam UVic (nominal) Cyclops
end
if AZ == 0 | AZ == 5,
	AZ = [270 90 0 180];			% nominal Janus
elseif AZ == 1
   AZ = [271.44 91.43 358.57 178.56];		% Garrett UVic Janus
elseif AZ == 2
   AZ = [270.20 90.19 359.81 179.81];		% Farmer IOS Janus
elseif AZ == 3
   AZ = [270.00 90.00 0.01 180.00];		% MacCready UW Janus
elseif AZ == 4
   AZ = [0 180 300 60];				% Vertical Beam UVic (nominal) Cyclops
end

% ----- replace bad data (low percent good) with NaNs ------------------------
if OPTS(3) ~= 0						% check for bad data
	tmp = size(GOOD);
	if max(tmp) == 1				% constant % GOOD
		GOOD = GOOD * ones(SIZ);
	elseif any( tmp ~= SIZ )			% same size matrix
		error('GOOD must be of same dimension as BEAM')
	end
	BEAM( find(GOOD < OPTS(3)) ) = NaN;		% replace
end

% ----- replace all data above OPTS(4) consecutive NaNs with NaNs ------------
if OPTS(4) ~= 0				% a real limit on consecutive NaN
   for j = 1:SIZ(1)					% each time step
	   for i = 1:4					% each beam
		   ind = find( ~isnan(BEAM(j,:,i) ));	% index of valid data
		   if ~isempty(ind)
		      if ind(1) > OPTS(4)		% NaN string at bin 1
			      BEAM(j,:,i) = NaN;		% set all values = NaN
			   elseif length(ind) > 1
			      tmp2 = diff(ind);		% separation of NaNs
			      tmp = min( find(tmp2 > OPTS(4)) );
			      BEAM(j,ind(tmp)+1:SIZ(2),i) = NaN;
	    		elseif OPTS(4) == 1			% single NaN
			      BEAM(j,ind+1:SIZ(2),i) = NaN;
	    		end 
         end
      end
   end
end
% ----- (interior) linear vertical interpolation of beam velocities-----------
if OPTS(5) ~= 0				% 0 implies no interpolation allowed
   bins = [1:SIZ(2)];
   for j = 1:SIZ(1)			% each time step
	   for i = 1:4				% each beam
	      ind  = find( ~isnan(BEAM(j,:,i)) );
	      ind2 = find(  isnan(BEAM(j,:,i)) );
	      if (length(ind) > 1) & (~isempty(ind2))
            BEAM(j,ind2,i) = interp1(ind,BEAM(j,ind,i),ind2,'linear');
            tmp = diff(ind);
            for k = 1:length(tmp)
               if tmp(k) > OPTS(5) + 1
                  BEAM(j,ind(k)+1:ind(k+1)-1,i) = NaN;
               end
            end
         end
      end
   end
end
% ----- do corrections and set parameters ------------------------------------
f   = pi / 180;	% convert degrees to radians
H   = f * HH;   % heading in radians
P   = f * PP;   % pitch in radians
R   = f * RR;   % roll in radians
el  = f * EL;
az  = f * AZ;
[i,j] = size(C);
if i == 1
    C = ones(length(H),1) * C;
end
% pitch correction
if OPTS(6) == 1
    P = asin( sin(P).*cos(R) ./ sqrt(1 - (sin(P).*sin(R)).^2) ); % pitch and roll fixed
elseif OPTS(6) == 3
    H = H + asin(sin(P).*sin(R) ./ sqrt((cos(P)).^2 + (sin(P).*sin(R)).^2 )); % pitch fixed, roll gimballed
end

% ----- calculate Beam Directional Matrix from passed azimuth and elevation --
BeamCalc = [ -cos(el(1))*sin(az(1)) -cos(el(1))*cos(az(1))  -sin(el(1))   0 ;
             -cos(el(2))*sin(az(2)) -cos(el(2))*cos(az(2))  -sin(el(2))   0 ;
             -cos(el(3))*sin(az(3)) -cos(el(3))*cos(az(3))  -sin(el(3))   0 ;
             -cos(el(4))*sin(az(4)) -cos(el(4))*cos(az(4))  -sin(el(4))   0];                             
	BeamCalc(:,4) = orthog(BeamCalc(:,1:3),[1 2])'; % make the error term mathematically orthogonal to xyz
	MATRIX = inv(BeamCalc);

earth = NaN * ones(SIZ);				% can't calculate some
for j = 1:SIZ(1), % for each ensemble
	H2 = H(j);
    P2 = P(j);
    if UD == 1, % then upward looking
      R2 = R(j) + pi; % use this roll if upward looking
    else
      R2 = R(j); % use this roll if downward looking
    end
	C1 = C(j,1);
	C2 = C(j,2);

   % ----- calculate rotation matrices ----------------------------------
   Mh = [cos(H2) sin(H2) 0;-sin(H2) cos(H2) 0;0 0 1];
   Mp = [1 0 0;0 cos(P2) -sin(P2);0 sin(P2) cos(P2)];
   Mr = [cos(R2) 0 sin(R2);0 1 0;-sin(R2) 0 cos(R2)];
% This is used to convert from instrument coordinates to Earth
   Mtot = Mh * Mp * Mr ;                                                                                            

	% ----- bin mapping --------------------------------------------------
	if OPTS(2) == 1						% RDI code
      if UD==1,
         ZSG = [+1 -1 +1 -1];      % ADCP up/convex
      else
         ZSG = [+1 -1 -1 +1];      % ADCP down/convex
      end
      SC  = sin(abs(el))*cos(P2)*cos(R2) + ...
            cos(el) .*  ZSG .* [-sin(R2) -sin(R2) sin(P2)*cos(R2) sin(P2)*cos(R2)];
      SC  = sin(abs(el)) ./ SC;
 	  JJ = round([1:SIZ(2)]' * SC * C2/C1);		% closest bin #
	elseif OPTS(2) == 2					% Ott interpolation
     if max(RR(j),PP(j)) < 20
 		for kk=1:4
 		  bintemp = Mr * Mp * [-cos(el(kk))*sin(az(kk));cos(el(kk))*cos(az(kk));-sin(el(kk))];
 		  fracHGHT(kk)=bintemp(3);
 		end
 		fracHGHT = fracHGHT ./ sin(abs(el)) * C1/C2;
        nomHGHT = WF/100 + WS/100/2 + WS/100*[0:WN-1]';
        if UD==1, 
          actHGHT = nomHGHT * (-fracHGHT);
        else
          actHGHT = nomHGHT * fracHGHT;
        end
		for i = 1:4
			BEAM(j,:,i) = interp1(actHGHT(:,i),BEAM(j,:,i),nomHGHT);
        end
	  else
		BEAM(j,:,:) = NaN;
	  end
	  JJ = [1:SIZ(2)]' * ones(1,4);
	else
	  JJ = [1:SIZ(2)]' * ones(1,4);
	end

	% ----- calculate earth-coordinate velocites -------------------------
	for k = 1:SIZ(2)				% each nominal bin
		calc = -1;			   	% assume too many NaNs
		J = JJ(k,:);				% bin indices
		flagg = (J > 0) & (J <= SIZ(2));	% bin indices valid ?

		if sum(flagg) == 4				% all valid
		    tempbeam = [BEAM(j,J(1),1) BEAM(j,J(2),2) BEAM(j,J(3),3) BEAM(j,J(4),4)]';
		    calc = 0;				   	% 1 check left
		elseif (sum(flagg) == 3) & (OPTS(1) == 1)
		    J( find(flagg==0) ) = 1;			% temporary bin
		    tempbeam = [BEAM(j,J(1),1) BEAM(j,J(2),2) BEAM(j,J(3),3) BEAM(j,J(4),4)]';
		    tempbeam( find(flagg==0) ) = NaN;
		    calc = 0;
		end
		if calc == 0
		    flagg2 = isnan(tempbeam);			% check for NaNs
          if sum(flagg2) == 0
             calc = 1;
          elseif (sum(flagg2) == 1) & (OPTS(1) == 1)	% only 1 NaN, 3 beam solution
             temp = tempbeam' .* MATRIX(4,:);
             tempbeam( find(flagg2==1) ) = -sum(temp(find(flagg2==0))) / MATRIX(4,find(flagg2==1));
			 calc = 1;
		  end
		  if calc == 1
		     temp =  MATRIX * tempbeam;
             temp(1:3) = Mtot * temp(1:3);
             earth(j,k,1:4) = temp * C1/C2;
		  end
		end
	end
end
% ----------------
function VECT = orthog(X,MAG)

% function VECT = orthog(X,MAG)
%      eg. VECT = orthog([2 0 0;0 1 0],[1 2])		returns [0 0 1.5]
%
% /matlab/tools/orthog.m
%
% calculates the vector orthogonal to:
%	the n-1 row    vectors of length n (for   n-1 by n   matrix X)
%		or
%	the n-1 column vectors of length n (for   n by n-1   matrix X)
%
% normalizes vector to have the same rms magnitude as:
%	a unit vector					for MAG = 0
%	the mean of magnitudes of the vectors in MAG	for MAG = [i ... j]
%		i and j must be > 0 and < n
%	default = 0
%
% Michael Ott
% 13 Jan 1997

if nargin < 2
	MAG = 0;				% default: unit length
end

[m,n] = size(X);				% format: vectors as rows
if m == n-1
	x2 = X;
elseif m == n+1
	x2 = X';
else
	error('Matrix is not   n by n-1   or   n-1 by n')
end
siz = max(m,n);

if MAG ~= 0					% invalid magnitude choice
	if max(MAG) > siz-1
		error('Vector index for magnitude too large')
	elseif min(MAG) < 1
		error('Vector index for magnitude too small')
	end
end

for i = 1:siz					% every dimension for VECT
	j2 = 0;
	for j1 = 1:siz
		if (j1 ~= i)			% omit VECT dimension from det
			j2 = j2 + 1;
			for k1 = 1:siz-1		% each existing vector
				mat(k1,j2) = x2(k1,j1);	% determinant matrix
			end
		end
	end
	VECT(i) = det(mat) * (-1)^(i+1);	% un-normalised VECT components
end

if all(VECT == 0)					% zero vector
	error('Vectors are not all linearly independent')
end

for i = 1:siz-1
	if sum( x2(i,:) .* VECT ) > 1e-8		% orthog. condition
		errror('Cannot find orthogonal vector')
	end
	rmsmag(i)  = sum( x2(i,:) .* x2(i,:) );	
end
rmsmag = sqrt( rmsmag );			% root mean square magnitude

VECT = VECT / sqrt( sum(VECT .* VECT) );	% normalise (unit length)

if MAG ~= 0
	VECT = VECT * mean(rmsmag(MAG));	% match the rms magnitude
end

% fini
