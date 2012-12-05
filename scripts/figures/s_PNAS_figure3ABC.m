% s_PNAS_figure3ABC.m
%
%
% 'Human Color Sensitivity: Trichromacy Revisited'
%  by Horiguchi, Winawer, Dougherty and Wandell.
%
%
% Figure Caption:
% Trichromatic theory can explain foveal measurements. A 3-mechanism model
% (Figure 2) must have an invisible direction in a 4 primary display.
% Panel (A) shows the spectral power distributions of the invisible stimuli
% at the fovea according to the model fits.  The spectral patterns are
% similar for two subjects (S1: black outline, S2: gray). The shaded areas
% show 80% confidence interval based on a bootstrap procedure: We fit the
% model 1,000 times, each fit omitting 10% of the data selected at random.
% (B) Responses to the foveal stimulus in the invisible direction at 10%
% modulations are shown in LMS space for S1 according to two models of LMS
% spectral sensitivity: the standard color observer (gray) and models fit
% to the individual to account for pigment density in the lens, macula, and
% cone outer segments (black outline; see Figure S2 for details). Assuming
% the standard color observer, the cloud of bootstrapped LMS responses is
% far from the origin, indicating that (according to this model) a 10%
% modulation of the invisible stimuli evokes about a 2% response in each of
% the L, M, and S cones. However, after correction for the individual cone
% pigment densities, the LMS responses to the invisible stimuli for S1 lie
% near the origin, indicating that the invisible light is also the
% cone-silent light, as predicted by Trichromatic theory. Histograms on the
% cone axes show the distribution of cone responses to the invisible
% stimuli according to the standard observer model (gray) or the individual
% observer (black outline). (C) Distribution of bootstrapped LMS responses
% to the invisible foveal stimuli in two subjects. Histograms show
% distances from the origin in 3D LMS space. In both S1 and S2, LMS
% responses are far from the origin when fit using the standard observer’s
% pigment densities (median of S1 and S2 LMS responses; 3.3 and 4.5%,
% respectively). After pigment density correction, the invisible stimuli
% are also the cone-silent stimuli.
%      
% HH (c) Vista lab Oct 2012. 
%
%% Figure 3A

% load bootstrapped results
figname    = '3abc';  % figure name for analysis
btsparams  = cm_ConditionPrepforBootstrapipngSGE(figname);
tempInd    = 1; % analyze pulse data

% Estimated invisible stimulus by Trichoromacy Model
% and LMS responses to the stimulus at 10 % modulation
[InvDirTrimodlfov LMSrespStimfov] = cm_InvDirTriBstRes(btsparams,tempInd);

%% draw
subInds  = [1 2]; % show S1 and S2
ConfInt  = 80;    % Confidenc interval - 80% 
fovflag  = btsparams.Fov; % foveal flag, which should be true

% plot invisible stimulus spectral power distribution
f3A      = cm_plotEstInvisibleSPD(InvDirTrimodlfov, subInds, ConfInt, fovflag);

%% save
% cm_figureSavePNAS(f3A,'3A')

%% Figure 3B

% do pigment correction
limitPigs = [0.01 0.5 0 1.2 0.5];
limitflag = true;
saveflag  = 1;             
foveaflag = btsparams.Fov; % it's fovea, should be true

% This fitting procedure takes really long time.
% The data will be save in a folder defined by a m-function,
% cm_defaultPathforSaveSGEresults.m
[pod,mds,lfs,lmsR] = ...
    cm_pigmentCorrection(InvDirTrimodlfov, foveaflag, limitflag, limitPigs, saveflag);

% LMS responses to 1 percent stimulus, so need to multiply by stimulus amp

stimAmp = 10; % stimulus amplitude is 10 percent modulation 

for ii=1:length(lmsR); LMSrespAfter{ii} = lmsR{ii} * stimAmp; end

%% Figure 3B 
subind  = 1;
f3B = figure('Position',[0 0 800 800]);

EdgeColor  = [.7 .7 .7; .1 .1 .1];
MarkerFace = [.7 .7 .7;  1  1  1];

% before pigment correction
drawAxis = false;
cm_plotLMSabsorption(LMSrespStimfov{subind},EdgeColor(1,:), MarkerFace(1,:), drawAxis);

% after pigment correction
drawAxis   = true;
cm_plotLMSabsorption(LMSrespAfter{subind},EdgeColor(2,:), MarkerFace(2,:),   drawAxis); 
legend({'Standard Color Observer','Corrected pigment'},'Location','Best')

%% save
cm_figureSavePNAS(f3B,'3B')

%% figure 3B XYZ histgrams
f3bInlet = figure('Position',[0 0 1300 200]);
cm_histXYZ(LMSrespStimfov, LMSrespAfter,subind)
%% save
cm_figureSavePNAS(f3bInlet,'3Binlet')
%% Figure 3C
f3C = figure('Position',[0 0 900 300]);

% hist before
FaceB = ones(1,3) * 0.8; EdgeB = 'none'; 
cm_histLMSrespFromOrigin(LMSrespStimfov, FaceB, EdgeB);

% hist after
FaceA = 'none';  EdgeA = ones(1,3) * 0.2;
cm_histLMSrespFromOrigin(LMSrespAfter, FaceA, EdgeA)

legend({'Standard Color Observer','Corrected pigment'},'Location','NorthEast')

%% save
cm_figureSavePNAS(f3C,'3C')
