function btsparams = cm_ConditionPrepforBootstrapipngSGE(figname)
% btsparams = cm_ConditionPrepforBootstrapipngSGE(figname)
%
% prepare bootstrap anlysis conditions for Fig 3ABC, Fig 5, Fig 6, Fig S2 and Fig S6 
%
% <Input>
%   figname ... number of figure or figure name (scalar or char)
%               should be fig3, fig5abc, fig5d or fig6.
%               Analysis for figs2 and figs6 are included fig 3 and fig 5,
%               respectively.
%
%
% <Output>
%   btsparams [struct]  ... parameters for bootstarapping analysis 
%       Fov             ... 1 is fovea, 0 is periphery
%       Sub             ... which subject
%       NMech           ... number of mechanisms
%       Cor             ... 1 is Correct the model for pigment density
%       Cone            ... 0 indicates allow a 4th, non-cone, photopigment contribution.
%       nBoot           ... number of bootstrapping process
%       ResampleRatio   ... ratio of resampling (from 0 to 1)
%
% Example
%   figname = 'fig6';
%   btsparams = cm_ConditionPrepforBootstrapipngSGE(figname)
%   
% see also s_cmBootstrapipngSGE.m and cm_RunBootstrappingSGC.m
%
% HH (c) Vista lab Oct 2012. 
%
%%
if ~exist('figname', 'var')
    help cm_ConditionPrepforBootstrapipngSGE
    btsparams = [];
    return        
end

%% get parameters

switch lower(figname)
    
    case {3,'3','fig3','fig 3','3abc'}
        
        Fov     = 1;  
        Sub     = [1 2];
        NMech   = 3;
        Cor     = 0;
        Cone    = 0;
        nBoot   = 1000;        
        ResampleRatio = 0.9;
        
    case {5}
        
        disp('run the bootstrapping procedure for Fig 5abc and Fig 5d separately.')
        
    case {'5abc','fig5abc','fig 5abc'}
                
        Fov     = 0;  
        Sub     = [1 2 3];
        NMech   = 3;
        Cor     = 0;
        Cone    = 0;
        nBoot   = 1000;        
        ResampleRatio = 0.9;
    
    case {'5d','fig5d','fig 5d'}
                
        Fov     = [0 1];  
        Sub     = [1 2 3];
        NMech   = 3;
        Cor     = 1;
        Cone    = 1;
        nBoot   = 10000;        
        ResampleRatio = 1;
    
    case {'s6','figs6','fig s6'}
        
        disp('run the bootstrapping procedure for Fig 5. The condition includes the dataset of figure S6')

    case {6,'6','fig6','fig 6'}
        
        Fov     = [0 1];  
        Sub     = [1 2 3];
        NMech   = [2 3 4];
        Cor     = 0; 
        Cone    = 0;
        nBoot   = 10000;        
        ResampleRatio = 1;

    case {'s2','figs2','fig s2'}
        
        disp('run the bootstrapping procedure for Fig 3. The condition includes the dataset of figure S2')
        
    case 'fig6f3'
        
        Fov     = [1];  
        Sub     = [1 2];
        NMech   = [3];
        Cor     = 0; 
        Cone    = 0;
        nBoot   = 10000;        
        ResampleRatio = 1;
    
    case 'fig6f4'
        
        Fov     = [1];  
        Sub     = [1 2];
        NMech   = [4];
        Cor     = 0; 
        Cone    = 0;
        nBoot   = 10000;        
        ResampleRatio = 1;
        
    case 'fig6p3'
        
        Fov     = [0];  
        Sub     = [1 2 3];
        NMech   = [3];
        Cor     = 0; 
        Cone    = 0;
        nBoot   = 10000;        
        ResampleRatio = 1;
    
    case 'fig6p4'
        
        Fov     = [0];  
        Sub     = [1 2 3];
        NMech   = [4];
        Cor     = 0; 
        Cone    = 0;
        nBoot   = 10000;        
        ResampleRatio = 1;
    
    case 'fig6r'
        
        Fov     = [0 1];  
        Sub     = [1 2 3];
        NMech   = [2];
        Cor     = 0; 
        Cone    = 0;
        nBoot   = 10000;        
        ResampleRatio = 1;    
        
    otherwise
        
        disp('please input correct name.')
        help cm_ConditionPrepforBootstrapipngSGE
        btsparams = [];
        return
end

%% packing variables into struct

btsparams = struct('Fov',Fov,'Sub',Sub,'NMech',NMech,'Cor',Cor,'Cone',Cone,'nBoot',nBoot,'ResampleRatio',ResampleRatio);


end
