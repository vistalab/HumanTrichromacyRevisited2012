function [VisMtcies, runparams] = cmMechamismfitResultsOutput_Mainloop(params, nTrial, fixRandSeedflag)
%  [VisMtcies params] = cm_cmMechamismfitResultsOutput_Mainloop(params,nTrial,fixRandSeedflag)
%
% This is subfunction of cmMechamismfitResultsOutput.m
%
% There are two steps for the model fittig process.
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
%  HH (c) Vista Lab, Oct2012
%
%%
if ~exist('fixRandSeedflag','var') || isempty(fixRandSeedflag)
    fixRandSeedflag = true;
end

if ~exist('nTrial','var') || isempty(nTrial)
    nTrial = [1000 1];
end

nFirstTrial = nTrial(1);

if length(nTrial) > 1, nSecondTrial = nTrial(2);
else                   nSecondTrial = 1;
end

runparams = params;

for ii = 1:nSecondTrial;
    %% 1st Step: with lookup table from random start
    
    % set params for 1st fitting
    
    % if seeds exist 
    if isfield(params,'seeds')
        
        tmp   = params.seeds;
        % add 0.1 noise as 1SD
        noise = 0.1;
        runparams.seeds = tmp .* noise .* randn(size(tmp)) + tmp;
        
    % seeds don't exist 
    else
        runparams.seeds = []; % random seeds will be used
    end
    
    runparams.gridfitflag = true; % grid fitting (using lookup table) for faster procedure
    runparams.nTrial = nFirstTrial;        % different seeds for 1st step
    runparams.calcDistMethod = 'fmcolike'; % limitation for 1st step
    runparams.fixRandSeedflag  = fixRandSeedflag;
    
    % fitting
    [gVectors, gSumL] = cm_mechanismfit_main(runparams);
    
    % get the best fitting in tons of trial based on minimum value of sum of negative log-likelihood
    MinInd = find(min(gSumL) == gSumL);
    seeds = gVectors(MinInd(1),:);
    
    % put data in params
    runparams.gVectors = gVectors;
    runparams.gSumL    = gSumL;
%     end
    
    %% 2nd step: search fitting
    
    % set params
    runparams.nTrial = 1;
    runparams.calcDistMethod = 'fminlike'; % no limitation
    runparams.seeds = seeds; % use seeds from 1st step
    runparams.gridfitflag = false; % calculate likelihood in each fitting process instead of using lookup table
    
    % fitting
    [sVectors(ii,:), sSumL(ii)]= cm_mechanismfit_main(runparams);
    fprintf('fitting done %d/%d\n',ii,nSecondTrial)
    
    % put data in params
    runparams.sVectors = sVectors;
    runparams.sSumL    = sSumL;
end

% get the best fitting based on minimum value of sum of negative log-likelihood
MinInd = find(min(sSumL) == sSumL);
sVector = sVectors(MinInd(1),:);

% Results - Visibility Matrix
[~, VisMtcies] = cm_estPredMulti(sVector, runparams);

