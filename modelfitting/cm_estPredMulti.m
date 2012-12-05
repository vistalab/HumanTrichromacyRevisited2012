function [Pred VisMtcies] = cm_estPredMulti(unKnownVectors, params)
%
%
%
%% prep
p               = params.p;
PsychdataEach   = params.PsychdataEach;
%% calc Visual matricies
VisMtcies = cm_VisMtx(unKnownVectors, params);

%% calculate threshold and distances
Pred = cm_estPredThresh(VisMtcies, PsychdataEach, p, params);

end