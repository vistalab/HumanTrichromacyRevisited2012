function cm_plotModelErrorAlongZlength(zlength, medianModelError, bin)
% cm_plotModelErrorAlongZlength(zlength, medianModelError, bin)
%  
% This function draws bar plot which shows relation ships between model
% error and length of z-direction with errorbar (confidence interval.)
%
% <Input>
%   zlength          ... length of z-direction
%   medianModelError ... median of model error index
%   bin              ... bin of analysis
%
%
% HH (c) Vista lab Oct 2012. 
%
%% prep
nConds = length(zlength);
nBin = length(bin)-1;

%% calc mean and sem between bins 

for ij = 1:nConds
        
    x           = zlength{ij};
    medianError = medianModelError{ij};
    
    for ii = 1:nBin
        inds = bin(ii) <= x & bin(ii+1) >= x;
        dp = medianError(inds);
        MeanError(ii,ij) = mean(dp);
        SEM(ii,ij) = std(dp) ./ sqrt(length(dp));        
%         er(ii,ij) = SEM(ii,ij) + 1i *  SEM(ii,ij);
    end
end

%% misc 
% index of data
FovInds  = [2 4];
PeriInds = [1 3 5];
%  ylimit
YLim     = [-0.2 1.5]; 
%% plot fovea
sem = SEM(:,FovInds);        sem = sem(:);    
mee = MeanError(:,FovInds)'; mee = mee(:);
nD  = length(mee);

er  = sem + 1i*sem;

subplot(1,2,1)
bar(1:nD,mee,'FaceColor',[1 1 1],'LineWidth',3); hold on

errorbar2(1:nD,mee, er,'v','Color','k','LineWidth',5);

ylim(YLim)
set(gca,'XTicklabel',{'S1','S2'})
set(gca,'YTick',0:0.5:2)
title('Fovea')
xlabel('0 <- length of z-direction -> 1')
ylabel('mean of model error index')
%% plot periphery
sem = SEM(:,PeriInds)';       sem = sem(:);    
mee = MeanError(:,PeriInds)'; mee = mee(:);
nD  = length(mee);

er  = sem + 1i*sem;

subplot(1,2,2)
bar(1:nD,mee,'FaceColor',[1 1 1],'LineWidth',3); hold on
errorbar2(1:nD,mee, er,'v','Color','k','LineWidth',5);

ylim(YLim)
set(gca,'YTick',0:0.5:2)
set(gca,'XTicklabel',{'S1','S2','S3'})
title('Periphery')
xlabel('0 <- length of z-direction -> 1')
ylabel('mean of model error index')
