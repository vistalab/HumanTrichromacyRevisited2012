function [x y er yers rawY] = cm_loadBst_ErrorCal(bstparams, confIntv, tempInd, condname)
%  [x y er yers rawY] = cm_loadBst_ErrorCal(bstparams, confIntv, tempInd, condname)
%
% This function loads bootstarpped results and calcurate error between
% estimated threshold by model and measurement thresholds.
%
% <Input>
% btsparams [struct]  ... parameters for bootstarapping analysis 
%       Fov             ... 1 is fovea, 0 is periphery
%       Sub             ... which subject
%       NMech           ... number of mechanisms
%       Cor             ... 1 is Correct the model for pigment density
%       Cone            ... 0 indicates allow a 4th, non-cone, photopigment contribution.
%       nBoot           ... number of bootstrapping process
%       ResampleRatio   ... ratio of resampling (from 0 to 1)
%
%
%   confIntv ... confidence interval
%   tempInd  ... index of temporal frequency data set
%   condname ... name of condtion
%
% <Output>
%   x       ... measured thresholds
%   y       ... median of estimated thresholds
%   er      ... confidence interval of estimated thresholds
%   yers    ... square error of estimated thresholds
%   rawY    ... all of estimated thresholds
%
%  
% see also cm_ConditionPrepforBootstrapipngSGE.m and cm_plotPredEstComp.m
%
% HH (c) Vista lab Oct 2012. 

%%
if ~exist('condname','var') || isempty(condname)
    condname = [];
end

if ~exist('confIntv','var') || isempty(confIntv)
    confIntv = 80;
end

if ~exist('tempInd','var') || isempty(tempInd)
    tempInd = 1;
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
                        
                        [x{ind} y{ind} er{ind} yers{ind} rawY{ind}] = cmErrorCalcBtsResult(btsStruct, btsStruct.paramSets, confIntv, tempInd);
                        
                        ind = ind + 1;
                    end
                end
            end
        end
    end
end