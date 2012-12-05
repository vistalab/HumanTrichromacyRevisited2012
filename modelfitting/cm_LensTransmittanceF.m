function [lensTrans, den_lens] = cm_LensTransmittanceF(lensTransmitttanceFactor,defalut_den_lens, defalut_den_lens2, source)

%%
%  [lensTrans, den_lens] = ...
%  cm_LensTransmittanceF(lensTransmitttanceFactor,defalut_den_lens, defalut_den_lens2, source)
%
% This is another version of cm_LensTransmittance to avoid load basis
% function again and agian for bootstrapping.
% See cm_LensTransmittance.
%
%
%
% copy right HH, vistalab 2011

if ~exist('lensTransmitttanceFactor','var') || isempty('lensTransmitttanceFactor'), help cm_LensTransmittanceF; return; end
if ~exist('defalut_den_lens2','var') || isempty('defalut_den_lens2'), defalut_den_lens2 = []; end
if ~exist('source','var'), source = 'stockman'; end

switch source
    
    case 'stockmanF'
        den_lens = defalut_den_lens * 1;
        
    case {'stockman1','stockman'};
        den_lens = defalut_den_lens * lensTransmitttanceFactor;
        
    case {'two_stockman','stock2','stockman2'}
        den_lens = defalut_den_lens * lensTransmitttanceFactor +defalut_den_lens2;
    
    case {'Savage','Linear'} % Savage et al. 1993
        den_lens = lensTransmitttanceFactor * 10.^(5.543-(0.013439 .* cm_getDefaultWls'));
    
    otherwise
        error('!')
end

lensTrans = 10.^(-den_lens)';

return