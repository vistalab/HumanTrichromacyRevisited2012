function elxy = cm_mechanismfit_draw2D(VisMatrix,params, dotColor, tmpInds, otherelxy,otherColor,otherStyle)
% elxy = ...
%   cm_mechanismfit_draw2D(VisMatrix,params, dotColor, tmpInds, otherelxy,otherColor,otherStyle)
%
% This function draws the ellipsoidal model on 6 separate plane with data
% points that are close to the plane. And it can also superimpose the ohter
% data. Output is the model ellipses.  
%  
% <Input>
%   VisMatrix ... Visual Matrix
%   params    ... parameter
%   dotColor  ... color of dot, which indicates measurement thresholds
%   tmpInds   ... index of which temporal data set (1-3)
%   otherelxy ... other ellipses x y values
%   otherColor .. color of other ellipse model
%   otherStyle .. line style of other ellipse model
%
% <Output>
%   elxy      ... ellipses data of x and y at each plane 
%
% see also s_PNAS_figure2.m etc....
%
% copyright HH vistalab 2012.10
%
%% prep params
if size(VisMatrix) > 1
    if ~exist('tmpInds','var') || isempty(tmpInds)
        tmpInds = 1;
    end
    Q = VisMatrix(:,:,tmpInds);
    tmp = params;
    params.Psychodata = tmp.PsychdataEach{tmpInds};
else
    Q = VisMatrix;
end

if ~exist('dotColor','var') || isempty(dotColor)
    dotColor = [0 0 0];
end

%% drawing parameters, which just indicates apprearance and location
nPts = 500;
subplotinds = [4 5 1 6 2 3];
xaxisinds   = [1 1 1 2 2 3];
yaxisinds   = [2 3 4 3 4 4];

if ~isfield(params,'subtag')
    subtag = '';
else
    subtag = params.subtag;
end

switch subtag
    case 's1f'
        alim = [0.1 0.1 0.15 0.1 0.15 0.15];
    case 's2f'
        alim = [0.09 0.15 0.15 0.15 0.15 0.175];
    case 's1f2a'
        alim = [0.05 0.075 0.1 0.075 0.1 0.1];
    case 's2f2b'
        alim = [0.08 0.15 0.175 0.15 0.175 0.175];
    case 's1s2f3d'
        alim = [0.08 0.12 0.075 0.12 0.075 0.15];
    case 's1p4a'
        alim = [0.1 0.1 0.2 0.1 0.2 0.2];
    case 's1p4b'
        alim = [0.1 0.1 0.2 0.1 0.2 0.2];
    case {'7','S7'}
        alim = [0.15 0.15 0.2 0.15 0.2 0.2];
    otherwise
        alim = [0.1 0.1 0.15 0.1 0.15 0.15];
end
%% main loop for drawing
for ii = 1:6
    subplot(2,3,subplotinds(ii));
    
    hold on
    if exist('otherelxy','var')
        if ~exist('otherColor','var') || isempty(otherColor)
            otherColor = [0.5 0.5 0.5];
        end
        if ~exist('otherStyle','var') || isempty(otherStyle)
            otherStyle = '-';
        end
        
        ho = plot(otherelxy{ii}(1,:),otherelxy{ii}(2,:),'Color',otherColor,'LineWidth',3,'LineStyle',otherStyle);
    end
    
    % draw ellipses and get data
    [elxy{ii},he] = cm_mechQmatrixPlot(Q, nPts, xaxisinds(ii), yaxisinds(ii), params, 0);
    
    set(he(2),'Visible','off');
    try set(he(3),'Color',dotColor, 'MarkerFace',dotColor); catch ; end;
    
    % set axis
    axis([-alim(ii) alim(ii) -alim(ii) alim(ii)]);
    if alim(ii) >= 0.15
        Ticks = [-0.1 0 0.1];
    elseif alim(ii) > 0.1
        Ticks = [-0.1 -0.05 0 0.05 0.1];
    elseif alim(ii) <= 0.1
        Ticks = [-0.05 0 0.05];
    end
    
    set(gca,'XTick',Ticks,'YTick',Ticks)
    set(gca,'XTickLabel',Ticks*100,'YTickLabel',Ticks*100)
    
    switch subtag
        case {'s1s2f3d','7'}
            try set(he(3),'Visible','off'); catch ; end
    end
    hold off
end

end