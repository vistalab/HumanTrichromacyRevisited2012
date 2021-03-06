% s_PNAS_figureS4.m
%
% 'Human Color Sensitivity: Trichromacy Revisited'
%  by Horiguchi, Winawer, Dougherty and Wandell.
%
% Figure Caption:
% Trichromacy and Tetrachromacy fit to peripheral measurements without
% pigment correction. Peripheral threshold measurements and ellipsoid fits
% before pigment correction in S1 (A) and S2 (B). Data were fit using
% quadratic models with either three mechanisms (Trichromacy, gray solid
% line) or four mechanisms (Tetrachromacy, black solid line), as defined
% by the row size of the opponent-mechanism matrix, V (see Methods). The
% data are plotted using standard color observer cones. These figures are
% drawn as in Figure 4AB.      
%
% HH (c) Vista lab Oct 2012. 
%
%% model fitting for Figure S4A
%  This takes a few minutes to compute.
%
%  Returns the visibility matrix for the mechanisms estimated in Figure S4A
%  using the threshold data set.

subinds  = 1;   % Which subject
fovflag  = 0;   % periphery (In the fovea or not)
corflag  = 0;   % Correct the model for pigment density
coneflag = 0;   % Allow a 4th, non-cone, photopigment contribution.
nSeeds   = 1000;  % Number of seeds for 1st fitting

% Trichormacy model (3x4) for subject 1 peripheral 
numMech  = 3; % How many mechanisms (3 or 4)
[Vis4A3s params4A3s] = ...
    cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag,nSeeds);

% Tetrachormacy model (4x4) for subject 1 peripheral 
numMech  = 4; % How many mechanisms (3 or 4)
[Vis4A4s params4A4s] = ...
    cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag,nSeeds);

%% draw Figure S4A
f = figure('Position',[0 0 1000 630]);
elxy = cm_mechanismfit_draw2D(Vis4A3s,params4A3s,[0 0 0],1); close(f)
f4as = figure('Position',[0 0 1000 630]);
params4A4s.subtag = 's1p4a';
cm_mechanismfit_draw2D(Vis4A4s,params4A4s,[0 0 0],1,elxy);

% store data
clear data
params4A4s.subtag = 's1p';
data.params3 = params4A3s; data.vismtx3 = Vis4A3s;
data.params4 = params4A4s; data.vismtx4 = Vis4A4s;
set(gcf,'UserData',data);

%% model fitting for Figure S4B

subinds  = 2;    % Which subject

% Trichormacy model (3x4) for subject 2 peripheral 
numMech  = 3; % How many mechanisms (3 or 4)
[Vis4B3s params4B3s] = ...
    cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag,nSeeds);
 
% Tetrachormacy model (4x4) for subject 2 peripheral 
numMech  = 4; % How many mechanisms (3 or 4)
[Vis4B4s params4B4s] = ...
    cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag,nSeeds);

%% Draw Figure S4B
f = figure('Position',[0 0 1000 630]);
elxy = cm_mechanismfit_draw2D(Vis4B3s,params4B3s,[0 0 0],1); close(f)
f4bs = figure('Position',[0 0 1000 630]);
params4B4s.subtag = 's1p4a';
cm_mechanismfit_draw2D(Vis4B4s,params4B4s,[0 0 0],1,elxy);

% store data
clear data
params4B4s.subtag = 's2p';
data.params3 = params4B3s; data.vismtx3 = Vis4B3s;
data.params4 = params4B4s; data.vismtx4 = Vis4B4s;
set(gcf,'UserData',data);

%% Save
cm_figureSavePNAS(f4as,'S4A')
cm_figureSavePNAS(f4bs,'S4B')
