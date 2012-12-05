% s_PNAS_Discussion_ConeSelfScreening.m
%
% 'Human Trichromacy Revisited'
%  by Horiguchi, Winawer, Dougherty and Wandell.
%
%
% Photopigment density variations
% Estimates of photopigment optical density in the periphery differ (27,
% 28), but there is agreement that beyond 10 deg the optical density varies
% slowly and near the range of 0.25-0.30. Optical density differences
% change the spectral absorption of the photopigments; hence, such
% variation might provide an additional source of information.          
% Quantitative analyses suggest that this variation cannot be a significant
% factor. We calculated the cone-silent stimulus assuming an optical
% density of 0.25.  We then calculated the Poisson distributed
% isomerization rates assuming cones with a 0.30 density. Because of the
% change in optical density, the stimulus is no longer cone-silent.
% However, the difference caused by a 10% stimulus is less than 2 SD of the
% background isomerization rate. Thus, there would be little chance that
% the stimulus would be visible.  If the visual system does not segregate
% the cones by optical density, so that the responses cone population has
% some variance in the optical density and other sources of noise, there is
% even less chance that variations in optical density would enable a
% subject to detect the stimulus.             
% In conclusion, the photopigment density variation is inconsistent with
% the quantitative simulations. The penumbral cone explanation forces us to
% draw on two entirely different accounts to explain the patient and the
% healthy subjects.  Thus, we consider the melanopsin hypothesis to be the
% simplest explanation at present.  We acknowledge, of course, that further
% tests are desirable and we are eager to share our data and software with
% others who would like to test their ideas. 
%
%
% This script requires full set of vset 
% https://github.com/wandell/vset
%
%       
% HH (c) Vista lab Oct 2012. 
%
%%
% just for me
path2vsetfolder = '/biac4/wandell/biac3/wandell7/hhiro/matlab/svn/vset';

addpath(genpath(path2vsetfolder))
%%
s_initISET
setpref('ISET','waitbars',0)

%% Initialize params for different densities of pigments

% default wavelength
wls = cm_getDefaultWls;

% Get inert pigment densities
% HH to explain something about this
inertP = odParams('p',wls);   % Stockman peripheral

inertPpred  = inertP; inertPactual  = inertP;

% set LMS cone pigment density
inertPpred.LPOD  = 0.25;  inertPpred.MPOD  = 0.25;  inertPpred.SPOD   = 0.20;
inertPactual.LPOD = 0.30; inertPactual.MPOD = 0.30; inertPactual.SPOD = 0.25;

% LMS function as both units of photons and energy
[LMSquantaMed     LMSEnergyPred]   = ieReadHumanQE(inertPpred, true);
[LMSquantaActual  LMSEnergyActual] = ieReadHumanQE(inertPactual);

% set display
display     = displayCreate;
display     = displaySet(display,'wave',inertP.wave);

% mean background of the display
background  = vcReadSpectra('ledSPD_pr715.mat',inertP.wave);
display     = displaySet(display,'spd',background);

%% Background light
%  Compute LMS responses to background
%  Uses ISET to calculate the background scene, the optical image, the
%  human sensor, the LMS cone isomerizations for this background.

% numSampleSensors = 'max';  % Choose a number or use them all ('max')
numSampleSensors = 100;    % Choose a number or use them all ('max')
ExposureTime     = 0.050;  % seconds


% Calc LMS cone isomerizations to mean background
%
%   back     ... ISET scene structure for background  
%   oi       ... ISET optical image structure for background
%   sensor   ... ISET senror structure for background
%   d0       ... LMS cones isomerization per unit time (Exposuretime)
[backP oiP sensorP d0P] = cm_SetBackground(LMSquantaMed(:,1:3), background, wls, numSampleSensors, ExposureTime);
[backA oiA sensorA d0A] = cm_SetBackground(LMSquantaActual,     background, wls, numSampleSensors, ExposureTime);

%% Question.

% If photopigment optical densities are higher (0.3) than you predicted
% (0.25), how much acctural LMS cone isomerizations occur to cone-silent
% stimulus for the LMS function you predicted?   
% LED spectral power distributions for psychophysics

% make cone-isolated stimulus based on predicted LMS cone photopigment
% density (0.25, 0.25 and 0.2, respectively)
[IsoAmp1P MaxCont] = cm_getIsoStimDispPinv(display, LMSEnergyPred);

% Cone-silent direction 
ConeSilentDir  = [0 0 0 1]';

% 10 percent modulation 
StimAmp        = 10;

% 10% modulation of cone-silenet stimulus to predicted LMS functions 
testSPD   =  display.spd * IsoAmp1P * ConeSilentDir * StimAmp;
 
% calc LMS absorptions in actual (higher) LMS photopigment density
LMSabsorptionA = cm_SimulateConeResponse(backA, oiA, sensorA, testSPD, numSampleSensors, wls);

%% draw results
f = figure('Position',[0 0 1000 800]);

% Poisson noise 
nSD = 2;

% plot LMS absorptions and ellipsoid as Poisson noise
[~,h,tmp] = ieCovEllipsoid(d0A, nSD, f , 100); hold on

% mean LMS absorption to the stimuli
MeanLMSAbsActual = mean(LMSabsorptionA{1},1);

% for visualization
% 
% center (mean) of LMS absorption to background
centerP = mean(d0A,1);

% get direction from mean LMS absorption of background to cone-silent stimulus 
Line    = [centerP; MeanLMSAbsActual]; 
RespDir = unitlength(Line(2,:) - Line(1,:));

% find a point from LMS absorptions of background to those cone-silent
% stimulus across ellipse 
E      = cov(d0A);
len    = RespDir * (E \ RespDir');
PonSph = nSD*(RespDir/sqrt(len));
Line2  = [centerP; centerP+PonSph];

% draw line
h_line = plot3(Line2(:,1),Line2(:,2),Line2(:,3),'k');

% show the mean LMS absorption to cone-silent stimuli for predicted (lower)
% photopigment density
h_dhm = plot3(MeanLMSAbsActual(1),MeanLMSAbsActual(2),MeanLMSAbsActual(3),'rp');
set(h_dhm,'MarkerFace','r', 'MarkerSize',16)
set(gca,'FontSize',18)
axis equal
view([18 10]);

set(tmp.surf,'EdgeAlpha',0.05); alpha(0.3); lighting phong; material shiny; shading interp
cmap = autumn(255); colormap([cmap; .25 .25 .25]); camlight

% set(tmp.pts,'visible','off');
% set(gca,'visible','off')

% % output as a svg file
% filename = '/Users/hhiro/Desktop/test2';
% plot2svg(filename,h)

