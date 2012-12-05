function [sumLikelihood LogLikelihood]= cm_sumoflikelihoodQmat_sub(Thresh, nD, raw, slope, aveflag, params)
% This function calculates sum of negative log likelihood across the
% thresholds predicted by model. Main function is cm_sumoflikelihoodQmat.m.
%% prep
if ~exist('slope','var') || isempty(slope)
    slope = 2;
end

if ~exist('aveflag','var') || isempty(aveflag)
    aveflag = false;
end

if ~exist('params','var') || isempty(params)
    params.gridfitflag = false;
elseif ~isfield(params,'gridfitflag')
    params.gridfitflag = false;
else
    
end

%% calc negative log-likelihood
nstep = aveflag + 1;
LogLikelihood = zeros(1,nD);

% grid fit - using look-up table insted real calculation
if params.gridfitflag == true;

    nllt = params.lkupTEach{params.currentDataInd};
    bins = params.nllt.bins;
    
    for ii = 1:nD
        subThre = abs(bins - Thresh(ii));
        tmp = min(subThre) == subThre;
        LogLikelihood(ii) = nllt(ii,tmp);
    end    
        
% search fit - using look-up table insted real calculation    
elseif params.gridfitflag == false,
       
    for ii = 1:nstep:nD
        
        data    = raw{ii};
        n       = ones(1,size(data,2));
        
        maxTh   = 100;
        guess   = 0.5;
        flake   = 0.999;
        
        if Thresh(ii) > maxTh
            Thresh(ii) = maxTh;
        end
        
        freeparams = [Thresh(ii) slope guess flake maxTh];        
        L          = WeibullLikelihood([],data,freeparams,n);
        
        LogLikelihood(ii) = L;
        
        if aveflag == true            
            LogLikelihood(ii+1) = L;            
        end        
    end
end

%% sum
sumLikelihood = sum(LogLikelihood);
