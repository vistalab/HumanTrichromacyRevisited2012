function path = cm_defaultPathforSavefigure
%
%
%
%%
% path = fullfile('~','PNASfigures');

path = fullfile('/','biac4','wandell','biac3','wandell7','hhiro','PNASfigures');

if ~exist(path,'dir')
   mkdir(path) 
end
