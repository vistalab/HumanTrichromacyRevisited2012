function Stdir = cm_findHoleEllispoid(Qmatrix,p)
%  Stdir = cm_findHallThreshEllispoid(Qmatrix,p)

if ~exist('p','var') || isempty(p), p = 2.5; end

numDim = size(Qmatrix,2);
seeds = zeros(1,numDim);

% options = optimset('Display','none','MaxFunEvals',10^5,'MaxIter',10^5,'TolFun',1e-15,'TolX',1e-15);

Stdir = fminsearch(@cm_findHoleEllispoid_sub, seeds, 0, Qmatrix, p);
Stdir = Stdir ./ norm(Stdir);

end 

function Sensitivity = cm_findHoleEllispoid_sub(Stdir, Qmatrix, p)

Stdir = Stdir ./ norm(Stdir);
Sensitivity = sum(abs(Qmatrix * Stdir').^p).^(1/p);

end
