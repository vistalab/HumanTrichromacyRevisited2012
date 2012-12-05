function [ModelVectors SumL PredPoints Exf] = cm_mechanismfit_main(params)
%
% [ModelVectors SumL PredPoints Exf] = = cm_mechanismfit_main(params);
%
% This function fits the data to model using params which is acquired by an
% m-file (cm_prepDataforMechanismfit.m).
%
% <Input>
%  parmas       ... parameters (struct) 
%
% <Output >
%  ModelVectors ... components of Visivility matrix 
%  SumL         ... sum of negative log likelihood
%  PredPoints   ... predicted points by a model
%  Exf          ... exit flag 
% 
% see also cmMechamismfitResultsOutput_Mainloop.m and s_cmMechamismfit.m 
%
% copyright HH vistalab 2012.9
%
%% set up parameters
% number of trials for fitting procedure 
if ~isfield(params, 'nTrial')
    nTrial = 1; disp('Run the fitting procedure just one time.')
else
    nTrial          = params.nTrial;
end

% raw staircase data for fitting procedure
rawdataAll  = params.rawdataAll;
nD          = length(rawdataAll);

% stimulus directions 
StimDir         = params.StimDir;
nDim            = size(StimDir,1);

if nD ~= size(StimDir,2);
    fprintf('\nSize of Likelihooddata and StimDir is different from each other!\n')
    return
end

%% decide a method for caliculation based on contamination and ability of vision
[lsqcommand gppcommand paramslb paramsub options] = cm_mechanismfit_setCommand_and_Boudary(params);

%% mainloop

% prep result matrices and vectors
PredPoints      = zeros(nDim,nD,nTrial);    % estimated points in 4D space with the model
SumL            = zeros(1,nTrial);          % sum of negative log-likelihood
Exf             = zeros(nD,nTrial);         % exit flags of each fitting procedure

fprintf('fitting (%d times) ',nTrial);

for ik = 1:nTrial
    
    % seeds for fitting procedure
    
    if ~isfield(params,'seeds') || isempty(params.seeds)
        % randamized seeds for 1st fit 
        
        if isfield(params,'fixRandSeedflag') && params.fixRandSeedflag
        
        % fixRandSeedflag ... fixed random seeds for 1st fitting to
        % reproduce the results without a local minimum problem. 
        
            RandStream.setDefaultStream(RandStream('mt19937ar','seed',ik));
        end
        
        seeds = paramslb + (paramsub - paramslb) .* rand(size(paramslb));
    
    else % in the case seeds are defined (2nd fit)
        
        seeds = params.seeds;
    
    end
    
    % run the least square fitting command
    ModelVector = eval(lsqcommand);
    
    % get predicted points from the Visibility Matirx of the model
    [PredPoints(:,:,ik), VisMatrix]  = eval(gppcommand);
    
    % store results
    ModelVectors(ik,:) = ModelVector;
    
    % negative log-likelihood to evaluate the model fit
    SumL(ik)           = cm_sumoflikelihoodQmat(VisMatrix, params);
    
    % show progress
    fprintf('.')
    
end

fprintf(' fitting done.\n');


end
