function h = cm_plotLMSabsorption(LMSabs, EdgeColor, MarkerFace, drawAxis)
% h = cm_plotLMSabsorption(LMSabs, EdgeColor, MarkerFace, drawAxis)
%
% This function plots LMS absorption in 3D LMS space.
% 
% <Input>
%   LMSabs     ... LMS absorption
%   EdgeColor  ... color of marker edge
%   MarkerFace ... color of marker face
%   drawAxis   ... draw axis or not
%
% <Output>
%   h          ... handle of plots
%
% see also s_PNAS_figure3ABC.m
%      
% HH (c) Vista lab Oct 2012. 
%
%% prep
if ~exist('drawAxis','var') || isempty(drawAxis)
    drawAxis = true;
end

if ~exist('EdgeColor','var') || isempty(EdgeColor)
    EdgeColor = [.7 .7 .7];
end

if ~exist('MarkerFace','var') || isempty(MarkerFace)
    MarkerFace = 'none';
end
%% plot

h = plot3(LMSabs(1,:),LMSabs(2,:),LMSabs(3,:),'o'); hold on; grid on

set(h,'Color',EdgeColor,'MarkerFace',MarkerFace,'LineWidth',1.5)
set(gca,'XTick',-10:5:10,'YTick',-10:5:10,'ZTick',-10:5:10)

xlim([-10 10]);ylim([-10 10]);zlim([-10 10]); axis square;

view(63,32)

%% axis draw
if drawAxis
    Line = [-10 10]; Zero = [0 0]; LW = 1.5;
    plot3(Line,Zero,Zero,'k--','LineWidth',LW)
    plot3(Zero,Line,Zero,'k--','LineWidth',LW)
    plot3(Zero,Zero,Line,'k--','LineWidth',LW)
end