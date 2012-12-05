function [zlength medianModelError] = cm_loadBst_TrichroErrorCal(bstparams, tmpInd, condname)


if ~exist('tempInd','var') || isempty(tempInd)
    tmpInd = 1;
end

%%
subinds  = bstparams.Sub;   % which subject
numMech  = bstparams.NMech; % number of mechanisms
fovflag  = bstparams.Fov;   % fovea or periphery
corflag  = bstparams.Cor;   % correct axis or not with pigment density
coneflag = bstparams.Cone;  % only cone pigmetn or not

ResampleRatio = bstparams.ResampleRatio;


ind = 1;
%% main loop
for sub = subinds
    for nM = numMech
        for fv = fovflag
            if ~(sub == 3 && fv == true) % because S3 foveal data doesn't exist
                for cr = corflag
                    for cn = coneflag
                        
                        btsStruct = cm_loadbootstrapResults(sub, nM, fv, cr, cn, ResampleRatio, condname);
                        
                        [zlength{ind} medianModelError{ind}] = cm_TrichromaticModelErrorAlongZdirection(btsStruct, tmpInd);
                        
                        ind = ind + 1;                        
                    end
                end
            end
        end
    end
end