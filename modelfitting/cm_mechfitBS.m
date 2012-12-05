function  cm_mechfitBS(subinds, numMech, fovflag, corflag, coneflag, nCalc, ResampleRatio, tag)
%
% cm_mechfitBS(methodTag, tempFreqs, PODparams, nCalc, ResampleRatio)
%
% This script run the bootstrapping procedure with SGE (Sun Grid Engine,
% parallel computing). If the code runs without sun grid engine, it runs in
% a series, so it takes much longer time.
%
% <Input>
%       subinds         ... which subject
%       numMech         ... number of mechanisms
%       fovflag         ... 1 is fovea, 0 is periphery
%       corflag         ... 1 is Correct the model for pigment density
%       coneflag        ... 0 indicates allow a 4th, non-cone, photopigment contribution.
%       nCalc           ... number of bootstrapping process
%       ResampleRatio   ... ratio of resampling (from 0 to 1)
%
% <Ontput> none
%       The results will be saved at foleder defined by
%       cm_definefolderforSaveSGEresults.m
%
%       Thresh      ... Predicted threshold by model
%       PredP       ... Predicted coodinate in 4D space
%       VisMtrcies  ... Visivility Matrix
%       params      ... parameters for analysis
%       sSumL       ... sum of negative log-likilihood
%       eachT       ... Predicted threshold at each temporal frequency
%       eachP       ... Predicted coodinate at each temporal frequency 
%       RSs         ... randsample index
%
% see cm_RunBootstrappingSGC.m for the detail
%
% HH (c) Vista lab Oct 2012. 
%
%% set paramters

% get stimulus params from variables
[methodTag, tempFreqs, ~, PODparams, subtag] = cm_dataTagSwitcher(subinds, numMech, fovflag, corflag, coneflag);

% prepare data
params = cm_prepDataforMechanismfit(subtag, tempFreqs, [], PODparams, methodTag);

% if number of resampling is same as those of data, it should allow to
% sample data with overlapping. If not, overlapping is not allowed.
if ResampleRatio == 1
    overlappingflag = true;
else
    overlappingflag = false;
end

% Seeds for bootstrapping procedure.
% The seeds are picked up from the fits with all data points 
params.seeds = cm_loadResults('seeds', subinds, numMech, fovflag, corflag, coneflag);

% if no variable for tag as identifier of results
if ~exist('tag','var') || isempty(tag)
    tag = datestr(now,30);
end

% parameters used in published data 
fixRandSeedflag = false; % noise for seeds and data resample are not fixed 
nTrial1st_2nd   = [1000 1]; % 1st fit with lookup table 1000 times, 2nd fits once from the 1st results as seeds

%% main fitting process

% keep default params
runparams = params;

%% main loop for resampling
for ii = 1:nCalc
    
    %  prep variables to store randsampled data
    inds = 0;
    runparams.StimDir    = [];
    runparams.Psychodata = [];
    runparams.rawdataAll = {};
    
    % randsample data points based on
    for ij = 1:length(tempFreqs)
        
        nDataset(ij) = size(params.PsychdataEach{ij},2);
        
        % leave two out for increment and decrement average data
        nDh = nDataset(ij) ./ 2;
        RSh = randsample(nDh, round(nDh * ResampleRatio), overlappingflag);
        RS = [RSh*2-1, RSh*2]';
        RS = RS(:);
        
        runparams.StimDir    = [runparams.StimDir params.StimDirEach{ij}(:,RS)];
        runparams.Psychodata = [runparams.Psychodata params.PsychdataEach{ij}(:,RS)];
        
        for ik = 1:length(RS)
            inds = inds + 1;
            runparams.rawdataAll{inds} = params.rawEach{ij}(:,RS(ik));            
        end
                
        runparams.PsychdataEach{ij} = params.PsychdataEach{ij}(:,RS);
        runparams.rawEach{ij}       = params.rawEach{ij}(:,RS);
        runparams.StimDirEach{ij}   = params.StimDirEach{ij}(:,RS);
        runparams.lkupTEach{ij}     = params.lkupTEach{ij}(RS,:);
        
        RStmp{ij} = RS;
    end
    
    %% fit the model to the resampled data    
    [VisMtx, runparams] = cmMechamismfitResultsOutput_Mainloop(runparams, nTrial1st_2nd, fixRandSeedflag);
    
    %% store the results
    % Predicted measuremnts and thresholds on each stimulus direction
    [Pred, Th]  = cm_estPredThresh(VisMtx, params.PsychdataEach, params.p, params);
    
    % organize each temporal freq data set
    ind = 1;    
    for ij = 1:length(tempFreqs)
        P{ij} = Pred(:,ind:sum(nDataset(1:ij)));
        T{ij} = Th(ind:sum(nDataset(1:ij)));
        ind = ind + nDataset(ij);
    end
    
    % organize them
    Thresh(ii,:)  = Th;
    PredP(:,:,ii) = Pred;
    eachP{ii,:}   = P;
    eachT{ii,:}   = T;
    VisMtrcies(:,:,:,ii)   = VisMtx;
    RSs{ii} = RStmp;

end

%% save results

% name for analysis
foldername = cm_definefolderforSaveSGEresults(subinds, methodTag, fovflag, corflag, ResampleRatio);


% save
filename = fullfile(foldername,sprintf('SegmentedResults-%d.mat',tag));
fprintf('[%s]:saved file - %s\n', mfilename, filename);
save(filename,'Thresh','PredP','eachP','eachT','VisMtrcies','params','RSs');

end

%% For Debugging
% for checking the results
% figure, cm_mechanismfit_draw2D(VisMtrcies(:,:,:,1),params,[1 0 0],1);
