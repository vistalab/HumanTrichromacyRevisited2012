function [widthoferrx allbootstrap EachThreshold eachEx] = cmErrorCalcMeasurement(subinds, fovflag, confIntv);
%
% This function must be re-written for cmErrorCalcMeasurement
%
%
%
%
%
%
%
%
%
%%

tepmInd = 1; confint = 80;

nSub = length(subinds);

subjectnames = {'s1p','s2p','s3p'};

for ii = 1:nSub
    
%    [lbConf ubConf allbootdata Thllh] = cm_loadBstThreshEachDir(subinds(nSub), fovflag, confIntv);
    
    [~, ~, ~, ~, Pt025, Pt975, ~, allbootdata, Thllheach] = ...
        cm_pickupDiscriminationMeasurements(subjectnames{ii}, tepmInd, [],1,2,[],[],[],[],[], confint);
    
    [~,a] = cm_makeStimDirFromPsychdata(Pt025);[~,b] = cm_makeStimDirFromPsychdata(Pt975);
    
    Ldiff{ii} = log10(b) - log10(a);
    
    allbootstrap{ii} = allbootdata;
    
    EachThreshold{ii} = Thllheach;
    
end

% get median of all subjects
ld =[];

for ii = 1:nSub
    ld = [ld Ldiff{ii}];
    eachEx(ii) = median(Ldiff{ii});
end

widthoferrx = median(ld);