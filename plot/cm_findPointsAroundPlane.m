function inds = cm_findPointsAroundPlane(xaxis,yaxis,stimPoint,threshold)
%
% inds = cm_findPointsAroundPlane(xaxis,yaxis,stimPoint,threshold)
% 
% To distingush a measured point is close enough to a 2D plane you set in 4D.
%
% 
%%
if ~exist('threshold','var'), threshold = 0.05; end


stimDim = size(stimPoint, 1);
nPoints = size(stimPoint, 2);

xaxis = sub_axischech(xaxis,stimDim);
yaxis = sub_axischech(yaxis,stimDim);

inds = zeros(1,nPoints);

for ii = 1:nPoints
    
    s = stimPoint(:,ii);
    
    A = [xaxis(:) yaxis(:)];
    
    d = pinv(A) * s;
    
    V = norm(s - A*d) ./ norm(s);
    
    if length(threshold) == 1 
       inds(ii) = V < threshold;
    elseif length(threshold) == 2
       inds(ii) = threshold(1) <= V & V < threshold(2);
    end
    
end

end

%%
function axis = sub_axischech(axis,stimDim)

if length(axis) ~= stimDim
        axinds = axis;
        axis = zeros(1,stimDim);
        axis(axinds) = 1;
end
end

