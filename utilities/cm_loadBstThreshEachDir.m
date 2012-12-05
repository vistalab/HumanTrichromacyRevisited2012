function [lbConf ubConf   allbootdata Thllh] = ...
    cm_loadBstThreshEachDir(subjectname,tempFreq, dataset, aveflag, slopeParam, dataAnalysisflag, calirev, dataset2, stimuliname, iteratename, ConfPerc)
%
%
% see also cm_pickup_bootstrap_discrminationData.m
%%
if ~exist('subjectname','var') || isempty(subjectname)
    subjectname = 'hiroshi';
    disp('use hiroshis dataset')
end

switch lower(subjectname)
    case 's1p', subjectname = 'hiroshi';
    case 's2p', subjectname = 'azusa';
    case 's3p', subjectname = 'hiromasa';
    case 's1f', subjectname = 'hiroshifov4';
    case 's2f', subjectname = 'azusafov4';
    otherwise
end

if ~exist('tempFreq','var') || isempty(tempFreq)
    tempFreq = 1;
    disp('use 1Hz dataset')
end

if ~exist('ConfPerc','var') || isempty(ConfPerc)
    ConfPerc = 80;
end

if length(tempFreq) ~= 1
    tempFreq = tempFreq(1);
    fprintf('[%s]:Pickup %d Hz data.\n', mfilename, tempFreq)
end

if ~exist('dataset','var') || isempty(dataset)
    dataset = 'all';
end

if  ~exist('dataset2','var') || isempty(dataset2)
    dataset2 = 'all';
end

if  ~exist('dataAnalysisflag','var') || isempty(dataAnalysisflag)
    dataAnalysisflag = false;
end

if ~exist('calirev','var') || isempty(calirev)
    
    calirev = eye(4);
    
    if (strcmp(subjectname,'hiroshi') && tempFreq == 20) || strcmp(subjectname,'hiromasa')
        calirev = cm_CalibrationRevise('pr715', 'pr650', subjectname);
    end
    
elseif strcmp(calirev,'melanoRodconvert')
    
    melanoRodconvertflag = true;
    
    % special case
    if (strcmp(subjectname,'hiroshi') && tempFreq == 20) || strcmp(subjectname,'hiromasa')
        preCal = 'pr650';
    else
        preCal = 'pr715';
    end
    
    calirev = cm_CalibrationRevise('pr715', preCal, subjectname, melanoRodconvertflag);
    
elseif strcmp(calirev,'halfpod')
    
    if (strcmp(subjectname,'hiroshi') && tempFreq == 20) || strcmp(subjectname,'hiromasa')
        preCal = 'pr650';
    else
        preCal = 'pr715';
    end
    calirev = cm_CalibrationRevise('pr715', preCal, subjectname,[],0.5);
    
elseif strcmp(calirev,'quarterpod')
    
    if (strcmp(subjectname,'hiroshi') && tempFreq == 20) || strcmp(subjectname,'hiromasa')
        preCal = 'pr650';
    else
        preCal = 'pr715';
    end
    calirev = cm_CalibrationRevise('pr715', preCal, subjectname,[],0.25);
    
elseif isstruct(calirev)
    
    if (strcmp(subjectname,'hiroshi') && tempFreq == 20) || strcmp(subjectname,'hiromasa')
        preCal = 'pr650';
    else
        preCal = 'pr715';
    end
    
    calirev = cm_CalibrationRevise('pr715', preCal, subjectname,[], calirev.pods, calirev.mac, calirev.lens, calirev.shift);

end

if ~exist('slopeParam','var') || slopeParam == 0;
    slopename = 'freeslope';
else
    slopename = sprintf('slope%1.1f',slopeParam);
end


if ~exist('aveflag','var')
    aveflag = false;
end


if tempFreq >= 1
    tempFreqName = sprintf('%dHz',tempFreq);
else
    tempFreqName = sprintf('%1.2fHz',tempFreq);
