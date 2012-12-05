function OverlappedCommand = cm_RunBootstrappingSGC(bstparams, sgeflag, nCal1t)
% OverlappedCommand = cm_RunBootstrappingSGC(bstparams, sgeflag)
%
% This function sends SGE command for bootstrapping procedures in a PNAS
% paper 'Human Color Sensitivity: Trichromacy Revisited"
%  by Horiguchi, Winawer, Dougherty and Wandell.'
%
% <Input>
%   bstParams [struct]  ... parameters for bootstarapping analysis 
%       Fov             ... 1 is fovea, 0 is periphery
%       Sub             ... which subject
%       NMech           ... number of mechanisms
%       Cor             ... 1 is Correct the model for pigment density
%       Cone            ... 0 indicates allow a 4th, non-cone, photopigment contribution.
%       nBoot           ... number of bootstrapping process
%       ResampleRatio   ... ratio of resampling (from 0 to 1)
%
%   sgeflag ... use Sun Grid Engine or not (logical)
%   nCal1t  ... number of calculation one time (default is 50)
%
% <Output>
%   OverlappedCommand   ... sge commands already excuted
%  
%   Main results will be saved at the folder defined by two m-functions;
%   cm_definefolderforSaveSGEresults.m
%   cm_defaultPathforSaveSGEresults.m
%
%
% Example:
%
% figname = 'fig6'; % prep params for figure 3
% sgeflag = 0;      % run without sge
% nCal1t  = 1;      %
% bstparams = cm_ConditionPrepforBootstrapipngSGE(figname);
%
% bstparams.nBoot = 1;
% ORCommand = cm_RunBootstrappingSGC(bstparams, sgeflag, nCal1t);
%
% see also cm_ConditionPrepforBootstrapipngSGE.m and s_cmBootstrapipngSGE.m
%
% HH (c) Vista lab Oct 2012. 
%
%% set params
 
if ~exist('bstparams','var')
   help cm_RunBootstrappingSGC
   return
end

if ~exist('nCal1t','var') || isempty(nCal1t)
   nCal1t = 50;
end

% unpack params
Fov             = bstparams.Fov;
Sub             = bstparams.Sub;
NMech           = bstparams.NMech;
Cor             = bstparams.Cor;
coneflag        = bstparams.Cone;
nBoot           = bstparams.nBoot;
ResampleRatio   = bstparams.ResampleRatio;

rept            = round(nBoot ./ nCal1t);

%% main loop

errInd = 1; OverlappedCommand = {};

for corInd = 1:length(Cor)
    
    corflag = Cor(corInd);
    
    for fovInd = 1:length(Fov)
        
        fovflag = Fov(fovInd);
        
        for sind = Sub
            
            if ~(sind == 3 && fovflag == true) % S3 foveal data doesn't exist
                
                for mInd = 1:length(NMech)
                    
                    % get tag for jobname
                    [methodTag, ~, ~, ~, subtag] = cm_dataTagSwitcher(sind, NMech(mInd), fovflag, corflag, coneflag);
                    
                    for tag = 1:rept
                        
                        % job name for sge
                        jobname = sprintf('hh%sM%sC%dRati%dRept%1.0f',subtag, methodTag,corflag,ResampleRatio*100,tag);
                        
                        %% run sge
                        
                        sge_command = 'cm_mechfitBS(sind, NMech(mInd), fovflag, corflag, coneflag, nCal1t, ResampleRatio, tag);';
                        
                        if sgeflag % with sge
                            
                            % send sge command
                            try
                                % knk tool box required
                                sgerun2(sge_command,jobname,1);
                            catch
                                disp('The job name already exists.')
                                OverlappedCommand{errInd} = jobname;
                                errInd   = errInd + 1;
                            end
                            
                        else % witount sge                            
                            % run 
                            eval(sge_command);
                        end
                    end
                end
            end
        end
    end
end
