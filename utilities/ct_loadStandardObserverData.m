function [LMSperipheralFunc LMSfovealfunc] = ct_loadStandardObserverData
% [LMSperipheralFunc LMSfovealfunc] = ct_LoadStandardObserverData
% 
% load standard observer's LMSfunction
% 
% (c) Stanford VISTA Team (HH)
%%
fprintf('%s: load default values; Stockman standard LMS observer\n',mfilename);

% peripheral data (10deg)
tmp1 = load('stockman10deg2000');
LMSperipheralFunc = tmp1.data(1:341,:);

% Foveal data
tmp2 = load('stockman2000');
LMSfovealfunc = tmp2.data(1:341,:);

%% for checking
% LMS specifications for energy-based calculations
% figure; wave = 390:730;
% plot(wave,LMSpfunc, wave,LMScfunc)

end
