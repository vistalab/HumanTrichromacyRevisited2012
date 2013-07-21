function [LMSQuanta, LMSEnergyFunc] = ieReadHumanQE(inertP, melanopsinflag)
% [cFilters, LMSEnergyFunc] = ieReadHumanQE(inertP)
% 
% Input
%    inertP ... is created by the function odParams
%     (fields).lens
%             .macular
%             .LPOD
%             .MPOD
%             .SPOD
%             .melPOD
%             .wave
%
% Output
%   cFilters ... LMS cones and melanposin function with quantal unit
%
%   inertFilter .. if it's IR filter, should be 1 at all wavelength
%
%   LMSEnergyFunc ... LMS energy function
%
% Example:
%   foveaParams = odParams('stockman fovea');
%   LMSQuanta = ieReadHumanQE(foveaParams);
%   vcNewGraphWin; plot(foveaParams.wave,LMSQuanta);
%   xlabel('Wavelength (nm)'), ylabel('Relative responsivity')
%
% See also: odParams.m
%
% (c) VISTA lab 2012 HH


%%
if ~exist('melanopsinflag','var') || isempty(melanopsinflag)
    melanopsinflag = false;
end

% get LMS cone and melanopsin resuponse function at energy unit
modelparams = [inertP.lens inertP.macular inertP.LPOD inertP.MPOD inertP.SPOD inertP.melPOD];

% This function needs to have the wavelength specified
LMSEnergyFunc = cm_PigmentResposefunction(inertP.visfield, modelparams, melanopsinflag, inertP.wave);

% change an unit from energy to quanta for ISET calculation
q2e         = Quanta2Energy(inertP.wave, ones(length(inertP.wave), 1));
LMSQuanta   = diag(q2e) * LMSEnergyFunc;

% normalize
mx          = max(LMSQuanta);
LMSQuanta    = LMSQuanta*diag(1./mx);

end
