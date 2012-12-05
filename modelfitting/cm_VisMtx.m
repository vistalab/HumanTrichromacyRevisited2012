function VisMtcies = cm_VisMtx(unKnownVectors, params)

NumFreq         = params.NumFreq;
%% Mechanism matrix (mechanism matrix)
VisMtx = cm_MechMtx(unKnownVectors, params);

%% Sensitivity for mechanisms at Each Freq
VisAmp = cm_VisMtxSenEachFreq(unKnownVectors, params);

%% Q matrix
for ii = 1:NumFreq
    VisMtcies(:,:,ii) = VisAmp(:,:,ii) * VisMtx;
end