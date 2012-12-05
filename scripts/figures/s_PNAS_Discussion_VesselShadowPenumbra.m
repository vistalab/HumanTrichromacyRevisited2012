% s_PNAS_Discussion_VesselShadowPenumbra.m
%
% 'Human Trichromacy Revisited'
%  by Horiguchi, Winawer, Dougherty and Wandell.
%
% Discussion: Shadow of the retinal blood vessels.
% The cones in the deep shadow of the blood vessels do not signal to
% cortex(46, 47). The rate of cone photopigment isomerizations in the
% penumbra of the blood vessels could play a role at detection threshold;
% our simulations show that there is enough information in the penumbral
% isomerization rates to detect the cone-silent signal. However, for this
% information to be useful, the nervous system must develop neurons that
% segregate the signals of penumbral cones from others. Further,
% preliminary measurements suggest that contrast sensitivity in these
% penumbral zones is low (48).  This issue merits further investigation.
%
% This script requires full set of vset 
% https://github.com/wandell/vset
%
%       
% HH (c) Vista lab Oct 2012. 
addpath(genpath('vset'))

%%
s_initISET
setpref('ISET','waitbars',0)
%% Initialize params for pigments
% default wavelength
wls = cm_getDefaultWls;

% Standard color observer LMS function (Stockman 1999, 2000) 
inertP = odParams('peri',wls);  

% individual LMS function (Quantal unit)
[LMSfunQuanta, LMSIfunEnergy] = ieReadHumanQE(inertP);

% LED spectral power distributions used in the psychophysics
display = displayCreate;
display = displaySet(display,'wave',inertP.wave);
ledspd = vcReadSpectra('ledSPD_pr715.mat',inertP.wave);

%% estimate transmittance of blood vessel
skin    = vcReadSpectra('SkinComponentAbsorbances',wls);
oxy     = skin(:,1);
deoxy   = skin(:,2);

w1 = (0.3:1:100)*1e-3;
w2 = (0.3:1:100)*1e-3;
transmittance = zeros(length(wls),length(w1));

% calc transmittance of blood in several combination of oxy-deoxy
% hemogrobin
for ii = 1:length(w1)
    transmittance(:,ii) = 10.^(-(w1(ii)*oxy + w2(ii)*deoxy));
end

% draw the appearance of variace density of blood
pSize = 30;
grayFlag = 0;
bloodScene = sceneReflectanceChart(transmittance,[],pSize,wls,grayFlag);
vcAddAndSelectObject(bloodScene); sceneWindow;
xyz = sceneGet(bloodScene,'xyz');
srgb = xyz2srgb(xyz);
vcNewGraphWin; imagesc(srgb)

irfilter = transmittance(:,6); % pick up any number you want

% one of blood transmittance function
% vcNewGraphWin; plot(wls, irfilter);
%% Background light under retinal blood vessel

numSampleSensors = 100;   % Choose a number or use them all ('max')
ExposureTime     = 0.05;  % seconds

% LMS cone absorption with blood transmittance to background SPD
[back oi sensor d0m] = cm_SetBackground(LMSfunQuanta, ledspd, wls, numSampleSensors, ExposureTime, irfilter);

% LMS cone absorption in No blood vessel to background SPD
[backN oiN sensorN d0N] = cm_SetBackground(LMSfunQuanta, ledspd, wls, numSampleSensors, ExposureTime);

%% Test light

% 10% cone-silent stimulus for standard observer
StimDir = [0 0 0 1]'; stimamp = 10;

% load spectral power distribution of pigment-isolated stimuli
tmp = load('psychdataforPNAS');
isolateSPD = tmp.PERIstimSPD; clear tmp

% spectral power distribution of cone-silent stimulus 
testSPD    = isolateSPD * StimDir .* (ones(size(wls,2),1) * stimamp);

% vcNewGraphWin; plot(wls,testSPD)

%% compute LMS responses to test light

% LMS cone absorption with blood transmittance to cone-silent stimulus 
LMSisomerization  = cm_SimulateConeResponse(back,  oi,  sensor,  testSPD, numSampleSensors, wls);

% % LMS cone absorption in No blood vessel to cone-silent stimulus 
LMSisomerizationN = cm_SimulateConeResponse(backN, oiN, sensorN, testSPD, numSampleSensors, wls);

%% draw results
% show averaged results
figure('Position',[0 0 800 800]);

% LMS isomerizations to the background not in shadow
h_d0n = plot3(d0N(:,1),d0N(:,2),d0N(:,3),'b.'); hold on;  grid on

% LMS isomerizations to the background in shadow
h_d0m = plot3(d0m(:,1),d0m(:,2),d0m(:,3),'r.');

%  LMS isomerizations to the cone-isolated stimulus in shadow
dm = LMSisomerization{1};
h_dm = plot3(dm(:,1),dm(:,2),dm(:,3),'g.');

% make the figure fancier 
MS = 12;
set(h_d0n,'MarkerSize',MS); set(h_d0m,'MarkerSize',MS); set(h_dm, 'MarkerSize',MS);

set(gca,'Xscale','log','Yscale','log','Zscale','log','FontSize',16)
xlabel('L-cone'); ylabel('M-cone'); zlabel('S-cone isomerization');
axis equal; xlim([10^4 10^5.1])
names = {'Out of shadow to BG','In shadow to BG','In shadow to Stim'};
legend(names,'Location','best')

% note that a distance between LMS isomerization cluster to background
% (red) ans cone-isolated stimulus(green) in shadow of the blood vessel is
% larger that Poisson distribution. 
