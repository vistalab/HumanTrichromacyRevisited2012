function stimRYGCBM = conesrm2RYGCBM(display, stimLMSRm, backRYGCBM, sensors, backgroundSPD)
%
%   stimRYGCBM = conesrm2RYGCBM(display,stimLMSRm,backRYGCBM,sensors)
%
% This m-file is just modified version of 'cone2RGB.m' to expand
% color dimention and number of primaries. 
% 
%PURPOSE:
%
%   Calculate the RGB values (stimRYGCBM.dir, stimRYGCBM.scale) needed
%   to create a  stimulus defined by stimLMSRm.dir, stimLMSRm.scale
%   and the backRYGCBM.dir backRYGCBM.scale values. 
%   
%   This code works for a single stimLMSRm.dir vector, but
%   stimLMSRm.scale may be a vector.
%   
%   The returned values in stimRYGCBM.scale are the RGB scale factors
%   needed to obtain the specified LMS scale.  The cone contrast
%   is calculated with respect to the background, as in
%   
%     (lmsStimPlusBack - lmsrmBack) ./ lmsrmBack
%     
%   
% ARGUMENTS
%
%  display:  .spectra contains the monitor spectral, is needed
%  stimLMSRm:  .dir    is the color direction of the contrast stimulus
%            .scale  is the scale factor
%            When the stimLMSRm.dir is cone isolating, the
%            scale factor is the same as contrast.  The
%            definition of a single contrast value is problematic for other
%            directions. 
%  backRYGCBM:  (optional) .dir and  .scale define the mean RGB of background,
%            so that backRYGCBM.dir*backRYGCBM.scale is a vector of
%            linear rgb values.
%  sensors:  (optional) A 361x3 matrix of sensor wavelength sensitivities.
%            Default:  Stockman sensors.
%
% RETURNS
%            
% stimLMSRm:   .maxScale   the largest permissible scale (re gamut
%            and background).
% stimRYGCBM:  .dir    color direction of the rgb vector
%           .scale  vector of scale values.
%            
% SEE ALSO:
%    cone2RGB.m, findMaxConeRodMelanopsinScale
%
% ISSUES:
%    It is a bit odd that we send in backRYGCBM and stimLMSRm.  We did
%   this because when we design the stimuli, we usually pick a
%   background level near the middle of RGB, say [.5 .5 .5],
%   without worrying much about it.  If we had sent in backLMS,
%   it would usually be less convenient.
%   
% 98.11.04 rfd: made stockman persistent so that it needn't be
% 				loaded from disk each time this is called.		
% 98.11.17 rfd & wap: modified findMaxConeScale to 
%				properly scale the requested stimLMSRm so that
%				the resulting stimuli will have the requested LMS.
%				(See findMaxConeScale for details.)
% 2010.04.02 RFD: allow an rgb2lms matrix in place of diaplay & sensors
%
% 2011.03 HH:  modified findMaxConeScale to expand color and primary dimention
%
% 
% C) Vista Lab, HH 2012 
%
%%  Set up input defaults

if ~exist('backRYGCBM','var')
  backRYGCBM.dir = [1 1 1 1 1 1]';
  backRYGCBM.scale = 0.5;
end

rygcbm2lmsrm = sensors' * display.spectra;

[stimLMSRm stimRYGCBM] = findMaxConeRodMelanopsinScale(rygcbm2lmsrm,stimLMSRm,backRYGCBM,sensors,backgroundSPD);

for ii=1:length(stimLMSRm.scale)
	if (stimLMSRm.scale(ii) > stimLMSRm.maxScale)
		if (stimLMSRm.scale(ii)-stimLMSRm.maxScale < 0.001)
			stimLMSRm.scale(ii) = stimLMSRm.maxScale;
		else
	      	error('Requested contrast ( %.3f) exceeds maximum (%.3f)\n', stimLMSRm.scale(ii),stimLMSRm.maxScale);
		end  
    end
    
    % When stimRYGCBM.scale equals stimRYGCBM.maxScale, 
    % 
    %      stimLMSRm.scale = stimLMSRm.maxScale
    % 
    % Everything is linear, so to obtain 
    % 
    %    stimLMSRm.scale = stimLMSRm.maxScale * (stimRYGCBM.scale/stimRYGCBM.maxScale)
    % 
    % To solve for the stimRYGCBM.scale that yields a stimLMSRm.scale, we invert
    
    stimRYGCBM.scale(ii) = (stimLMSRm.scale(ii) / stimLMSRm.maxScale) * stimRYGCBM.maxScale;
    
end

return

% Debugging
% Compute the stimulus contrast for the various conditions, as
% a check.

lmsrmBack = rygcbm2lmsrm*(backRYGCBM.dir*backRYGCBM.scale);
for ii=1:length(stimRYGCBM.scale)
  lmsrmStimPlusBack = rygcbm2lmsrm*(stimRYGCBM.scale(ii)*stimRYGCBM.dir) + lmsrmBack;
  (lmsrmStimPlusBack - lmsrmBack) ./ lmsrmBack
end

