function f = cm_plotRMSEresults(RMSEs)
% f = cm_plotRMSEresults(RMSEs)
%
% This function plots the RMSE between model estimated and measured
% thresholds. The errorbar indicates confidence interval in bootstrapped
% results.   
% 
% <Input>
%   RMSEs ... Root of mean square error. THe 1st column indicates median. 
% 
% <Output>
%   f ... Handle for figure
% see also s_PNAS_figure6A.m and cm_loadBst_ErrorCal.m 
%
% HH (c) Vista lab Oct 2012. 
%
%% modify errorbar
% for errorbar2. written by KNK
Erbar = RMSEs(:,2:3) - RMSEs(:,1) * ones(1,2);

for ii = 1:size(Erbar,1)
    RmseConfInt(ii) = -Erbar(ii,1) + 1i *  Erbar(ii,2);
end

% put space for nice looking
ind = 1:3;
if size(RMSEs,1) > 6
    space = 2;
else
    space = 1;
end
for ii = 1:space+1
    putInd = (ii-1)*3+ind+(ii-1)*2;
    getInd = (ii-1)*3+ind;
    MedRMSE(putInd) = RMSEs(getInd,1);    
    ConfRMSE(putInd) = RmseConfInt(getInd);
end 

%% draw
FC = [0.7 0.7 0.7]; % color 
width = 30;         % width of figure

nDps = size(ConfRMSE,2); %
widthfigure = width * ( nDps + space * 2 );
f = figure('Position',[0 0 widthfigure 600]);

bh = bar(MedRMSE); hold on
set(bh,'FaceColor',FC,'EdgeColor','none')
eh = errorbar2(1:nDps,MedRMSE, ConfRMSE,'v','Color','k','LineWidth',5);
xnames = {'2','3','4','','','2','3','4','','','2','3','4'};
set(gca,'FontSize',16,'XTick',1:length(xnames),'XTicklabel',xnames);
ylim([0 0.2])
set(gca,'Ytick',0:0.05:0.2)

% store data
clear data
data.RMSEs = RMSEs;
set(gcf,'UserData',data);

end