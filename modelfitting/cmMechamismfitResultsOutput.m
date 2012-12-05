function [VisMtcies params] = cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag,nTrial,fixRandSeedflag)
% [VisMtcies params] = cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag,nTrial)
%
% This function fits the model with thresholds data in Four-dimensional
% space and gives Visual Matrix for drawing resluts. This code is basically
% same as s_cmMechanismfit.m
%
% There are two steps for the model fittig process in an m-file to
% calculate (cm_cmMechamismfitResultsOutput_Mainloop.m).
%
% In the first step, look-up tables of negative log-likelihood at each
% stimulus direction are prepared. The codes minimize sum of negative
% log-likelihood which is closest thresholds estimated by Visivility matrix
% based on the model from randam seeds many times (default - 1000 times).
%
% The minimum sum of negative log-likelihood from thousands of a trial in
% the first step are found, and used as seeds for  the second search
% fitting. In the second fitting procedure, there is no look-up table.
% The likelihoods at each stimulus direction are calculated for Visibility
% Matrix on every fitting reptions.
%
%
% <Input>
%   subinds         ... index of subject (scalar). [1, 2 or 3 (only periphery).]
%   numMech         ... number of mechanisms (scalar), which indicates number of raw in Visibility Matrix [2, 3 or 4]
%   fovflag         ... true indicates foveal data. false indicates peripheral data. (logical)
%   corflag         ... true indicates with axis-correction, which indicates pigment correction and fix caliblation error) (logical)
%   coneflag        ... true indicates the model fits data with only three types of cone pigments, which limited number of column in VisMtx as 3.
%   nTrial          ... First number indicates number of grid fitting (1st fitting) and 2nd is that of search fitting if exists. (scalar or 1x2 vector)
%   fixRandSeedflag ... true indicates fixed random seeds for 1st fitting to reproduce the results without a local minimum problem.
%
% <Output>
%   VisMtcies       ... Visual Matrix at each temporal freqency (Fovea - 4x4x2, Periphery - 4x4x3)
%   params          ... parameters for the analysis and (struct)
%
%
% Example:
%
% subinds  = 1; % subject 1
% numMech  = 3; % Three mechanisms, which indicates raw of Visibility Matrix is three.
% fovflag  = 1; % foveal data
% corflag  = 1; % corrected photopigment densities
% coneflag = 0; % allow 4th photopigment, not try to solve only with cones
%
% [VisMtcies params] = cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag);
% cm_mechanismfit_draw2D(VisMtcies, params,[0 0 0],1);
%
% see also s_PNAS_figure2.m,s_PNAS_figure3D.m,s_PNAS_figure4.m, etc...
%
% HH (c) Vista Lab, Oct 2012
%
%% prep
if ~exist('subinds','var')
    help cmMechamismfitResultsOutput
    VisMtcies = [];
    return
end

if ~exist('fixRandSeedflag','var') || isempty(fixRandSeedflag)
    fixRandSeedflag = true;
end

if ~exist('nTrial','var') || isempty(nTrial)
    nTrial = [1000 1];
end

if length(nTrial) <2,
    % run 2nd step usually just once
    nTrial(2) = 1;
end

%% prep dataset for calc

% get tags for picking up dataset
[methodTag tempFreqs dataset PODparams subtag] = cm_dataTagSwitcher(subinds, numMech, fovflag, corflag, coneflag);

% load data
params = cm_prepDataforMechanismfit(subtag, tempFreqs, dataset, PODparams, methodTag);

% give some limitations in 1st fitting based on biological knowledge from literatures 
params.limitmechanism   = true;
params.limitsensitivity = true;

%% fit model to the data

[VisMtcies params] = cmMechamismfitResultsOutput_Mainloop(params,nTrial,fixRandSeedflag);

end
