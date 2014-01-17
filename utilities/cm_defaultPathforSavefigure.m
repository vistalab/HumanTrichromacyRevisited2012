function path = cm_defaultPathforSavefigure
% Set path to save figures.
%
% path = cm_defaultPathforSavefigure
%
%%

path = fullfile(cmPublicRootPath,'PNASfigures');

if ~exist(path,'dir'), mkdir(path); end

return
