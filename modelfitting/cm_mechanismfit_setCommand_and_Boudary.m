function [lsqcommand gppcommand paramlb paramub options] = cm_mechanismfit_setCommand_and_Boudary(params)
% [lsqcommand gppcommand paramlb paramub options] = cm_mechanismfit_setCommand_and_Boudary(params)
%
% This function gives commands for fitting procedure and boundaries (if
% necessary).
%
% see cm_mechanismfit_main.m because this is subfunction of it.
%
%
% copyright HH vistalab 2012.9
%
%% prep commands
switch params.calcDistMethod
    
    case 'fminlike'
        fitfuncname = 'fminsearch(@';
        lsqcommand2 = 'seeds, options, params';
        gppcommand2 = '(ModelVector, params)';
        Algorithm   = [];
        Disp        = 'none';
        MaxIter     = 10^5;
    case 'fmcolike'
        fitfuncname = 'fmincon(@';
        lsqcommand2 = 'seeds, [], [], [], [], paramslb, paramsub, [], options, params';
        gppcommand2 = '(ModelVector, params)';
        Algorithm   = 'interior-point';
        Disp        = 'none';
        MaxIter     = 10^4;
        
    otherwise
        error('check a field -calcDistMethod- in a struct -params-.')
end

lsqcommand1 = 'cm_VisMtxMultiFreq';
gppcommand1 = 'cm_estPredMulti';

options = optimset('Display',Disp,'MaxFunEvals',10^5,'MaxIter',MaxIter,'TolFun',1e-15,'TolX',1e-15,'Algorithm',Algorithm);

lsqcommand = sprintf('%s%s,%s)',fitfuncname, lsqcommand1,lsqcommand2);
gppcommand = sprintf('%s%s',gppcommand1, gppcommand2);

%% default boundaries just for the first fmincon fitting
%  (limited variables)

if isfield(params,'limitsensitivity') && params.limitsensitivity == true
    
    SLowLowB  = [ 0    0    0    0];
    SLowUppB  = [25   50   25  500];
    
    SMidLowB  = [    0      0    0    0];
    SMidUppB  = [0.001  0.001  200  300];
    
    SHigLowB  = [    0      0     0      0];
    SHigUppB  = [0.001  0.001   150  0.001];
    
else
    
    SLowLowB  = [ 0    0    0    0];
    SLowUppB  = [25   50   25  500];
    
    SMidLowB  = [ 0    0    0    0];
    SMidUppB  = [ 1    5  200  300];
    
    SHigLowB  = [ 0    0    0    0];
    SHigUppB  = [ 1    2  150   50];
       
end

if isfield(params,'limitmechanism') && params.limitmechanism == true
    
    Mech1LowB = [0.01  0.01   -1];
    Mech1UppB = [0.5    0.5 -0.1];
    
    Mech2LowB = [-0.5  -0.4  -0.5];
    Mech2UppB = [-0.1 -0.05  -0.1];
    
    Mech3LowB = [ 0.2 -0.5 -0.5];
    Mech3UppB = [ 0.8  0.5  0.5];
    
    Mech4LowB = [-1.2 -0.2 -0.2];
    Mech4UppB = [-0.8  0.2  0.2];
    
else
    
    Mech1LowB = [-5 -5 -5];
    Mech1UppB = [ 5  5  5];
    
    Mech2LowB = [-0.5  -0.5  -1];
    Mech2UppB = [ 0.6  -0.5   1];
    
    Mech3LowB = [ 0.2 -0.5 -0.5];
    Mech3UppB = [ 0.8  0.5  0.5];
    
    Mech4LowB = [-1.2 -0.5 -0.5];
    Mech4UppB = [-0.8  0.5  0.5];
    
end

