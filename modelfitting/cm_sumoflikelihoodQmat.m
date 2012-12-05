function [sumLikelihood Thresh nllt] = cm_sumoflikelihoodQmat(VisMtx, params)
% [sumLikelihood Thresh nllt] = cm_sumoflikelihoodQmat(VisMtx, params)
% 
% This function prepare data to calculate sum of negative log likelihood
% across the thresholds predicted by model. Main function is
% cm_sumoflikelihoodQmat_sub.m.
%
% <Input>
% VisMtx ... Visibility matrix predicted by model
% params ... struct
%
% <Output>
% sumLikelihood ... sum of negative log-likelihood
% Thresh        ... threshold
% nllt          ... lookup table of negative log-likelihood
%
%%
nDim = size(VisMtx);

if length(nDim) == 2
    
    %% set
    if isfield(params,'p')
        p = params.p;
    else
        p = 2;
    end
    
    if isfield(params,'slope')
        slope = params.slope;
    else
        slope = 2;
    end
    
    if isfield(params,'aveflag')
        aveflag = params.aveflag;
    else
        aveflag = false;
    end
    
    %% prep
    
    StimDir = params.StimDir;
    Likelihooddata = params.Likelihooddata;
    nD = size(StimDir,2);
    
    %% predicts points along stimulus direction
    
    % predicted 4 dimentional points for Sensitivity of the direction with the Q matrix
    Sensitivity = sum(abs(VisMtx * StimDir).^p, 1).^(1/p);
    
    Thresh = 1 ./ Sensitivity;
    
    [sumLikelihood nllt] = cm_sumoflikelihoodQmat_sub(Thresh, nD, Likelihooddata, slope, aveflag);
    
elseif length(nDim) == 3
    
    [sumLikelihood nllt] = cm_sumoflikelihoodQmatMultiFreq(VisMtx, params);
    
end
