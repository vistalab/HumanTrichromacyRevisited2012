% s_Figure5D.m
%
% 'Human Trichromacy Revisited'
%  by Horiguchi, Winawer, Dougherty and Wandell.
%
% Figure caption:
% (D) Model error of the Trichromatic theory fit after pigment correction
% for foveal and peripheral experiments. The data are cross-validated:
% models were fit to a subset of data and predicted and measured thresholds
% were calculated for the left-out data. The ‘Model error index’ was
% calculated in each model by dividing the difference between the measured
% and predicted threshold by the predicted threshold. Medians of the ‘Model
% error index’ are binned by the projection of each color direction on to
% the cone-silent (Z) axis. Note that the ‘Model error index’ increases
% with the length of Z in the periphery (but not the fovea) in all
% subjects. This indicates that predicted thresholds to cone-silent stimuli
% are systematically higher than measured thresholds in the periphery, not
% the fovea.                 
%
%       
% HH (c) Vista lab Oct 2012. 
%
%% load bootstrapped resutls
figname   = 'fig5d'; 
bstparams = cm_ConditionPrepforBootstrapipngSGE(figname);

condname  = 'Noise05pNFromSearchGrid';
tmpInd    = 1;  

% load bootstrapped results, which takes a bit long time 
[zlength medianModelError] = cm_loadBst_TrichroErrorCal(bstparams, tmpInd, condname);

nConds = length(zlength);
%% plot
bin = [0 0.6 0.9 1];
f5D = figure('Position',[0 0 1000 300]);
cm_plotModelErrorAlongZlength(zlength, medianModelError, bin)
%% save
% cm_figureSavePNAS(f5D,'5D')

%%%%%%%%%%%%%%
%% raw data %%
%%%%%%%%%%%%%%
f5Dsupple = figure('Position',[0 0 1000 300]);
cm_plotModelErrorAlongZlength_Raw(zlength, medianModelError)

%%
