function cm_histLMSrespFromOrigin(invdir, FaceColor, EdgeColor)


%%
if ~exist('FaceColor','var') || isempty(FaceColor)
    FaceColor = [0 0 1];
end
if ~exist('EdgeColor','var') || isempty(EdgeColor)
    EdgeColor = [0 0 1];
end

if iscell(invdir)
    nSub = length(invdir);
    
    for ii = 1:nSub
        nullDs(:,:,ii) = invdir{ii};
    end
else
    nSub = 1;
    nullDs = invdir;
end

DistfromOrigin = squeeze(sqrt(sum(nullDs(1:3,:,:) .^ 2, 1)));

%%
Min = -.5; Max = 10.5; nbin = 45;
bin = linspace(Min,Max,nbin);

% figWidth = nSub * 450;
% figure('Position',[0 0 figWidth 300])

for ii = 1:nSub
    subplot(1,nSub,ii)
    
    if nSub == 1
        d = DistfromOrigin;
    else
        d = DistfromOrigin(:,ii);
    end
    
    hist(d,bin);
    h = findobj(gca,'Type','patch');
    set(h(1),'FaceColor',FaceColor,'EdgeColor',EdgeColor,'LineWidth',2)
    xlim([Min Max]);ylim([0 1000])
    set(gca,'XTick',0:5:10,'YTick',0:500:1000)
    hold on
end