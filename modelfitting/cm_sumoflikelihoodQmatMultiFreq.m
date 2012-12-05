function [sumLikelihoods Thresh nlleach] = cm_sumoflikelihoodQmatMultiFreq(VisMtx, params)
% [sumLikelihoods Thresh nlleach] = cm_sumoflikelihoodQmatMultiFreq(VisMtx, params)
% 
%
% <Input>
%   VisMtx    ... VisibilityMatrix
%   params ... struct
%
% <Output>
%   sumLikelihoods ... sum of negative log likelihood
%   Thresh         ... thresholds at all frequencies 
%   nlleach        ... each negative log likelihood
%
% see also cm_sumoflikelihoodQmat_sub.m
%% prep 

NumFreq     = params.NumFreq;
StimDirEach = params.StimDirEach;

if isfield(params,'p')
    p = params.p;
else
    p = 2;
end

if isfield(params.nllt,'slope')
    slope = params.nllt.slope;
else
    slope = 2;
end

if ~isfield(params,'Aveflags')
    Aveflags = zeros(1,NumFreq);
else
    Aveflags = params.Aveflags;
end

%% main loop for each freqency data set
Thresh = []; nlleach = [];

for ii = 1:NumFreq
    
    % withdraw data from params   
    raw         = params.rawEach{ii};
    StimDir     = StimDirEach{ii};
    nD          = size(StimDir,2);
    V           = VisMtx(:,:,ii);
    
    % keep data freq index for grid fitting
    params.currentDataInd = ii;
    
    % Thresholds from the model matrix (Visivility matrix)
    Sensitivity = sum(abs(V * StimDir).^p, 1).^(1/p);    
    T = 1 ./ Sensitivity;
    
    
    % calc negative log-likelihood at each frequency
    [~, LogLikelihood] = cm_sumoflikelihoodQmat_sub(T, nD, raw, slope, Aveflags(ii), params);
    
    % Store thresholds and negative log-likelihood
    Thresh  = [Thresh T];
    nlleach = [nlleach LogLikelihood];
    
end

% sum of negative log-likelihood
sumLikelihoods = sum(nlleach);

end
