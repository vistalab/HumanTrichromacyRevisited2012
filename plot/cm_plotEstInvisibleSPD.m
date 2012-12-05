function f = cm_plotEstInvisibleSPD(InvDirTriModel, subInds, ConfInt, fovflag, StimAmp, fillflag)
% f = cm_plotEstInvisibleSPD(InvDirTriModel, subInds, ConfInt, fovflag, StimAmp, fillflag)
% 
% This function plots estimated invisible stimlus by Trichromacy model
% (Figure 3A). Main input 'InvDirTriModel' will be acquired by
% cm_InvDirTriBstRes.m
%
% <Input>
%   InvDirTriModel ... Invisible stimulus direction with Trichromacy model 
%   subInds        ... which subject
%   ConfInt        ... confidence interval
%   fovflag        ... fovea or periphery
%   StimAmp        ... stimulus percent amplitude, default is 10.
%   fillflag       ... Fill an area of confidence interval or not. 
%
% <Output>
%   f              ... figure hundle
%
% see also s_PNAS_figure3ABC.m and cm_InvDirTRiBstRes.m
%      
% HH (c) Vista lab Oct 2012. 
%
%% prep
if ~exist('fillflag','var') || isempty(fillflag)
    fillflag = 1;
end

if ~exist('subInds','var') || isempty(subInds)
    subInds = 1;
end

if ~exist('ConfInt','var') || isempty(ConfInt)
    ConfInt = 80;
end

if ~exist('StimAmp','var') || isempty(StimAmp)
    StimAmp = 10;
end

% load spectral power distribution of pigment-isolated stimuli
tmp = load('psychdataforPNAS');
if fovflag
    stimSPD = tmp.FOVstimSPD  * StimAmp; 
else
    stimSPD = tmp.PERIstimSPD * StimAmp;
end
clear tmp;

wls = cm_getDefaultWls;
Ptile  = [(100-ConfInt)./2  100-(100-ConfInt)./2];

if fillflag
    LW     = [2 0.1 0.1];
    C      = [  1   1   1; 0.8 0.8 0.8; 0.5 0.5 0.5];
    EC     = [  0   0   0; 0.8 0.8 0.8; 0.5 0.5 0.5];
    Alpha  = [1, 0.5, 0.5];
    
else
    LW     = [2 2 2];
    C      = [0.2 0.2 0.2; 0.8 0.8 0.8; 0.5 0.5 0.5];
    EC     = [  0   0   0; 0.8 0.8 0.8; 0.5 0.5 0.5];
end

%% draw
f = figure;

for ii = 1:length(subInds)
    
        nullDs = InvDirTriModel{ii};
    nullDconfInt = prctile(nullDs',Ptile);
    
    SPD = stimSPD * nullDconfInt';
    
    if fillflag
            fillplotMinMax(wls,SPD',C(ii,:), Alpha(ii), EC(ii,:), LW(ii));
    else
        plot(wls,SPD(:,1),'Color',C(ii,:),'LineWidth',LW(ii));  hold on;
        plot(wls,SPD(:,2),'Color',C(ii,:),'LineWidth',LW(ii));
    end
    hold on; 
    
end

set(gca,'XTick',400:50:700,'YTick',-0.03:0.01:0.06,...
    'XTicklabel',{'400','','500','','600','','700',''},...
    'YTicklabel',{'','-0.02','','0','0.02','','0.04','','0.06'})
grid on
xlim(minmax(wls))

end
