function [x y er yers rawY] = cmErrorCalcBtsResult(btsStruct, params, confIntv, tempInd)
% [x y er yers rawY] = cmErrorCalcBtsResult(btsStruct, params, confIntv, tempInd)
%
% This functions calculates error from prep data loaded by
% cm_loadbootstrapResults.m and organize for scatter plotting which will be
% done by cm_plotPredEstComp.m
%
%
% Example
%
% btsStruct = cm_loadbootstrapResults(1, 3, 1, 0, 0, 0.9); % see help
% 
% confIntv = 80;
% tempInd  = 1;
% [x y er yers rawY] = cmErrorCalcBtsResult(btsStruct, btsStruct.params, confIntv, tempInd);
% 
% see also cm_loadbootstrapResults.m and cm_plotPredEstComp.m
%
% HH (c) Vista lab Oct 2012
%
%% prep
if ~exist('btsStruct','var')  || isempty('btsStruct'),
    help cmErrorCalcBtsResult
    return
end

if ~exist('tempInd','var')  || isempty('tempInd'),
    tempInd  = 1;% analysis for pulse data (1 Hz)
end

if ~exist('confIntv','var')  || isempty('confIntv'),
    confIntv = [80];
end

% define percentile
prthresh = 100 - confIntv;
pnum = length(prthresh);
pth = [prthresh ./ 2; (100 - prthresh ./ 2)]; pth = pth(:)';

EachTresh    = btsStruct.eTh;
EachRandsamp = btsStruct.rsInds;

%% main loop
sInd     = 1; % start index to keep multiple freq data 
steps    = 2; % run averaged data

for tempData = 1:length(tempInd)
    
    tInd = tempInd(tempData);    
    [~, s_x] = cm_makeStimDirFromPsychdata(params.PsychdataEach{tInd});

    et = EachTresh{tInd};  % threshold in each bootstarapped trial
    [nT nDp]= size(et);    % get size of data
    
    eInd = sInd + nDp - 1; % end index to keep multiple freq data 
    
    s_rawY = nan(nT, nDp);
    
    %% pick up the unused data points in each bootstrapping for cross-validation
    
    
    ER = EachRandsamp{tInd};
    
    for ij = 1:nT
        xvalidind = unique(setdiff(1:nDp, ER(ij,:)));
        s_rawY(ij,xvalidind) = et(ij,xvalidind);
    end
    
    clear s_yers Median_and_Conf
    
    for ij = 1:steps:nDp
        
        y_Nan = s_rawY(:,ij);
        
        if steps == 2,
            y_Nan = [y_Nan; s_rawY(:,ij+1)];
        end
        
        % remove NaN
        y_noNan = y_Nan(~isnan(y_Nan));
        
        % Here we prepare for sum of square error each direction
        nTS = size(y_noNan,1); % number of trials that is unused for fitting
        
        % square error between measured and predicted threholds
        % measured  ... calc based on one direction data set
        % predicted ... estimated threshols based the model
        s_yers{ij} = ((ones(nTS,1) * s_x(ij) - y_noNan)) .^ 2 ;
        
        % median and confidence interval
        Median_and_Conf(:,ij) = prctile(y_noNan ,[50 pth]);
        
        % median of estimated thresholds
        s_y = Median_and_Conf(1,:);
        
        % skip to calc again for averaged data
        if steps == 2,
            s_y(ij+1)               = s_y(ij);
            s_yers{:,ij+1}          = s_yers{:,ij};
            Median_and_Conf(:,ij+1) = Median_and_Conf(:,ij);            
        end        
    end
    
    % organize confidnece interval data for errorbar2.m (by knk)
    clear s_er
    
    for ij = 1:pnum
        tmpind = ij * 2;
        tmp    = Median_and_Conf(tmpind:tmpind+1,:) - (ones(2,1) * s_y);
        s_er(ij,:) =  -tmp(1,:) + 1i * tmp(2,:);
    end
    
    % store data
    x(sInd:eInd)      = s_x;
    y(sInd:eInd)      = s_y;
    er(sInd:eInd)     = s_er;
    rawY(:,sInd:eInd) = s_rawY;
    
    dataInds          = sInd:eInd;

    for ij = 1:length(s_yers)
        yers{dataInds(ij)} = s_yers{ij};
    end
    
    % set start index to next freq data
    sInd = eInd + 1;
end

end