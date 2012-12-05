function [ngeSumlogllh VisMtcies Threshold] = cm_VisMtxMultiFreq(unKnownVectors, params)
% [ngeSumlogllh VisMtcies Threshold] = cm_VisMtxMultiFreq(unKnownVectors, params)
%
%
%
%
% see also cm_mechanismfit_main.m and cm_mechanismfit_setCommand_and_Boudary.m
% 
%% calc Visual matricies
VisMtcies = cm_VisMtx(unKnownVectors, params);

%% calculate sum of negative log-likelihood and threshold
[ngeSumlogllh Threshold] = cm_sumoflikelihoodQmatMultiFreq(VisMtcies, params);

end




