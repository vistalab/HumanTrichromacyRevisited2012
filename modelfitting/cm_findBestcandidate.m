function bestcand = cm_findBestcandidate(nsllh, candVectors, calcDistMethod)

%
%
% <Input>
%   nsllh          ... Sum of Negative LogLikelihood for each fitting
%   candVectors    ... candidates of models as vectors
%   calcDistMethod ... how ywhat you minimize in fitting procedure
%
% <Output>
%
%   bestcand    ... best candidate
%
%
%
%%
if ~exist('params','var')
    calcDistMethod = 'fminlike';
end


switch calcDistMethod
    
    case {'fminlike','fmcolike'}

       Inds = find(min(nsllh) == nsllh);
   
    case {'linear','prcdiff','prcd_log'}
        
       Inds = find(max(nsllh) == nsllh);
end

bestcand = candVectors(Inds(1),:);