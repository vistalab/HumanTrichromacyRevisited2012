function cm_histXYZ(before, after, subind)
% cm_histXYZ(before, after, subind)
%
% This function draw histgrams for Figure 3B by cm_plotLMSabsorption.m
%
% <Input>
%   before ... befoer correction (standard observer space)
%   after  ... after pigment correction
%   subind ... which subject
%
% see also s_PNAS_figure3ABC.m
%
% HH (c) Vista lab Oct 2012. 
%
%% prep
nbin = 21;
bin = linspace(-10,10,nbin); 

FaceB = ones(1,3) * 0.8; EdgeB = 'none'; 
FaceA = 'none';  EdgeA = ones(1,3) * 0.2; 

%% draw
for ii = 1:3
    subplot(1,3,ii);
    
    hist(before{subind}(ii,:),bin);
    h = findobj(gca,'Type','patch');
    set(h(1),'FaceColor',FaceB,'EdgeColor',EdgeB,'LineWidth',0.01)
    hold on
    
    hist(after{subind}(ii,:),bin); xlim(minmax(bin))
    h = findobj(gca,'Type','patch');
    set(h(1),'FaceColor',FaceA,'EdgeColor',EdgeA,'LineWidth',3)
    
    set(gca,'XTick',-10:5:10,'YTick',0:500:1000)
end
