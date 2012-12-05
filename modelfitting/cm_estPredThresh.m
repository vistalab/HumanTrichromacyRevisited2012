function [Predpoints Thresholds] = cm_estPredThresh(Qmatrices, PsychdataEach, p, params)

NumFreq     = params.NumFreq;
Predpoints  = [];
Sensitivity = [];

for ii = 1:NumFreq
    % get stimulus direction from datapoint
    StimDir     = cm_makeStimDirFromPsychdata(PsychdataEach{ii});
    Qmatrix     = Qmatrices(:,:,ii);
    
    % predicted 4 dimentional points for threshold of the direction with the Q matrix
    S = sum(abs(Qmatrix * StimDir).^p, 1).^(1/p);
    Pred = StimDir ./ (S' * ones(1,size(StimDir,1)))';
    Pred(isnan(Pred) | isinf(Pred)) = 0;
    Predpoints = [Predpoints Pred];
    Sensitivity = [Sensitivity S];
    
%     % distance between input datapoints and predicted ones
%     dist = [dist sqrt(sum((Thresh - PsychdataEach{ii}).^2))];
    
end

Thresholds = 1 ./ Sensitivity;

end