function [stimLMSRm, stimRYGCBM] = findMaxConeRodMelanopsinScale(display,stimLMSRm,backRYGCBM,sensors,backgroundSPD)
%
%  [stimLMSRm,stimRGB] = findMaxConeRodMelanopsinScale(display,stimLMSRm,backRYGCBM,sensors)
%
% This m-file is just modified version of 'findMaxConeScale.m' to expand
% color dimention and number of primaries. 
%
% see also findMaxConeScale.m
% 
% PURPOSE:
%
%   Calculate the maximum scale factor for the stimLMSRm given the
%   background and display properties. 
%   
%   When stimLMSRm.dir is in a cone isolating direction, the maximum
%   scale factor is also to the max cone contrast available for that cone
%   class. 
%   
%   When stimLMSRm is not in a cone isolating direction, you are on
%   your own.  That's why we call it scale.
%  
% ARGUMENTS
%
%  display:  .spectra is  a 341x n display primaries
%             
%  stimLMSRm:  The field
%             .dir     defines the color direction. By convention,
%                X.dir is a n-vector with a maximum value of 1.0
%             .scale   a vector of scale factors
%             
%  backRGB:  .dir    defines the color direciton. By convention,
%                X.dir is a n-vector with a maximum value of 1.0
%             .scale  a single scale factor
%			  (optional, [0.5 (1 x n)] default)
%  sensors:  341 x m matrix of sensor wavelength sensitivities
%             (optional, Stockman are default).
%
% RETURNS
%            
% stimLMSRm:  
%           .maxScale is the highest scale factor.  This is the
%           .maximum contrast when stimLMSRm.dir is cone isolating.
%             
% stimRGB: 
%          .dir is set to rgb direction corresponding to this
%           lms direction. 
%
% 10.29.98:	Swapped order of parameters.
% 11.17.98: RFD & WAP: added scaling for lmsBack.
%	NOTE: as of now, the RGB values returned are scaled by the
%	background LMS so that they accurately reflect the requested
%	LMS values in stimLMSRm.  (i.e., now you will get your requested
%	LMS contrasts no matter what the background color direction.)
% 
% 2010.04.02 RFD: allow an rgb2lms matrix in place of diaplay & sensors
% 
% 2011.03 HH: modified findMaxConeScale to expand color and primary dimention
%
% 
% C) Vista Lab, HH 2012 

%% Set up input defaults

numSensor = size(stimLMSRm.dir,1);

try
    numDisSpec = size(display.spectra, 2);
catch
    numDisSpec = size(display, 2);
end

if ~exist('backRYGCBM','var')    
  backRYGCBM.dir = ones(size(display.spectra,2),1);
  backRYGCBM.scale = 0.5;
end

if(~isstruct(display) && numel(display) == numDisSpec * numSensor)
    % then display is a 3x3 rgb2lms matrix.
    rygcbm2lmsrm = display;
else
    rygcbm2lmsrm = sensors'*display.spectra;
end

additionalbackLMSRm = sensors'* backgroundSPD;
lmsrm2rygcbm = pinv(rygcbm2lmsrm);

% Check whether the background RYGCBM values are within the unit cube
%
meanRYGCBM = backRYGCBM.dir(:) * backRYGCBM.scale;
err = checkRange(meanRYGCBM,zeros(numDisSpec,1),ones(numDisSpec,1));
if err ~= 0
  error('meanRYGCBM out of range')
end

%  Determine the background LMSRm direction 
%  
lmsrmBack    = rygcbm2lmsrm*(backRYGCBM.dir*backRYGCBM.scale);
addlmsrmBack = lmsrmBack + additionalbackLMSRm;
%  Scale stimulus LMS by the background LMS
%
scaledstimLMSRm = stimLMSRm.dir(:) .* addlmsrmBack;

%  Determine the stimulus RGB direction 
%  
stimRYGCBM.dir = lmsrm2rygcbm * scaledstimLMSRm;
stimRYGCBM.dir = stimRYGCBM.dir/max(abs(stimRYGCBM.dir));

% We want to find the largest scale factor such that the
% background plus stimulus fall on the edges of the unit cube.
% We begin with the zero sides of the unit cube, 
% 
%      zsFactor*(stimRYGCBM.dir) + meanRYGCBM = 0
% 
% Solving this equation for zsFactor, we obtain
%
sFactor = -(meanRYGCBM) ./ stimRYGCBM.dir;

%  The smallest scale factor that bumps into this side is
% 
zsFactor = min(abs(sFactor));

% Now find the sFactor that limits us on the 1 side of the unit RGB cube.
% 
%       usFactor*stimRGB.dir + meanRGB = 1
%   
sFactor = (ones(numDisSpec,1) - meanRYGCBM) ./ stimRYGCBM.dir;
usFactor = min(abs(sFactor));

%  Return the smaller of these two factors
%  
stimRYGCBM.maxScale = min(zsFactor,usFactor);

% Next, convert these values into LMS contrast terms.
% 
% General discussion:
% 
%  For each scale factor applied to the stimulus, there is a
%  corresponding contrast.  But, this must be computed using both
%  the stimLMSRm and the backLMS.  So, contrast and stimLMSRm.scale
%  are not uniquely linked, but they depend on the background.
% 
%  When stimRGB.scale is less than stimRGB.maxScale, we are sure that we
%  are within the unit cube on this background.  What is the
%  highest scale level we can obtain for the various cone classes
%  at this edge? 
% 

% Compute the LMS coordinates of the [stimulus plus background] and
% the background alone.  Use these to compute the max scale
% factor we can use in the LMS direction.  This is the maximum
% contrast when we are in a cone isolating direction.
%  
lmsStimPlusBack = ...
    rygcbm2lmsrm*(stimRYGCBM.maxScale*stimRYGCBM.dir + backRYGCBM.dir*backRYGCBM.scale)...
     + additionalbackLMSRm;
stimLMSRm.maxScale = max(abs((lmsStimPlusBack  - addlmsrmBack) ./ addlmsrmBack));

backRYGCBM.dir = lmsrmBack;
backRYGCBM.scale = 1;

end