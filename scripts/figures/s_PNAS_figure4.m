% s_PNAS_figure4.m
%
% 'Human Color Sensitivity: Trichromacy Revisited'
%  by Horiguchi, Winawer, Dougherty and Wandell.
%
% Figure Caption
% Peripheral threshold measurements and ellipsoid fits after pigment
% correction in S1 (A) and S2 (B). These figures are drawn as in Figure
% 2AB. Because the data are plotted after pigment correction, many of the
% data points do not lie exactly in any of the 6 planes. Hence, the number
% of visible dots in the 6 planes is lower than in Figure 2. In fact, no
% points appear in three of the planes shown. Data were fit using quadratic
% models with either three mechanisms (?Trichromacy?) or four mechanisms
% (?Tetrachromacy?), as defined by the row size of the opponent-mechanism
% matrix, V (see Methods).        
%
% HH (c) Vista lab, HH Oct 2012
%
%% Figure 4A
%  This takes a few minutes to compute.
%
%  Returns the visibility matrix for the mechanisms estimated in Figure 4A
%  using the threshold data set.

subinds  = 1;   % Which subject
numMech  = 3;   % How many mechanisms (3 or 4)
fovflag  = 0;   % In the fovea or not
corflag  = 1;   % Correct the model for pigment density
coneflag = 0;   % Allow a 4th, non-cone, photopigment contribution.
nSeeds   = 1000;% Number of seeds for 1st fitting

% Trichormacy model (3x4) for subject 1 peripheral 
[Vis4A3 params4A3] = cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag,nSeeds);

% Trichormacy model (3x4) for subject 1 peripheral 
numMech  = 4;    % How many mechanisms (3 or 4)
[Vis4A4 params4A4] = cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag,nSeeds);

%% Draw panel A
%  We don't color the background, but the curves are the same.
%  We attach the data set to the matlab figure.

f = figure('Position',[0 0 1000 630]);
elxy = cm_mechanismfit_draw2D(Vis4A3,params4A3,[0 0 0],1); close(f)
f4a = figure('Position',[0 0 1000 630]);
params4A4.subtag = 's1p4a';
cm_mechanismfit_draw2D(Vis4A4,params4A4,[0 0 0],1,elxy);

% store
clear data
params4A4.subtag = 's1p';
data.params3 = params4A3; data.vismtx3 = Vis4A3;
data.params4 = params4A4; data.vismtx4 = Vis4A4;
set(gcf,'UserData',data);

%% Figure 4B
% Trichormacy model (3x4) for subject 2 peripheral 
subinds  = 2;   % Which subject
numMech  = 3;   % How many mechanisms (3 or 4)
[Vis4B3 params4B3] = cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag,nSeeds);
 
% Tetrachormacy model (4x4) for subject 2 peripheral 
numMech  = 4;   % How many mechanisms (3 or 4)
[Vis4B4 params4B4] = cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag,nSeeds);

%% Draw panel B
f = figure('Position',[0 0 1000 630]);
elxy = cm_mechanismfit_draw2D(Vis4B3,params4B3,[0 0 0],1); close(f)
f4b = figure('Position',[0 0 1000 630]);
params4B4.subtag = 's1p4a';
cm_mechanismfit_draw2D(Vis4B4,params4B4,[0 0 0],1,elxy);

% store
clear data
params4B4.subtag = 's2p';
data.params3 = params4B3; data.vismtx3 = Vis4B3;
data.params4 = params4B4; data.vismtx4 = Vis4B4;
set(gcf,'UserData',data);

%% save
cm_figureSavePNAS(f4a,'4A')
cm_figureSavePNAS(f4b,'4B')
