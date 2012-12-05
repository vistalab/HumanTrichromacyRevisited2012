% s_PNAS_figure3D.m
%
% 'Human Trichromacy Revisited'
%  by Horiguchi, Winawer, Dougherty and Wandell.
%
% Figure Caption:
% Threshold ellipses after pigment density correction. The cone-silent
% direction is invisible for both subjects, indicated by the holes in the
% Z-direction. Threshold ellipses in the 6 panels are similar for the two
% subjects.   
%
% C) Vista lab, HH Oct 2012. 
%
%% Figure 3D
%  This takes a few minutes to compute.
%
%  Returns the visibility matrix for the mechanisms estimated in Figure 3D
%  using the threshold data set.

subinds  = 1;   % Which subject
numMech  = 3;   % How many mechanisms (3 or 4)
fovflag  = 1;   % In the fovea or not
corflag  = 1;   % Correct the model for pigment density
coneflag = 0;   % Allow a 4th, non-cone, photopigment contribution.
nSeeds = 1000;  % Number of seeds for 1st fitting

% S1 Results
[Vis3D1 params3D1] = cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag,nSeeds);

% S2 results
% This takes even longer to compute to make sure we avoid any local minima.
% The number of 1st fitting, which indicates different seeds for that, is
% 5000 here. In the previous case it was the default (1000).

subinds  = 2; % Which subject
nSeeds   = 5000;
[Vis3D2 params3D2] = cmMechamismfitResultsOutput(subinds,numMech,fovflag,corflag,coneflag,nSeeds);

%% Draw results
%  We don't color the background, but the curves are the same.
%  We attach the data set to the matlab figure.

f = figure('Position',[0 0 1000 630]);
elxy = cm_mechanismfit_draw2D(Vis3D2,params3D2,[0 0 0],1); close(f)
f = figure('Position',[0 0 1000 630]);
params3D1.subtag = 's1s2f3d';
cm_mechanismfit_draw2D(Vis3D1,params3D1,[0 0 0],1,elxy);

% store data
clear data
params3D1.subtag = 's1f';
data.params1 = params3D1; data.vismtx1 = Vis3D1;
data.params2 = params3D2; data.vismtx2 = Vis3D2;
set(gcf,'UserData',data);

%% Save
% cm_figureSavePNAS(f,'3D')