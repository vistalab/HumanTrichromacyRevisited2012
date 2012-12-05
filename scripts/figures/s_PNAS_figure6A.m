%% s_PNAS_figure6A.m
%
% 'Human Trichromacy Revisited'
%  by Horiguchi, Winawer, Dougherty and Wandell.
%
% Figure 6. Cross-validation analysis of model accuracy. (A) Foveal data.
% Scatter plot of the predicted and observed thresholds for ‘left out’
% trials in a cross-validation analysis.  The panels show fits using
% Trichromacy (left) or Tetrachromacy (middle). The open and filled symbols
% are predictions for the two subjects (S1; black filled circles and S2;
% gray shaded triangles).  The vertical error bars are 80% confidence
% interval of the estimate. The horizontal bar (upper left) is the median
% confidence interval for the measured thresholds. The model accuracies are
% compared in the bar plot at the right (80% confidence intervals on the
% bars are shown). The Tetrachromacy fit is slightly better for both
% subjects. Comparing Trichromacy to Tetrachromacy, the root mean square
% error (RMSE) between observed and predicted threshold is reduced from
% 0.060 to 0.050 (S1) and 0.081 to 0.059 (S2). 
%     
% HH (c) Vista lab Oct 2012. 
%
%%
% misc params for plotting
pos  = [0 0 500 500];
C    = [0 0 0; 0.6 0.6 0.6; 0.8 0.8 0.8];
%% get measurement error in each stimulus
% [widthoferrx MeasurementErrors EachThreshold eachEx] = cmErrorCalcMeasurement(subinds, fovflag, confIntv);
% 
% % Define the position of black bar in the figure
% sx = 0.01; sy = 0.5;
% sxend = 10.^(log10(sx) + widthoferrx);
%% Fig 6A. Trichromacy at Fovea (left)
figname = 'fig6f3'; 
bstparams = cm_ConditionPrepforBootstrapipngSGE(figname);

confIntv = 80; % confidence interval 80% 
tempInd = 1;   % which temporal data set is analyzed (1 indicates pulse data)

% load bootstrapped results
[x y er sef3 rawY] = cm_loadBst_ErrorCal(bstparams, confIntv, tempInd);

%% draw 
f6f3    = figure('Position',pos);
cm_plotPredEstComp(x, y, er, C, bstparams.Fov);

% store data
clear data
data.x = x; data.y = y; data.er = er; data.yers = sef3; data.rawY = rawY;
set(gcf,'UserData',data);

%% Fig 6A. Tetrachromacy at Fovea (uppermiddle)
figname = 'fig6f4';
bstparams = cm_ConditionPrepforBootstrapipngSGE(figname);
[x y er sef4 rawY] = cm_loadBst_ErrorCal(bstparams, confIntv, tempInd);

%% draw
f6f4    = figure('Position',pos);
cm_plotPredEstComp(x, y, er, C, bstparams.Fov);

% store data
clear data
data.x = x; data.y = y; data.er = er; data.yers = sef4; data.rawY = rawY;
set(gcf,'UserData',data);

%% save 
cm_figureSavePNAS(f6f3,'6f3')
cm_figureSavePNAS(f6f4,'6f4')

%% figure 6 upper-right and lower-right
% load dichromacy model bootstrapped results
figname = 'fig6r'; 
bstparams = cm_ConditionPrepforBootstrapipngSGE(figname);
[~,~,~,seFovPeriDichro] = cm_loadBst_ErrorCal(bstparams, confIntv, tempInd);

%% foveal results
% sort data 
SquareErrorsFov{1} = seFovPeriDichro{1};SquareErrorsFov{2} = sef3{1};SquareErrorsFov{3} = sef4{1};
SquareErrorsFov{4} = seFovPeriDichro{2};SquareErrorsFov{5} = sef3{2};SquareErrorsFov{6} = sef4{2};

% calc RMSE
RMSEsFov= cm_calcMeasurementError(SquareErrorsFov);

%% draw peripfovealheral results
f6Aright = cm_plotRMSEresults(RMSEsFov);

% store
clear data
data.RMSEsFov = RMSEsFov;
set(gcf,'UserData',data);

%% save
cm_figureSavePNAS(f6Aright,'6Aright')
