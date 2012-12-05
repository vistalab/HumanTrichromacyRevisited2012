function LMSconeResps = cm_SimulateConeResponse(backScene, backOi, backSensor, testSPD, numSamplePhotons, wls)
% LMSconeResps = ctmSimulateConeResponse(backScene, backOi, backSensor, testSPD, numSamplePhotons, wls)
% 
% simulate LMS cone responses to test light 
%
% Input
%  ISET sturctures
%  backScene  ... scene structure
%  backOi     ... optical image structure
%  backSensor ... sensor structure
%
%  testSPD     ... n-times test light spectral power distribution, w x n matrix
%  numSamplep  ... number of sampling photons. 'max' tries to get maximum.
%  wls         ... wavelength, 1 x w vector
%
% Output
%  LMSconeResps ... cone isomerization per unit time
%
% % Example
% backScene  = sceneCreate('uniform EE')
% backOi     = oiCreate('human');
% backOi     = oiCompute(backScene,backOi);
% backSensor = sensorCreate('human');  
% backSensor = sensorCompute(backSensor,backOi);
% spd = sceneGet(backScene,'mean energy spd');
% wls = sceneGet(backScene,'wave');
% testSPD = spd' * 1.1;
% numSamplePhotons = 'max';
% LMSconeResps = ctmSimulateConeResponse(backScene, backOi, backSensor, testSPD, numSamplePhotons, wls)
%
% C) Vistalab 2012 HH
%%
if ~exist('numSamplePhotons','var') || isempty(numSamplePhotons)
   numSample = 100; 
end

noiseFlag    = 1;  % Photons only
nTest = size(testSPD,2);
LMSconeResps = cell(1,nTest);

%% main loop

for ii = 1:nTest
    
    spd = testSPD(:,ii);
    
    %% Create a test light to the background and measure its mean distance from the
    % get spectral power distribution we used for psychophysics
    XYZ = ieXYZFromEnergy(spd',wls);
    testluminance = XYZ(2);
    
    test = sceneCreate('uniform EE');
    test = sceneInterpolateW(test, wls);
    test = sceneAdjustIlluminant(test,spd);
    test = sceneAdjustLuminance(test,testluminance);
    
    %%
    backPlusTest = sceneAdd(backScene,test,'add');
    backPlusTest = sceneSet(backPlusTest,'name','back plus test');
    vcAddAndSelectObject(backPlusTest);
    
    %% Plot the two sets of points
    
    oi = oiCompute(backOi,backPlusTest);
    sensor = sensorCompute(backSensor,oi,noiseFlag);
    vcAddAndSelectObject(sensor);
    
    slot = [2 3 4];
    
    L = sensorGet(sensor,'electrons',slot(1));
    M = sensorGet(sensor,'electrons',slot(2));
    S = sensorGet(sensor,'electrons',slot(3));
    
    if ischar(numSamplePhotons)
        if strcmp(numSamplePhotons,'max')
            numSamplePhotons = min([length(L) length(M) length(S)]);
        end
    end
    
    S = S(1:numSamplePhotons); M = M(1:numSamplePhotons); L = L(1:numSamplePhotons);
    
    tmp = [L(:),M(:),S(:)];
    
    
    LMSconeResps{ii} = tmp;

end
% vcNewGraphWin;
% plot3(L0,M0,S0,'b.',L,M,S,'r.');
% xlabel('L-cone isomerization'); ylabel('M-cone isomerization'); zlabel('S-cone isomerization')
% grid on; axis equal

