function [StimDir dpT] = cm_makeStimDirFromPsychdata(Psychdata)

%
% <Input>
%   Psychdata ... n x m matrix, n is number of color axis, m is num of
%   psych trial.
%
% <Output>
%   StimDir   ... n x m matrix, same as Psychdata
%
%
% C) Vistalab 2011 HH
%%
nDP = size(Psychdata,2); % number of datapoints

for ii = 1:nDP
    dp = Psychdata(:,ii);
    dpT(ii) = norm(dp);
    StimDir(:,ii) = dp ./ dpT(ii);
end
    
