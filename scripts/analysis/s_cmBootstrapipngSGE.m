% s_cmBootstrapipngSGE.m
%
% This script draws figure 2AB in the paper
%  'Human Color Sensitivity: Trichromacy Revisited"
%  by Horiguchi, Winawer, Dougherty and Wandell.'
%
% compute with bootstrapping procedure to prepare data for Fig 3ABC, Fig 5,
% Fig 6, Fig S2, Fig S3 and Fig S6 
%
% see also cm_ConditionPrepforBootstrapipngSGE.m and cm_RunBootstrappingSGC.m
%
% HH (c) Vista lab Oct 2012. 
%
%
clear all; home

%% for test run
sgeflag = 0;
fovflag  = 1; Sub  = 1;   NMech  = 3;  corflag  = 1; coneflag = 1;
nBoot         = 1;
ResampleRatio = 1;
nCalc         = 1;
rept = round(nBoot ./ nCalc);


%%
errInd = 1;
for sind = Sub
    
    for mInd = 1:length(NMech)
        
        [methodTag, ~, ~, ~, subtag] = cm_dataTagSwitcher(sind, NMech(mInd), fovflag, corflag, coneflag);
        
        for tag = 1:rept
                       
            jobname = sprintf('%sM%sAc%dRept%1.0f',subtag, methodTag,corflag,tag);
            
            %% run sge
            sge_command = 'cm_mechfitBS(sind, NMech(mInd), fovflag, corflag, coneflag, nCalc, ResampleRatio, tag);';
            
            if sgeflag
                try
                    sgerun(sge_command,jobname,1);
                catch
                    disp('The job name already exists.')                   
                    OverlappedCommand{errInd} = jobname;
                    errInd   = errInd + 1;
                end
            else
                eval(sge_command);
            end
        end 
    end
end
