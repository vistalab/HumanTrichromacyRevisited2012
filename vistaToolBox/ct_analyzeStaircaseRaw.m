function analysis = ct_analyzeStaircaseRaw(d,varargin)
% analysis = ct_analyzeStaircaseRaw(d,varargin);
%
% This function analyzes a single dataSummary from doStaircase. Original
% function is analyzeStaircase.m in vistadisp, which is also open source
% software.
%
% Fits a Weibull function to the data and returns the relevant parameters
% in an analysis struct.  The returned threshold is for 82% performance.  
%
% Difference from original is the function deals with raw logical data,
% that is 0 or 1 directly instead of using percentage for Weibull fitting.
%
% 06.16.99	Written by wap
% 07.27.99  RFD: now ignores data points with fewer than 3 trials
%
% see also analyzeStaircase.m (vistadisp)
% 
% HH (c) Vista lab 2010. 
%%
x = d.stimLevels(:)';
k = d.numCorrect(:)';
data = [x; k];

% was : thresh = median(x);	% starting value
% Changed to median of history to avoid bia to untested levels.
% Changed by Junjie Liu May 31, 2002.

thresh = median(d.history);	% starting value
guess = 0.5;
flake = 0.999;
maxThresh = 100;

doFixSlope = find(strcmp('fixSlope',varargin));
if ~isempty(doFixSlope)
    slope = varargin{doFixSlope+1};
    free = 1;
else
    slope = 3.5;
    free = [1 2];
end
startParams = [thresh slope guess flake maxThresh];

[fitParams,q,chisq,df] = fitFunc(startParams, data, free, 'WeibullLikelihood');

analysis.thresh = fitParams(1);
analysis.slope = fitParams(2);
analysis.guess = fitParams(3);
analysis.flake = fitParams(4);
analysis.q = q;
analysis.chisq = chisq;
analysis.df = df;
analysis.x = data(1,:);
analysis.y = data(2,:);

FineBinflag = find(strcmp('fineBins',varargin));

if ~isempty(FineBinflag)
    ranges_bins = varargin{FineBinflag+1};
    ranges = ranges_bins(1:2);
    nbin   = ranges_bins(3);
    Lr     = log10(ranges);
    bins   = logspace(Lr(1),Lr(2),nbin);
    analysis.wx = bins;
else
    analysis.wx = 10.^[min(log10(data(1,:))):0.01:max(log10(data(1,:)))];
end

analysis.wy = weib(analysis.wx, analysis.thresh, analysis.slope, guess, flake);

if any(strcmp('doPlot',varargin))
    figure;
    semilogx(analysis.x,analysis.y,'x');
    hold on; plot(analysis.wx,analysis.wy); hold off;
end

doThreshErr = find(strcmp('threshErr',varargin));
if ~isempty(doThreshErr)
    y0 = data(2,:);
    n0 = n(ok);
    free = 1;
    startParams = fitParams;
    threshes = [];
    fprintf('Doing resampling');
    for ii=1:varargin{doThreshErr+1}
        for jj=1:length(y0)
            data(2,jj) = resample(y0(jj),n0(jj));
        end
        fitParams = fitFunc(startParams, data, free, 'WeibullLikelihood', n0);
        if fitParams(1)<1000
            threshes = [threshes fitParams(1)];
        end
        if ~mod(ii,20)
            fprintf('.');
        end
    end
    analysis.threshErr = std(threshes);
    fprintf('\n');
else
    analysis.threshErr = NaN;
end
return

function y = resample(y0, n)

% y0=proportionCorrect, n=numTrials
% this function creates an n-long vector with y 1's,
% resamples it (with replacement) and returns a new
% proportionCorrect value

nCorrect = round(y0*n);

% do the easy ones first
if     nCorrect==n, y=1; return;    
elseif nCorrect==0, y=0; return;    
end

% create the data vector
z0 = [ones(1,nCorrect), zeros(1,n-nCorrect)];

% resample it, with replacement
y = 0;

for ii=1:length(z0)
    y = y+z0(ceil(rand*n));    
end

y = y/n;

return
