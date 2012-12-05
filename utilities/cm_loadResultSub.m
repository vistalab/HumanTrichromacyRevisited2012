function Data = cm_loadResultSub(Figname)
% Data = cm_loadResultSeedSub(Figname)
%
% This is subfunction of cm_loadResults.m. Load the model fitting results
% with full data set for bootstrapping analysis
%
% <Input>
%   Figname ... name of figure which has the model fitting results
%
% <Output>
%   Data    ... figure data
%
%
% See also cm_loadResults.m
%
% HH (c) Vista lab Oct 2012. 
% 
%% 
% get path for the results
path = cm_defaultPathforSavefigure;

% get figure path
figurepath = fullfile(path,Figname);

% get data
f    = open(figurepath);
Data = get(f,'UserData');
close(f)

end
