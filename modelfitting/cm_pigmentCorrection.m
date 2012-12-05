function [pod,mds,lfs,lmsR] = cm_pigmentCorrection(InvStimDir, foveaflag, limitflag, limitPigs, saveflag, condname)
%  [pod,mds,lfs,lmsR] = ...
%   cm_pigmentCorrection(InvStimDir, foveaflag, limitflag, limitPigs, saveflag, condname)
%
% This function estimates pigment densites which LMS resopnses based on to
% the stimulus minimize. If results alreday exist, this function will load
% it except for that saveflag is 2 (force save). 
%
% <Input>
%    InvStimDir ... estimated invisible stimulus directions
%    foveaflag  ... fovea(1) or periphery(0)
%    limitflag  ... search paramters within biological plausible range 
%    limitPigs  ... limitation of pigment density
%                   minimum cone pigment optical density
%                   maximum cone pigment optical density
%                   minimum macular pigment optical density
%                   maximum macular pigment optical density
%                   range of lens pigment density from 1 (which indicates standard)
%    saveflag   ... save or not. 2 indicates force save.
%    condname   ... name of condition
%
% <Output>
%   pod     ... estimated photopigment optical density of cones
%   mds     ... estimated macular pigment density 
%   lfs     ... estimated lens pigment density factor
%   lmsR    ... estimated LMS cone responses to the stimuli at 1% modulation 
%
%
%
% see also s_PNAS_figure3.m
%
% HH (c) Vista lab Oct 2012. 
%
%% check if results exist
if ~exist('condname','var') || isempty(condname), condname = []; end

filename = sub_filename(condname, foveaflag, limitflag);

% if file exist 
if exist(filename,'file')
    
    fprintf('\nresults exists; %s\n',filename)
    
    % load results
    if saveflag ~= 2
        
        fprintf('\nload the results %s\n',filename)
        tmp  = load(filename);
        pod  = tmp.pod;
        mds  = tmp.mds;
        lfs  = tmp.lfs;
        lmsR = tmp.lmsR;
        
        return
        
    % run fitting anyway and overwrite
    else        
        fprintf('\nrun fitting procedure and overwrite %s\n',filename)        
    end
end

%% prep params for fitting

% load spectral power distribution of pigment-isolated stimuli
tmp = load('psychdataforPNAS');

if foveaflag
    isolateSPD = tmp.FOVstimSPD ;
    dataset = 'fovea';
else
    isolateSPD = tmp.PERIstimSPD;
    dataset = 'peri';
end


% load LMS absorbance based on Stockman's standard observer
LMSabsorption = cm_loadLMSabsorbance(foveaflag);

wls     = cm_getDefaultWls;
ledspd = cm_getledSPD(wls);
backgroundSPD  = ledspd * ones(6,1);

%% hist pigments densities in each subject

% give boundaries or not
if limitflag
    method = 'fmincon';    % with limitation
else
    method = 'fminsearch'; % without limitaion
end

% for farster procedure, load macular and lens data before fitting
foo = load('decompStockLens');
lT.dl1 = foo.dens_lens1(21:end);
lT.dl2 = foo.dens_lens2(21:end);
lT.met = 'stockman2';

macdensity  = vcReadSpectra('macularPigment.mat', wls);
unitDensity = macdensity / 0.3521;

%% main loop

nSub = length(InvStimDir);

for ij = 1:nSub
    
    nBoots = size(InvStimDir{ij},2);
    
    for ii = 1:nBoots
        
        % spectral power distribution of estimated invisible stimuls 
        nullspd = isolateSPD * InvStimDir{ij}(:,ii);
        
        % fitting 
        [POD MacDen LMSresp lensfactor] = ...
            cm_findPigmentDensity(nullspd,  backgroundSPD, LMSabsorption, method, dataset, unitDensity, lT, limitPigs);
        
        PODS(ii,:)     = POD;
        MDS(ii)        = MacDen;
        LMSresps(:,ii) = LMSresp;
        LFS(ii)        = lensfactor;
    end
        
    pod{ij}  = PODS;
    mds{ij}  = MDS;
    lfs{ij}  = LFS;
    lmsR{ij} = LMSresps;
    
end

%% save
if saveflag ~= 0
    filename = sub_filename(condname, foveaflag, limitflag);
    save(filename, 'pod', 'mds', 'lfs', 'lmsR')
end


end

%%
function filename = sub_filename(condname, foveaflag, limitflag)
    path     = cm_defaultPathforSaveSGEresults(condname);
    filename = fullfile(path, sprintf('pigmentcorrF%dL%d.mat', foveaflag, limitflag));
end
%%