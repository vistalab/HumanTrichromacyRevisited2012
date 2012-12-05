function params = cm_prepDataforMechanismfit(subtag, tempFreqs, dataset, PODparams, methodTag, OneHzAve)
% params = cm_prepDataforMechanismfit(subtag, tempFreqs, dataset, PODparams, methodTag, OneHzAve)
%
% This function replys params struct which includes threshold data and
% lookup table of negative loglikelihood at each stimulus direction.
%
% <Input>
%   subtag      ... tag of subject: s1f, s1p, s2f, .... (char)
%   tempFreqs   ... temporal frequency of data 
%   dataset     ... which dataset you use (always 'all')
%   PODparams   ... photopigment optical densities (includes macular and lens pigment)
%   methodTag   ... model of Visivility matrix (char)
%   OneHzAve    ... flag to ask average pulse (1Hz) data or not
%                   This flag is now always true after we confirmed that
%                   increment and decrement of the detection threshods are
%                   not significantly different.
%
% <Output>
%   params [struct]
%       PsychodataAll ... thresholds data in 4D space (all frequency data)
%       PsychdataEach ... thresholds data in 4D space (each frequency data)
%       rawdataAll    ... raw stair case trial data   (all frequency data)
%       rawdataEach   ... raw stair case trial data   (each frequency data)
%       StimDirAll    ... Stimulus Direction in 4D space (all frequency data)
%       StimDirEach   ... Stimulus Direction in 4D space (each frequency data)
%       nllt          ... negative log-likelihood look-up table (struct)
%
% Example:
% subinds = 1; numMech = 3; fovflag = true; corflag = true; coneflag = true;
% [methodTag tempFreqs dataset PODparams subtag] = cm_dataTagSwitcher(subinds, numMech, fovflag, corflag, coneflag);
% params = cm_prepDataforMechanismfit(subtag, tempFreqs, dataset, PODparams, methodTag);
% 
% see also cm_dataTagSwitcher.m and cmMechamismfitResultsOutput.m
%
% HH (c) Vista lab Oct 2012. 
% 
%% prep params
% average data at pulse data (1Hz) or not
if ~exist('OneHzAve','var') || isempty('OneHzAve')
   OneHzAve = true; 
end

% set slope (if doesn't exist)
if ~exist('slope','var') || isempty('slope')
   slope = 2; 
end

% number of data set at different frequency
NumFreq = size(tempFreqs,2);

% set exponential as 2 for line-element theory
p = 2;

% parameter for lookup table to do farster procedure (grid fitting)
ranges = [0.001 1]; nbin = 500;

%% load data

rawdataAll = []; StimDirAll = []; PsychodataAll = []; nlltdata = []; 

for ii = 1:NumFreq
    
    % average data at 1Hz or not
    if OneHzAve == false && tempFreqs(ii) == 1
        aveflag = false;
    else
        aveflag = true;
    end
    
    % load data
    [raw, StimDir] = cm_loadStairCaseData(subtag,tempFreqs(ii),dataset,aveflag,PODparams);
    
    % prep lookup table for farster procedure (grid fitting)
    [llhlkupT, bins, th] = cm_datalikelihoodsCalc(raw, ranges, nbin, slope);
    
    % estimated threshold based on one direction data
    pde = StimDir .* (ones(4,1) * th);
    
    PsychdataEach{ii} = pde;                % estimated thredholds data in 4D space
    rawEach{ii}       = raw;                % raw trial data to calc log-likelihood
    StimDirEach{ii}   = StimDir;            % stimulus direction (unitlength)
    lkupTEach{ii}     = llhlkupT;           % log-likelihood lookup table for grid fitting
    Aveflags(ii)      = aveflag;            % average flag at the temporal frequency
    
    PsychodataAll   = [PsychodataAll pde]; 
    rawdataAll      = [rawdataAll raw];     % stimulus directions for all frequncy data set
    StimDirAll      = [StimDirAll StimDir]; % stimulus directions for all frequncy data set
    nlltdata        = [nlltdata; llhlkupT]; % negative log-likelihood look-up table
   
end


%% organize data as params

% negative log-likelihood look-up table and parameters for that
nllt.data   = nlltdata;     nllt.bins = bins;
nllt.ranges = ranges;       nllt.slope = slope;

% put the data into params
params = struct('Psychodata',PsychodataAll,'StimDir',StimDirAll,'p',p,...
                'NumFreq', NumFreq,'methodTag',methodTag,'nllt',nllt);

params.PsychdataEach = PsychdataEach;   params.StimDirEach     = StimDirEach;
params.rawEach       = rawEach;         params.rawdataAll      = rawdataAll;
params.Aveflags      = Aveflags;        params.lkupTEach       = lkupTEach;
params.subtag        = subtag;
end
