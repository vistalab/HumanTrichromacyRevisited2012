function foldername = cm_definefolderforSaveSGEresults(subinds, methodTag, fovflag, corflag, ResampleRatio, condname)
% foldername = ...
%     cm_definefolderforSaveSGEresults(subinds, methodTag, fovflag, corflag, ResampleRatio, condname)
%
% This function defines a folder to store the bootstrapped results. If the
% folder doesn't exist, the function will make it. The home path is defiend
% by cm_defaultPathforSaveSGEresults.m 
% 
% <Input>
%       subinds         ... which subject
%       methodTag       ... name of analysis
%       fovflag         ... 1 is fovea, 0 is periphery
%       corflag         ... 1 is Correct the model for pigment density
%       ResampleRatio   ... ratio of resampling (from 0 to 1)
%
% <Output>
%       foldername      ... folder name (char)
%
% see also cm_defaultPathforSaveSGEresults.m and cm_mechfitBS.m
%
% HH (c) Vista lab Oct 2012. 
%
%%
if ~exist('condname','var') || isempty(condname)
    condname =[];
end

path        = cm_defaultPathforSaveSGEresults(condname);
AnaName     = sprintf('s%dM%sF%dC%dR%d',subinds, methodTag, fovflag, corflag, ResampleRatio*100);
foldername  = fullfile(path,AnaName);

if ~exist(foldername,'dir'), mkdir(foldername); end
