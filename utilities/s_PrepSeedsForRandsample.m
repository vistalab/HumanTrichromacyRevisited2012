% s_PrepSeedsForRandsample.m
%
% HH (c) Vista lab Oct 2012. 
%
%% Dichromacy model at fovea 
numMech  = 2;   % How many mechanisms
fovflag  = 1;   % In the fovea or not

corflag  = 0;   % Correct the model for pigment density
coneflag = 0;   % Allow a 4th, non-cone, photopigment contribution.

subinds  = 1;   % Which subject
nSeeds = 1000;  % Number of seeds for 1st fitting

[V2f1 p2f1] = ...
    cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag, nSeeds);

subinds  = 2;   % Which subject
[V2f2 p2f2] = ...
    cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag, nSeeds);
%% Trichormacy model at fovea 
% Already calculated in Figure 2AB

%% Tetrachromacy model at fovea
numMech  = 4;   % How many mechanisms
subinds  = 1;   % Which subject
[V4f1 p4f1] = ...
    cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag, nSeeds);

subinds  = 2;   % Which subject
[V4f2 p4f2] = ...
    cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag, nSeeds);

%%
%% Dichromacy model at periphery 
numMech  = 2;   % How many mechanisms
fovflag  = 0;   % In the fovea or not

corflag  = 0;   % Correct the model for pigment density
coneflag = 0;   % Allow a 4th, non-cone, photopigment contribution.

nSeeds = 1000;  % Number of seeds for 1st fitting

subinds  = 1;   % Which subject
[V2p1 p2p1] = ...
    cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag, nSeeds);

subinds  = 2;   % Which subject
[V2p2 p2p2] = ...
    cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag, nSeeds);

subinds  = 3;   % Which subject
[V2p3 p2p3] = ...
    cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag, nSeeds);
%% Trichormacy model at periphery 
% Already calculated in Figure S4AB and S5

%% Tetrachormacy model at periphery 
% also Already calculated in Figure S4AB 
numMech  = 4;   % How many mechanisms
subinds  = 3;   % Which subject
[V4p3 p4p3] = ...
    cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag, nSeeds);

%%%%%%%%%%%%%%%%%%%%%
%% cone only model %%
%%%%%%%%%%%%%%%%%%%%%
%% fovea
fovflag  = 1;   % In the fovea or not

numMech  = 3;   % How many mechanisms
corflag  = 1;   % Correct the model for pigment density
coneflag = 1;   % Allow a 4th, non-cone, photopigment contribution.

nSeeds = 1000;  % Number of seeds for 1st fitting

subinds  = 1;   % Which subject
[Vcf1 pcf1] = ...
    cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag, nSeeds);


subinds  = 2;   % Which subject
[Vcf2 pcf2] = ...
    cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag, nSeeds);

%% periphery
fovflag  = 0;   % In the fovea or not

subinds  = 1;   % Which subject
[Vcp1 pcp1] = ...
    cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag, nSeeds);


subinds  = 2;   % Which subject
[Vcp2 pcp2] = ...
    cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag, nSeeds);


subinds  = 3;   % Which subject
[Vcp3 pcp3] = ...
    cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag, nSeeds);



%%
BstSeeds = struct('V2f1',V2f1,'p2f1',p2f1,'V2f2',V2f2,'p2f2',p2f2,...
                  'V4f1',V4f1,'p4f1',p4f1,'V4f2',V4f2,'p4f2',p4f1,...
                  'V2p1',V2p1,'p2p1',p2p1,'V2p2',V2p2,'p2p2',p2p2,'V2p3',V2p3,'p2p3',p2p3,'V4p3',V4p3,'p4p3',p4p3,...
                  'Vcf1',Vcf1,'pcf1',pcf1,'Vcf2',Vcf2,'pcf2',pcf2,... % Trichromatic theory - fovea 
                  'Vcp1',Vcp1,'pcp1',pcp1,'Vcp2',Vcp2,'pcp2',pcp2,'Vcp3',Vcp3,'pcp3',pcp3); % Trichromatic theory - periphery 

%% Save results
path = cm_defaultPathforSavefigure;
filename = fullfile(path, 'BstSeeds.mat');
save(filename,'BstSeeds')

%% Draw Fig 2B analysis from the parameters and data
f = figure('Position',[0 0 1000 630]);
cm_mechanismfit_draw2D(V2f1,p2f1,[0 0 0],1);

f = figure('Position',[0 0 1000 630]);
cm_mechanismfit_draw2D(V2f2,p2f2,[0 0 0],1);