function [zlength medianModelError] =cm_TrichromaticModelErrorAlongZdirection(btsStruct, tmpInd)



if ~exist('tmpInd','var')
    tmpInd = 1;
end


p = 2;       % exponential

nT = size(btsStruct.Thresholds, 1); % get number of bootstrapping

% get data
params      = btsStruct.paramSets;
StimDir     = params.StimDirEach{tmpInd};
[nStimDir]   = cm_makeStimDirFromPsychdata(StimDir);

% Predicted thresholds by each bootstrapped model
PredT       = btsStruct.eTh{tmpInd};

% get measured threshold
[~, measThresh] = cm_makeStimDirFromPsychdata(params.PsychdataEach{tmpInd});

measThresh = ones(nT(1),1) * measThresh;

sampledInds = btsStruct.rsInds{tmpInd};

Nmat = nan(size(sampledInds));

[nTrial nSample] = size(sampledInds);

for ii = 1:nTrial
    Unsampled  = setdiff(1:nSample,sampledInds(ii,:));
    Nmat(ii,Unsampled) = 1;
end

Errors = (PredT - measThresh) ./ measThresh ;
Errors = Errors .* Nmat;

for ii = 1:nSample
    eachDir              = Errors(:,ii);
    medianModelError(ii) = median(eachDir(~isnan(eachDir)));
end

zlength = abs(nStimDir(4,:));

%%


