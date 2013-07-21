function PigResfunc = cm_PigmentResposefunction(foveaflag, modelparams, melanopsinflag, wls)
% PigResfunc = cm_PigmentResposefunction(foveaflag, modelparams, melanopsinflag, [wls])
%
% <Input>
%   foveaflag       ... fovea or not
%   modelparams     ... model parameters: 1) lens pigment density parameter
%                       2) macular pigment density 3)-6) photopigment
%                       optical density 
%
%   melanopsinflag  ... include melanopsin response function true/false
%
% <Output>
%
%   PigResfunc      ... response functions for each photopigment
%
%
%
% (c) VISTA lab 2012 HH
%%

if ~exist('wls','var') || isempty('wls')
    wls = cm_getDefaultWls;
end

if    ~isempty(strfind(foveaflag,'fovea')),     foveaflag = 'fovea';
else  ~isempty(strfind(foveaflag,'periphery')), foveaflag = 'periphery';
end
switch foveaflag
    case {1,'f','fovea','fov'}
        foveaflag = true;
    case {0,'p','peri','periphery'}
        foveaflag = false;
end

lensfactor = modelparams(1);
macfactor  = modelparams(2);

% get LMS absorbance
absorbanceSpectra = cm_loadLMSabsorbance(foveaflag,wls);

% need melanopsin?
if melanopsinflag
    
    melpeak           = 482;
    melabsorbance     = PhotopigmentNomogram(wls',melpeak,'StockmanSharpe');
    absorbanceSpectra = [absorbanceSpectra melabsorbance'];
    
    PODs = modelparams(3:6);
else
    PODs = modelparams(3:5);
end


%% transmittance of lens and macular
% lens transmittance function
lT = cm_LensTransmittance(lensfactor, wls,'stockman2');

% macular transmittance function
mT = macular(macfactor, wls);

% whole eye transmittance function
eT = lT .* mT.transmittance';

% assume no peak shift
Lambdashift = 0;

%%  pigment response function
PigResfunc = cm_variableLMSI_PODandLambda(absorbanceSpectra, PODs, Lambdashift, eT, wls);

end