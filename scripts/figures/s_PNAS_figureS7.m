% s_PNAS_figureS7.m
%
% 'Human Color Sensitivity: Trichromacy Revisited'
%  by Horiguchi, Winawer, Dougherty and Wandell.
%
% Peripheral model fitting to 40 Hz measurements without pigment
% correction. A single visual mechanism (Monochromacy, V1x4) explains
% sensitivity to high temporal frequency (40 Hz) modulations in the
% periphery. The data are plotted using standard color observer cones. The
% measured thresholds (filled circles) fall very near a planar surface in
% the four-dimensional space.
%
% C) Vista lab, HH Oct 2012. 
%
%%
path = cm_defaultPathforSavefigure;
figurepath = fullfile(path,'S4A.fig');
f  = open(figurepath);
S1 = get(f,'UserData');
close(f)

%% draw 40 Hz results
% draw S1 results at 40Hz
fS7 = figure('Position',[0 0 1000 630]);
S1.params4.subtag = 'S7';
cm_mechanismfit_draw2D(S1.vismtx4,S1.params4,[0 0 0],3);

%% save 
% cm_figureSavePNAS(fS7,'S7');