%% organize bounadries with model which will run
switch lower(params.methodTag)
    %
    case '3x3x3'  % Sensitivity Matrix: 9 = 3 mech x 3 tempfreq, Mechanism Matrix: 9 = 3 mech x 2 variable
        paramlb = [SLowLowB(2:4) SMidLowB(2:4) SHigLowB(2:4)   Mech2LowB(1:2)   Mech3LowB(1:2)   Mech4LowB(1:2)];
        paramub = [SLowUppB(2:4) SMidUppB(2:4) SHigUppB(2:4)   Mech2UppB(1:2)   Mech3UppB(1:2)   Mech4UppB(1:2)];
        
    case '3x3x2'  % Sensitivity Matrix: 6 = 3 mech x 2 tempfreq, Mechanism Matrix: 9 = 3 mech x 2 variable
        paramlb = [SLowLowB(2:4) SMidLowB(2:4)                 Mech2LowB(1:2)   Mech3LowB(1:2)   Mech4LowB(1:2)];
        paramub = [SLowUppB(2:4) SMidUppB(2:4)                 Mech2UppB(1:2)   Mech3UppB(1:2)   Mech4UppB(1:2)];
        
    case '4x4x3'  % Sensitivity Matrix: 12 = 4 mech x 3 tempfreq, Mechanism Matrix: 12 = 4 mech x 3 variable
        paramlb = [SLowLowB SMidLowB SHigLowB                  Mech1LowB   Mech2LowB   Mech3LowB   Mech4LowB];
        paramub = [SLowUppB SMidUppB SHigUppB                  Mech1UppB   Mech2UppB   Mech3UppB   Mech4UppB];
        
    case '4x4x2'  % Sensitivity Matrix: 8 = 4 mech x 2 tempfreq, Mechanism Matrix: 12 = 4 mech x 3 variable
        paramlb = [SLowLowB SMidLowB                           Mech1LowB   Mech2LowB   Mech3LowB   Mech4LowB];
        paramub = [SLowUppB SMidUppB                           Mech1UppB   Mech2UppB   Mech3UppB   Mech4UppB];
        
    case '3x4x3'  % Sensitivity Matrix: 9 = 3 mech x 3 tempfreq, Mechanism Matrix: 9 = 3 mech x 3 variable
        paramlb = [SLowLowB(2:4) SMidLowB(2:4)  SHigLowB(2:4)              Mech2LowB  Mech3LowB  Mech4LowB];
        paramub = [SLowUppB(2:4) SMidUppB(2:4)  SHigUppB(2:4)              Mech2UppB  Mech3UppB  Mech4UppB];
        
    case '3x4x2'  % Sensitivity Matrix: 6 = 3 mech x 2 tempfreq, Mechanism Matrix: 9 = 3 mech x 3 variable
        paramlb = [SLowLowB(2:4) SMidLowB(2:4)                             Mech2LowB  Mech3LowB  Mech4LowB];
        paramub = [SLowUppB(2:4) SMidUppB(2:4)                             Mech2UppB  Mech3UppB  Mech4UppB];
        
    case '2x4x3'  % Sensitivity Matrix: 6 = 2 mech x 3 tempfreq, Mechanism Matrix: 6 = 2 mech x 3 variable
        paramlb = [SLowLowB(3:4) SMidLowB(3:4) SHigLowB(3:4)                          Mech3LowB   Mech4LowB];
        paramub = [SLowUppB(3:4) SMidUppB(3:4) SHigUppB(3:4)                          Mech3UppB   Mech4UppB];
        
    case '2x4x2'  % Sensitivity Matrix: 4 = 2 mech x 2 tempfreq, Mechanism Matrix: 6 = 2 mech x 3 variable
        paramlb = [SLowLowB(3:4) SMidLowB(3:4)                                        Mech3LowB   Mech4LowB];
        paramub = [SLowUppB(3:4) SMidUppB(3:4)                                        Mech3UppB   Mech4UppB];
        
    otherwise
        error('check params.methodTag. see also cm_dataTagSwitcher.m.')
end

end