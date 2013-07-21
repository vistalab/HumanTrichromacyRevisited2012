% s_ConeSelfScreening.m
%
% Read in human pigments with different assumptions about self-screening
%
% BW (c) Vista lab 2013 
%
%%
% just for me
path2vsetfolder = '/biac4/wandell/biac3/wandell7/hhiro/matlab/svn/vset';

addpath(genpath(path2vsetfolder))
%%
s_initISET
setpref('ISET','waitbars',0)

%% Initialize params for different densities of pigments

% default wavelength
sensor = sensorCreate('human');
wave = sensorGet(sensor,'wave');

% Get inert pigment densities
inertP = odParams('stockman periphery',wave);   % Stockman peripheral

inertPpred    = inertP; 
inertPactual  = inertP;

% set LMS cone pigment density
inertPpred.LPOD  = 0.25;  inertPpred.MPOD  = 0.25;  inertPpred.SPOD   = 0.20;
inertPactual.LPOD = 0.30; inertPactual.MPOD = 0.30; inertPactual.SPOD = 0.25;

% LMS function as both units of photons and energy
[LMSquantaMed     LMSEnergyPred]   = ieReadHumanQE(inertPpred);
[LMSquantaActual  LMSEnergyActual] = ieReadHumanQE(inertPactual);

vcNewGraphWin; 
plot(wls,LMSquantaMed)
xlabel('Wavelength (nm)')
ylabel('Sensitivity')


