% s_allbootstarapPNAS.m
% 
% 'Human Trichromacy Revisited'
%  by Horiguchi, Winawer, Dougherty and Wandell.
%
% This script is for running all bootstrapped procedure in each figure
%
% sgeflag = true requires knk toolbox by kendrick kay (see stanford
% vistalab wiki). However, if all calculatio is done just on one computer,
% it takes really really long time. 
%
% Also, in the bootstrapping, data will be resampled randomly. so, the
% results will not be exactly same - but they will be acceptablty similar and
% lead same concludion, I (Hiroshi Horiguchi) believe.
%
%

clear all, close all

%% Number of fitting procedure on each core
nCal1t      = 50;

%% Bootstrapipng for figure 3 A
figname     = 'fig3'; % prep params for figure 3
sgeflag     = 1;      % run with sge
bstparams   = cm_ConditionPrepforBootstrapipngSGE(figname);
ORCommand3  = cm_RunBootstrappingSGC(bstparams, sgeflag, nCal1t);

%% Bootstrapipng for figure 5ABC
figname     = 'fig5abc'; % prep params for figure 5abc 
sgeflag     = 1;         % run with sge
bstparams   = cm_ConditionPrepforBootstrapipngSGE(figname);
ORCommand5  = cm_RunBootstrappingSGC(bstparams, sgeflag, nCal1t);

%% Bootstrapipng for figure 5D
figname     = 'fig5d'; % prep params for figure 5d
sgeflag     = 1;       % run with sge
bstparams   = cm_ConditionPrepforBootstrapipngSGE(figname);
ORCommand5d = cm_RunBootstrappingSGC(bstparams, sgeflag, nCal1t);

%% Bootstrapipng for figure 6
figname     = 'fig6'; % prep params for figure 6
sgeflag     = 1;      % run with sge
bstparams   = cm_ConditionPrepforBootstrapipngSGE(figname);
ORCommand6  = cm_RunBootstrappingSGC(bstparams, sgeflag, nCal1t);

%% test run for debug
% figname     = 'fig3'; % prep params for figure 3
% sgeflag     = 0;      % run without sge
% nCal1t      = 1;      %
% bstparams   = cm_ConditionPrepforBootstrapipngSGE(figname);
% bstparams.nBoot = 1;
% 
% ORCommandt  = cm_RunBootstrappingSGC(bstparams, sgeflag, nCal1t);