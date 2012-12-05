function ledSPD = cm_getledSPD(wavelength, photometer, normalizedFlag)
% ledSPD = cm_getledSPD(wavelength, photometer, normalizedFlag)
%
%
%
%
%
%% fill empty

if ~exist('wavelength','var') || isempty(wavelength),
    wavelength = cm_getDefaultWls;
    disp('The ledSPDs range from 390 to 730nm.')
end

if ~exist('photometer','var') || isempty(photometer),
    photometer = 'pr715';
end

if ~exist('normalizedFlag','var') || isempty(normalizedFlag),
    normalizedFlag = false;
end

%% load calibration file

switch photometer
    
    case 'pr650'    
        load('ledSPD.mat');        
        defaultLEDSPDwlt = 370:730;
        
        
        try
            stWls = find(defaultLEDSPDwlt == wavelength(1));
            enWls = find(defaultLEDSPDwlt == wavelength(end));
            ledSPD = ledSPD(stWls:enWls,:);
            
        catch exception
            error('default wavelength of ledSPD is currently %1.0f tp %1.0f.',...
                defaultLEDSPDwlt(1), defaultLEDSPDwlt(end))
            rethrow(exception)
        end
        
        filename = 'pr650(uncalibrated)';
        

    case 'pr715'
        filename = 'ledSPD_pr715.mat';
        ledSPD = vcReadSpectra(filename,wavelength);
        
    case {'b','beam','beamsplitter','bs','bs650'}
        filename = 'ledSPDwithBeamSplitter_pr650.mat';
        ledSPD = vcReadSpectra(filename,wavelength);
        
end

fprintf('[%s]:Caldata was acquired with %s.\n', mfilename, filename)

if normalizedFlag == true;
    ledSPD = bsxfun(@rdivide, ledSPD, max(ledSPD,[],1));
end

return