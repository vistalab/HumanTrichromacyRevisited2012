function cm_figureSavePNAS(f,figname)
% cm_figureSavePNAS(f,figname)
%
% This function saves figure as eps and matlab figure in a folder defined
% by cm_defaultPathforSavefigure.m
%      
% HH (c) Vista lab Oct 2012. 
%
%%
% get path
path = cm_defaultPathforSavefigure;

% save figure as matlabfigure
filename = fullfile(path, sprintf('%s.fig',figname));
saveas(f,filename)

% save figure as eps
filename = fullfile(path, sprintf('%s.eps',figname));
hgexport(f, filename ,hgexport('factorystyle'),'Format','eps');

end