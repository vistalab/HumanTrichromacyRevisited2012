function fillplotMinMax(x,y,c,Alpha,edgeColor,LW)

% fillplotMinMax(x,y,c,Alpha)
% 
% <Input>
% x ..... should be vector
% y ..... should be m x n matrix, n has same length of x.
% c ..... defines color, which should be 1 x 3 vector. Edge and face color is same. 
% Alpha . should be scolar, which ranges 0 to 1. if you don't define it, it
%         will be 1.
%
%
% Example
%
%  x = [1:10]
%  y = rand(5,10)
%  c = [.9 .9 .9]
%  fillplotMinMax(x,y,c)
%
% Copyright HH, Vista Lab, 2010
%
%%

if ~exist('Alpha','var'), Alpha = 1; end
if ~exist('c','var'),     c     = 'b'; end
if ~exist('edgeColor','var'),    edgeColor     =  c; end
if ~exist('LW','var'), LW = 2; end

X = [x fliplr(x)];
Y = [min(y) fliplr(max(y))];
h = patch(X,Y,c, 'edgeColor',edgeColor);
set(h,'facealpha',Alpha,'edgealpha',Alpha,'LineWidth',LW);

return