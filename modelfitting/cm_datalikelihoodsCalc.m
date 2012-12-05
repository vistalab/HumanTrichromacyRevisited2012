function [Likelihoods bins thresh] = cm_datalikelihoodsCalc(raw, ranges, nbin, slope)
%
% [Likelihoods bins] = cm_datalikelihoodsCalc(Likelihooddata, ranges, nbin, slope, maxThresh)
%
% calculates negative log-likelihood look-up table for faster fitting (grid fitting)
%
% <Input>
%   raw       ...   raw staricase data
%   ranges    ...   minimum and maximum values
%   nbin      ...   number of bin
%   slope     ...   beta value for weibull fit, usually 2
%
% <Output>
%   Likelihoods ... negative log-likelihood at each bin
%   bins        ... stimulus amplitudes from min to max (logspace, not linear)
%
% Example
%
% [Psychdata holedata raw StimDir names] = cm_pickupDiscriminationMearurements;
% ranges = [0.005 0.5]; nbin = 100;  slope = 2; maxThresh = 1;
% [Likelihoods bins] = cm_datalikelihoodsCalc(raw, ranges, nbin, slope, maxThresh);
% aveflag = false; [~, dpT] = cm_makeStimDirFromPsychdata(Psychdata)
% cm_plotlikelihoodsdataset(Likelihoods, bins, dpT, names, aveflag)
%
% see also cm_prepDataforMechanismfit.m
%
%% set undefined params
if ~exist('raw','var')
    help cm_datalikelihoodsCalc
    if nargout >= 1
        raw = []; bins = [];
    end
    return
end

if nargout == 3
    threshflag =true;
else
    threshflag =false;
end

if ~exist('slope','var') || isempty(slope)
    slope =  2;
end


if ~exist('ranges','var') || isempty(ranges)
    ranges =  [0.01 1];
end


if ~exist('nbin','var') || isempty(nbin)
    
    nbin = 500;
    
end

%% prep
Lr          = log10(ranges);
bins        = logspace(Lr(1),Lr(2),nbin);
nD          = length(raw);
maxThresh   = ranges(2);

%% calc negative log likelihoods

L           = zeros(1,nbin);
Likelihoods = zeros(nD,nbin);

% loop for each stimulus direction
for ij = 1:nD
    
    % withdraw data
    data = raw{ij};
    
    %% main loop for calc look-up table
    
    for ii = 1:nbin
        
        L(ii) = WeibullLikelihood([],data,[bins(ii) slope 0.5 0.999 maxThresh],ones(1,size(data,2)));
        
    end
    
    Likelihoods(ij,:) = L;
    
    %% calc thresholds
    if threshflag == true
        d.history    = median(data(1,:));
        d.stimLevels = data(1,:);
        d.numCorrect = data(2,:);
        analysis     = ct_analyzeStaircaseRaw(d,'fixSlope',slope);
        thresh(ij)   = analysis.thresh;
    end
    
end
