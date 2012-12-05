% s_PNAS_figure7.m
%
% 'Human Color Sensitivity: Trichromacy Revisited'
%  by Horiguchi, Winawer, Dougherty and Wandell.
%
% Figure Caption:
% High temporal frequency thresholds in periphery are influenced by
% cone-silent stimulus. Estimated models at high temporal frequency (40Hz)
% after pigment density correction in S1 and S3. Note that there is no hole
% in the Z-direction: estimated thresholds in the cone-silent direction in
% both subjects are approximately 10%, compared to no contribution of
% cone-silent stimulus for light detection in the foveal measurements (Fig
% 3D).  See Figure S7 and S8 for further related measurements.      
%
% C) Vista lab, HH Oct 2012. 
%
%% load results from Fig 4A (S1) and S5 (S3)
path = cm_defaultPathforSavefigure;
figurepath = fullfile(path,'4A.fig');
f  = open(figurepath);
S1 = get(f,'UserData');
close(f)

figurepath = fullfile(path,'S5.fig');
f  = open(figurepath);
S3 = get(f,'UserData');
close(f)

%% draw 40 Hz results
% get ellipses data from S3
f = figure('Position',[0 0 1000 630]);
S3ellipses = cm_mechanismfit_draw2D(S3.vismtx4,S3.params4,[0 0 0],3);
close(f)

% draw S1 and S3 results at 40Hz
f7 = figure('Position',[0 0 1000 630]);
S3color = [0 0 0]; S3style = '--';
S1.params4.subtag = '7';
cm_mechanismfit_draw2D(S1.vismtx4,S1.params4,[0 0 0],3, S3ellipses,S3color,S3style);

%% save 
% cm_figureSavePNAS(f7,'7');