end

if aveflag == false
    avename = 'uni';
else
    avename = 'biave';
end

if ispc  % For Wandell's PC
    basePath = '\\red.stanford.edu\home\hhiro\PsychophysData\scripts\bootstrappedData';
else % On Linux
    if ismac % For Horiguchi's Mac
        basePath = '~/PsychophysData/scripts/bootstrappedData';
    else        
        basePath = '/home/hhiro/PsychophysData/scripts/bootstrappedData';
    end
end
datapathT = fullfile(basePath,subjectname,tempFreqName,slopename,avename);
datapathL = fullfile(basePath,subjectname,tempFreqName,'likelihood',avename);

%% collect organzized dataset

if ~exist('stimuliname','var') || isempty(stimuliname)
    [stimuliname holename] = cm_pickupDiscMeasureSub_getSubName(datapathT);
else
    
end

% thresholds calculated before
MeasuredThresh = []; lbConf = []; ubConf  = []; SlopeM = []; SlopeAve = []; SlopeAll = []; allbootdata = [];
for ii = 1:length(stimuliname)
    [tmp tmp1 tmp2 tmp3 tmp4 tmp5 tmp6 tmp7] = cm_loadDiscrimination_sub(stimuliname{ii},datapathT,[],aveflag,ConfPerc);
    MeasuredThresh  = [MeasuredThresh tmp];
    lbConf           = [lbConf tmp1];
    ubConf           = [ubConf tmp2];
    SlopeM          = [SlopeM tmp3];
    SlopeAve        = [SlopeAve tmp4];
    SlopeAll        = [SlopeAll tmp5];  
    allbootdata     = [allbootdata tmp7'];
end

%
MeasuredThreshI = []; Pt025i = []; Pt975i  = [];
if exist('iteratename','var')
    for ii = 1:length(iteratename)
        [tmp tmp1 tmp2] = cm_loadDiscrimination_sub(iteratename{ii},datapathT,[],aveflag,ConfPerc);
        MeasuredThreshI = [MeasuredThreshI tmp];
        Pt025i          = [Pt025i tmp1];
        Pt975i          = [Pt975i tmp2];
    end
end

% dataset for likelihood calc
for ii = 1:length(stimuliname)
    
    data = cm_loadDiscrimination_subL(stimuliname{ii},datapathL);
    
    for ij = 1:length(data)
        d.stimLevels = data{ij}(1,:); d.numCorrect  = data{ij}(2,:); d.history = median(d.stimLevels);
        analysis = ct_analyzeStaircaseRaw(d,'fixSlope',2,'fineBins',[0.001 1 1000]);
        tbs = abs(analysis.wy - 0.82);  indtb = find(min(tbs) == tbs);
        tmpth(ij) = analysis.wx(indtb(1));
    end
    
    if aveflag == false
 
        Thllh(2*(ii-1)+1)    = tmpth(1);
        Thllh(2*ii)          = tmpth(2);
    else
        
        Thllh(2*(ii-1)+1)    = tmpth;
        Thllh(2*ii)          = tmpth;
    end
    
    
end

%% integrate data
switch dataset2
    case 'all'
        lbConf      = [lbConf Pt025i];
        ubConf      = [ubConf Pt975i];
    case 'iterate'
        lbConf      = Pt025i;
        ubConf      = Pt975i;
end


%% data filtering and revision of calibration error

lbConf     = cm_Filtering_sub(lbConf,     dataset,  calirev);
ubConf     = cm_Filtering_sub(ubConf,     dataset,  calirev);


if aveflag == true
    lbConf = cm_double_sub(lbConf);
    ubConf = cm_double_sub(ubConf);
end


end


%%
function [Thresholds lbConf ubConf SlopeM SlopeA SlopeAll stimname allbootdata]= cm_loadDiscrimination_sub(stimname,datapath,holeflag,aveflag,ConfPerc)

if ~exist('holeflag','var') || isempty(holeflag), holeflag = false; end
if ~exist('ConfPerc','var') || isempty(ConfPerc), ConfPerc = 80; end

HalfWing = (100 - ConfPerc) ./ 2;
PrcConfInt = [HalfWing 100-HalfWing];

pF = 1 ./ 100;
tmp = load(sprintf('%s/%s',datapath,stimname));
nD = size(tmp.bootThreshRaw,2);

if holeflag == false
    
    bootRaw = tmp.bootThreshRaw' .*pF;
    
    try
        SlopeM  = median(tmp.bootSlopeRaw);
        SlopeA  = [tmp.analysisAve{1}.slope tmp.analysisAve{2}.slope];
        SlopeAll= tmp.bootSlopeRaw(:)';
    catch
        SlopeM  = [];
        SlopeA  = [];
        SlopeAll= [];
        %         fprintf('[%s]:%s is problably calicuated previously.\n',mfilename, stimname);
    end
    
else
    
    bootRaw = (tmp.maxAmpIsoPig * ones(1000,nD))' .*pF;
    SlopeM  = [];
    SlopeA  = [];
    SlopeAll= [];
end


ThreMed = median(bootRaw,2);

if size(ThreMed,1) ~= 2
    ThreMed = ThreMed(1,:);
    bootRaw = bootRaw(1,:);
end
pt95    = prctile(bootRaw',[PrcConfInt]);
nC = length(tmp.stimDirVectors);
a = reshape(cell2mat(tmp.stimDirVectors)',size(tmp.stimDirVectors{1},2),nC)';

if aveflag == false
    
    for ii = 1:nC
        b = a(ii,:)';
        b = b ./ norm(b);
        Thresholds(:,ii) = b * ThreMed(ii);
        pt95tmp          = b * pt95(:,ii)';
        if nargout > 1
            lbConf(:,ii)      = pt95tmp(:,1);
            ubConf(:,ii)      = pt95tmp(:,2);
        end
    end
    
    allbootdata = bootRaw;

else
    
    b = a(1,:)';
    b = b ./ norm(b);
    Thresholds = b * ThreMed;
    pt95tmp          = b * pt95;
    if nargout > 1
        lbConf      = pt95tmp(:,1);
        ubConf      = pt95tmp(:,2);
    end
    
    allbootdata = repmat(bootRaw,2,1);

end

end

%%
function [data stimdir stimname]= cm_loadDiscrimination_subL(stimname,datapath,holeflag)

if ~exist('holeflag','var') || isempty(holeflag), holeflag = false; end

pF = 1 ./ 100;
tmp = load(sprintf('%s/%s',datapath,stimname));
nD = length(tmp.data);

% if holeflag == false
% else
% end

for ii = 1:nD
    
    tmp.data{ii}(1,:) = tmp.data{ii}(1,:) .* pF;
    data{ii} = tmp.data{ii};
    stDir = tmp.stimDirVectors{ii}';
    stDir = stDir ./ norm(stDir);
    stimdir(:,ii) = stDir;
    
end

end
%%
function [stimuliname holestimname] = cm_pickupDiscMeasureSub_getSubName(datapath)

homedir = pwd;
cd(datapath)
d = dir; ind = 0; hind = 0;
for ii = 1:length(d)
    n = d(ii).name;
    if ~strcmp(n,'.') && ~strcmp(n,'..') && ~strcmp(n,'.DS_Store') && ~isempty(strfind(n,'.mat'))
        
        if isempty(strfind(n,'hole'))
            
            ind = ind + 1;
            stimuliname{ind} = n;
            
        else
            hind = hind + 1;
            holestimname{hind} = n;
            
        end
    end
end

if ~exist('stimuliname','var')
    disp('no file exists.')
    stimuliname = {};
end

if ~exist('holestimname','var')
    disp('no hole direction exists.')
    holestimname = {};
end

cd(homedir)

end

