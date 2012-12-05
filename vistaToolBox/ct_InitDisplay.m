function display = ct_InitDisplay(photometer)
% display = ct_InitDisplay
%   initialize the monitor display settings for fov staircase expt

% Hacking just for running Display part tentatively.
% display = loadDisplayParams('DELL485');

%set the display to the biggest square that fits on the monitor
% try
%     dispname = 'DELL1905FP';
%     display = loadDisplayParams(dispname);
%     if strcmp(dispname,'DELL1905FP')
%         display.distance = 14 * 2.54 /100;
%         display.width    = 12 * 2.54 /100;
%         % display.dimensions = [800 600];
%         display.radius = pix2angle(display,floor(min(display.numPixels)/2));
%         
%     end
%     
% catch
%     disp('Calibration data for Dell1905FP does not exist');
% end
%set the display to the biggest square that fits on the monitor
display.wavelengths = cm_getDefaultWls;

if ~exist('photometer','var') || isempty(photometer),
    photometer = 'pr650';
end

display.spectra     = cm_getledSPD(display.wavelengths, photometer);

end