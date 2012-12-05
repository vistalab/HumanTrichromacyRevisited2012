function [raw,StimDir calivMtx] = cm_loadStairCaseData(subtag,tempFreq,dataset,aveflag,PODparams, filepath)
% [raw,StimDir calivMtx] = ...
% cm_loadStairCaseData(subtag,tempFreq,dataset,aveflag,PODparams, filepath)
%
% This function loads detection threshold data and stimulus direction in 4D
% space which is already fixed with LMSZ-axis based on the diffrences of
% photopigment optical densites between standard color observer and
% individuals in this experiment.
%
% <Input>
%   subtag      ... tag of subject: s1f, s1p, s2f, .... (char)
%   tempFreqs   ... temporal frequency of data 
%   dataset     ... which dataset you use (always 'all')
%   aveflag     ... flag to ask average data or not
%                   This flag is now always true after we confirmed that
%                   increment and decrement of the detection threshods are
%                   not significantly different.
%   PODparams   ... photopigment optical densities (includes macular and
%                   lens pigment)
%   filepath    ... path for data file
%
% <Output>
%   raw         ... raw stair case trial data
%   StimDir     ... Stimulus Direction in 4D space
%   calivMtx    ... 4x4 Matrix for revised LMSZ axes
% 
% see also cm_prepDataforMechanismfit.m
%
% HH (c) Vista lab Oct 2012. 
% 
%% prep

if ~exist('filepath','var')
    filepath = 'psychdataforPNAS.mat';
end

if ~exist('subtag','var') || isempty(subtag)
    subtag = 's1f';
    disp('use S1 foveal data set')
end

if ~exist('tempFreq','var') || isempty(tempFreq)
    tempFreq = 1;
    disp('use pulse (1Hz) dataset')
end

if length(tempFreq) ~= 1
    tempFreq = tempFreq(1);
    fprintf('[%s]:Pickup %d Hz data.\n', mfilename, tempFreq)
end

if ~exist('dataset','var') || isempty(dataset)
    dataset = 'all';
end

if isstruct(PODparams)
    
    if PODparams.cor ||  (strcmp(subtag,'s1p') && tempFreq == 20) || strcmp(subtag,'s3p')
        
        % when we measured partial S1 and all of S3 peripheral data, the
        % display was calibrated with PR-650 which wasn't calibrated for a
        % while. We measured SPD of the display with PR-715 again and all
        % of calcuration is based on the PR715 calibration.    
       
        if (strcmp(subtag,'s1p') && tempFreq == 20) || strcmp(subtag,'s3p')
            preCal = 'pr650';
        else
            preCal = 'pr715';
        end
        
        % important - LMSZ axes are modified here
        calivMtx = cm_CalibrationRevise('pr715', preCal, subtag, PODparams.pods, PODparams.mac, PODparams.lens, PODparams.shift);
        
    else
        % no change for stimulus direction
        calivMtx = eye(4);
    
    end
    
end

if ~exist('aveflag','var')
    aveflag = true;    
end

%%
switch tempFreq
    case 1,
        ttag = 1;
    case {20,30}
        ttag = 2;
    case 40,
        ttag = 3;
    otherwise
end

switch subtag
    case 's1p'
        si = 1; dataname = 'PERI';
    case 's2p'
        si = 2; dataname = 'PERI';
    case 's3p'
        si = 3; dataname = 'PERI';
    case 's1f'
        si = 1; dataname = 'FOV';
    case 's2f'
        si = 2; dataname = 'FOV';
    otherwise
end
%% collect dataset

tmp = load(filepath);
nStimDir = length(eval(sprintf('tmp.%s{%d}{%d}', dataname, si, ttag)));
StimDir  = zeros(4, nStimDir);

for stimtag = 1:nStimDir
    filename = sprintf('tmp.%s{%d}{%d}{%d}', dataname, si, ttag, stimtag);
    d = eval(filename);
    raw{stimtag}  = d.trials;
    StimDir(:,stimtag)  = d.stimdir;
end

% average (always)
if aveflag
    for ii = 1:2:nStimDir
        avR = [raw{ii} raw{ii+1}];
        raw{ii} = avR; raw{ii+1} = avR;
    end
end

% change stimdir as unitlength
StimDir = cm_makeStimDirFromPsychdata(StimDir);

%% revision of calivration
StimDir = cm_axisCorrection(StimDir, dataset,  calivMtx);

end



%% axis correction %%

function stimdir = cm_axisCorrection(stimdir, dataset, calivMtx)

stimdir = calivMtx *  stimdir;

switch dataset    
    case 'all'
    case 'purei' % exclude pure ipRGC stimuli
        stInds = sum(stimdir ~= 0) == 1 & stimdir(4,:) ~= 0;
        %              stInds = find(~stInds);
        stimdir = stimdir(:,(~stInds));
end

end
