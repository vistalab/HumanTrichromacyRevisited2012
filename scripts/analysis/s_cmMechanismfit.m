% s_cmMechamismfit.m
%
%
clear all
%% set condition
subinds  = 1;
numMech  = 3;
fovflag  = 1;
corflag  = 0;
coneflag = 0;

%% get data tag
[methodTag tempFreqs dataset PODparams subtag] = cm_dataTagSwitcher(subinds, numMech, fovflag, corflag, coneflag);

%%  prep dataset for calc
params = cm_prepDataforMechanismfit(subtag, tempFreqs, dataset, PODparams, methodTag);

%% 1st fitting procedure from random seeds
params.seeds = [];
params.gridfitflag = true; % grid fitting (using lookup table) for faster procedure
params.nTrial = 1000;
params.calcDistMethod = 'fmcolike'; % with limitation

% give some limitations for variables
params.limitsensitivity = true;
params.limitmechanism   = true;

% fitting
[gVectors SumL] = cm_mechanismfit_main(params);

% get the best fitting in tons of trial based on minimum value of sum of negative log-likelihood
MinInd = find(min(SumL) == SumL);
seeds = gVectors(MinInd(1),:);

%% 2nd search fitting
% This part has been done
params.nTrial = 1;
params.calcDistMethod = 'fminlike'; % no limitation
params.seeds = seeds; % use seeds from grid fitting
params.gridfitflag = false; % calculate likelihood in each fitting process

% fitting
[sVectors sSumL]= cm_mechanismfit_main(params);
% visivility matrix
[~, VisMtcies] = cm_estPredMulti(sVectors, params);

%% draw results
% This part has been done
f = figure('Position',[0 0 1000 630]);
cm_mechanismfit_draw2D(VisMtcies,params,[1 0 0],1)
figname = sprintf('%s_%s_%d',subtag, methodTag, corflag);
set(f,'Name',figname)

