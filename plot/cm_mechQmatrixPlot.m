function [ellipseXY handles ho] = cm_mechQmatrixPlot(Qmatrix,nPts,xAxis,yAxis,fixedparams, outlineflag, Trialdata)
% [ellipseXY handles ho] = cm_mechQmatrixPlot(Qmatrix,nPts,xAxis,yAxis,fixedparams, outlineflag, Trialdata)
%
% This function draws model ellipses and measurement points if those are
% close enough to a plane.
%
%
%
% see also cm_mechanismfit_draw2D
%
% copyright HH vistalab 2012.10
%
%%
if notDefined('outlineflag'), outlineflag = false; end

%% pick up parameters and decide color
Psychodata = fixedparams.Psychodata;

dDim = size(Psychodata);

if length(dDim) == 3
    prcconfflag = true;
    prclodata   = Psychodata(:,:,2);
    prchidata   = Psychodata(:,:,3);
    Psychodata  = Psychodata(:,:,1);
else
    prcconfflag = false;
end

p          = fixedparams.p;
nD         = size(Psychodata,1);
C = [0 0 0];

%% caliculate ellipse on the plane from Q matrix
% number of points of circle
theta = 2*pi* (0:(nPts-1))/nPts;
x = cos(theta); y = sin(theta);

[X xfactor xAxInd] = sub_pickupAxis(xAxis);
[Y yfactor yAxInd] = sub_pickupAxis(yAxis);

% project 2D plane from 4D
S = X * x + Y * y;

T = sum(abs(Qmatrix * S).^p, 1).^(1/p);
Thresh = S ./ (T' * ones(1,size(Qmatrix,2)))';
Thresh(isnan(Thresh) | isinf(Thresh)) = 0;

XThresh = sub_projectPlane(Thresh, xAxis, xfactor);
YThresh = sub_projectPlane(Thresh, yAxis, yfactor);
ellipseXY = [XThresh; YThresh];

%% plot ellipse on the plane
handles(1) = plot(XThresh, YThresh,'Color',C,'LineWidth',2); hold on, grid on

if outlineflag == true
    
    Co = {'m','b','g','r'}; %GB, BS, Lum, L-M(RG)
    
    for ii = 1:size(Qmatrix,1)
        T = sum(abs(Qmatrix(ii,:) * S).^p, 1).^(1/p);
        Thresh = S ./ (T' * ones(1,size(Qmatrix,2)))';
        Thresh(isnan(Thresh) | isinf(Thresh)) = 0;
        XThreshO = sub_projectPlane(Thresh, xAxis, xfactor);
        YThreshO = sub_projectPlane(Thresh, yAxis, yfactor);
        ho(ii) = plot(XThreshO, YThreshO,'Color',Co{ii}); hold on, grid on
    end
    
end

%% find psychophysics mesurement data on the plane and plot them on it

if ~isempty(Psychodata)
    
    %% project data points to the plane
    PsychX = sub_projectPlane(Psychodata, xAxis, xfactor);
    PsychY = sub_projectPlane(Psychodata, yAxis, yfactor);
    
    if prcconfflag == true
        
        lX = sub_projectPlane(prclodata, xAxis, xfactor);
        lY = sub_projectPlane(prclodata, yAxis, yfactor);
        
        hX = sub_projectPlane(prchidata, xAxis, xfactor);
        hY = sub_projectPlane(prchidata, yAxis, yfactor);
        
        nsteps    = 10;
        threshold = linspace(0,1,nsteps);
        threshold = threshold .^2;
        
        % find points around plane
        for ij  = 1:nsteps-1
            inds(ij,:) = cm_findPointsAroundPlane(xAxis,yAxis,Psychodata,threshold(ij:ij+1));
        end
        
        for ii = 1:dDim(2)
            linethickness = (nsteps - find(inds(:,ii))) * 0.5;
            plot([lX(ii) hX(ii)], [lY(ii) hY(ii)],'k','LineWidth',linethickness);
        end
        
        for ij = 1:nsteps-1
            
            indstmp = find(inds(ij,:));
            
            if ~isempty(indstmp)
                
                mSize = (nsteps + 1 - ij) * 1.5;
                
                handles(2) = plot(PsychX(:,indstmp), PsychY(:,indstmp),'ko',...
                    'MarkerFaceColor','w','MarkerSize',mSize);
                
            end
            
        end
                
    else
        % find points around plane
        pinds = cm_findPointsAroundPlane(xAxis,yAxis,Psychodata, 0.05);
        
        % find points out of the plane
        drawinds1 = find(~pinds);
        if ~isempty(drawinds1)
            handles(2) = plot(PsychX(:,drawinds1), PsychY(:,drawinds1),'k.');
        end
        
        % find points on the plane
        drawinds2 = find(pinds);
        if ~isempty(drawinds2)
            handles(3) = plot(PsychX(:,drawinds2), PsychY(:,drawinds2),'ro',...
                'MarkerFaceColor','r','MarkerSize',5);
        end
        
    end
    
    % decide plot limitation(L) dependent on measured data point
    dp = [PsychX PsychY];
    exholes = (dp < 0.5);
    L = max(dp(exholes)) * 1.1;
    
else
    % decide plot limitation(L) dependent on predicted data point
    L = max(ellipseXY(:)) * 1.3;
end

if L > 0.25, L = 0.25; end

L = [-L L];

%% make plot looks better
plot([0 0],L,'k--'), plot(L,[0 0],'k--'), xlim(L), ylim(L)
axis square

if exist('Trialdata','var')
    TrialX = sub_projectPlane(Trialdata, xAxis, xfactor);
    TrialY = sub_projectPlane(Trialdata, yAxis, yfactor);
    
    pinds = sub_findpoints_onPlane(Trialdata, xAxInd, yAxInd, nD);
    
    handles(4) = plot(TrialX, TrialX,'ko');
    
    if ~isempty(pinds)
        plot(TrialX(:,pinds), TrialY(:,pinds),'go')
    end
end

xlabel(sub_GiveName(xAxis),'FontSize',14);
ylabel(sub_GiveName(yAxis),'FontSize',14);
set(gca,'FontSize',14)
hold off
end


%%
function nThresh = sub_projectPlane(Thresh, nAxis, nfactor)

if length(nAxis) == 4
    nThresh = (nAxis ./ nfactor) * Thresh;
elseif length(nAxis) == 3
    nThresh = (nAxis ./ nfactor) * Thresh;
else
    nThresh = sum(Thresh(nAxis,:),1) ./ nfactor;
end

end
%%
function [N nfactor nAxInd]= sub_pickupAxis(nAxis)
if length(nAxis) == 4
    N = nAxis(:); nAxInd = find(nAxis);
elseif length(nAxis) == 3
    N = nAxis(:); nAxInd = find(nAxis);
else
    N = zeros(4,1); N(nAxis) = 1; nAxInd = nAxis;
end
nfactor = norm(N);
N = N ./ nfactor;
end

%%
function name = sub_GiveName(nAxis)
names = {'L','M','S','Z'};
if length(nAxis) == 4
    name = char;
    for ii = 1:length(nAxis)
        switch nAxis(ii)
            case -1, name = sprintf('%s-%s',name,names{ii});
            case 0,
            case 1,  name = sprintf('%s+%s',name,names{ii});
            otherwise
                name = sprintf('%s%1.1f%s',name,nAxis(ii),names{ii});
        end
    end
else
    name = sprintf('%s',names{nAxis});
end
name = sprintf('delta %s',name);
end
