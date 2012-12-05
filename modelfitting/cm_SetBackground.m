function [back oi sensor d0] = cm_SetBackground(cFilters, bgSpd, wls, numSampleSensors, ExposureTime, irfilter)
% [back oi sensor d0] = ctmSetBackground(cFilters, bgSpd, wls, numSampleSensors, ExposureTime)
%
% Prepare scene, optical image and sensors as background you define with
% background spectral power distributions for simulating photon absortions
% in psychophysics
%
% % Input
%   cFilters ... color filters for sensor (w x n matrix)
%   bgSpd    ... background spectral power distributions (w x m matrix) 
%   wls      ... wavelength (1 x w vector)
%   numSampleSensors
%            ... number of sensors for sampling
%   ExposureTime
%            ... exposure time for sensors
%
%
% % Output
%   back     ... ISET scene structure for background  
%   oi       ... ISET optical image structure for background
%   sensor   ... ISET senror structure for background
%   d0       ... LMS cones isomerization per unit time (Exposuretime)
%
%
% See also: s_ctmSimulateDetectionPsych.m
%
% C) VistaLab 2012 HH 
%
%%

if ~exist('numSampleSensors','var') || isempty(numSampleSensors)
   numSample = 100; 
end

if ~exist('ExposureTime','var') || isempty(ExposureTime)
   ExposureTime = 0.010; % seconds 
end

volswing = 1000;

%% get mean background luminance
XYZ = ieXYZFromEnergy(ones(1,6) * bgSpd', wls);
meanbackluminance = XYZ(2); % 2060.8 Cd/m^2

%% Create a uniform scene at high photopic level
back = sceneCreate('uniform d65');
back = sceneInterpolateW(back,wls);

% multiply your primaries by illEnergy
illEnergy = bgSpd * ones(6,1);
% apply illuminant energy to scene
back = sceneAdjustIlluminant(back,illEnergy);
back = sceneAdjustLuminance(back,meanbackluminance);  
back = sceneSet(back,'fov',20);          % 20 deg FOV
back = sceneSet(back,'name','background');

%% We may have to adjust and put in lens pigment here?
oi = oiCreate('human');
oi = oiCompute(oi,back);

%% We will adjust the optical density of the cone photopigments here
% Adjust lens pigment and macular pigmenthere
noiseFlag    = 1;

params.sz = [128,128];
params.rgbDensities = [0.3 .5 .2 .1]; % Empty, L,M,S
params.coneAperture = [3 3]*1e-6;     % In meters
params.wave = oiGet(oi,'wave');
pixel = [];
sensor = sensorCreate('human',pixel,params);

%% add your LMS function and filters to the sensor ir filter.
sensor = sensorSet(sensor,'filter spectra', [zeros(size(cFilters,1),1), cFilters(:,1:3)]);
pixel  = sensorGet(sensor,'pixel');
pixel  = pixelSet(pixel,'voltage swing',volswing);
sensor = sensorSet(sensor,'pixel',pixel);
sensor = sensorSet(sensor,'exp time',ExposureTime);
sensor = sensorSet(sensor,'name','back');
sensor = sensorSet(sensor,'noise flag',noiseFlag);

if exist('irfilter','var')
    sensor = sensorSet(sensor,'irfilter', irfilter);
end

sensor = sensorCompute(sensor,oi);

vcAddAndSelectObject(sensor); 
%sensorWindow('scale',1);

slot = [2 3 4];   % L,M,S positions in the sensor
L0 = sensorGet(sensor,'electrons',slot(1));
M0 = sensorGet(sensor,'electrons',slot(2));
S0 = sensorGet(sensor,'electrons',slot(3));
% n = min(100,length(S0));

if ischar(numSampleSensors)
    if strcmp(numSampleSensors,'max')
        numSampleSensors = min([length(L0) length(M0) length(S0)]);
    end
end

S0 = S0(1:numSampleSensors); M0 = M0(1:numSampleSensors); L0 = L0(1:numSampleSensors);
d0 = [L0(:),M0(:),S0(:)];


