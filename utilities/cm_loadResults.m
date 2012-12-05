function results = cm_loadResults(Tag,subinds, numMech, fovflag, corflag, coneflag)
% results = cm_loadResults(Tag,subinds, numMech, fovflag, corflag, coneflag)
%
% <Input>
%       Tag          ... which data
%       subinds      ... which subject
%       numMech      ... number of mechanisms
%       fovflag      ... 1 is fovea, 0 is periphery
%       corflag      ... 1 is Correct the model for pigment density
%       coneflag     ... 0 indicates allow a 4th, non-cone, photopigment contribution.
%
% <Output>
%       results      ... depends on which data were desided by Tab
%
% see cm_mechfitBS.m for the detail
%
% HH (c) Vista lab Oct 2012.
%
%%
switch Tag
    
    case 'seeds'
        
        try
            
            %% seeds for bootstrapping
            
            %% no correction for figure 6A and 3ABC
            %% Dichromacy fovea
            % S1, Dichromacy, fovea, no correction
            if     subinds == 1 && numMech == 2 ...
                    && fovflag == 1 && corflag == 0 && coneflag == 0
                
                % get data path
                path     = cm_defaultPathforSavefigure;
                Datapath = fullfile(path,'BstSeeds.mat');
                Data     = load(Datapath);
                params   = Data.BstSeeds.p2f1;
                
                % S2, Dichromacy, fovea, no correction
            elseif subinds == 2 && numMech == 2 ...
                    && fovflag == 1 && corflag == 0 && coneflag == 0
                
                path     = cm_defaultPathforSavefigure;
                Datapath = fullfile(path,'BstSeeds.mat');
                Data     = load(Datapath);
                params   = Data.BstSeeds.p2f2;
                
                %% Trichromacy fovea
                % S1, Trichromacy, fovea, no correction
            elseif subinds == 1 && numMech == 3 ...
                    && fovflag == 1 && corflag == 0 && coneflag == 0
                
                Figname = '2A.fig';
                Data    = cm_loadResultSub(Figname);
                params  = Data.params;
                
                % S2, Trichromacy, fovea, no correction
            elseif subinds == 2 && numMech == 3 ...
                    && fovflag == 1 && corflag == 0 && coneflag == 0
                Figname = '2B.fig';
                Data    = cm_loadResultSub(Figname);
                params  = Data.params;
                
                %% Tetrachromacy fovea
                % S1, Tetrachromacy, fovea, no correction
            elseif subinds == 1 && numMech == 4 ...
                    && fovflag == 1 && corflag == 0 && coneflag == 0
                
                % get data path
                path     = cm_defaultPathforSavefigure;
                Datapath = fullfile(path,'BstSeeds.mat');
                Data     = load(Datapath);
                params  = Data.BstSeeds.p4f1;
                
                % S2, Tetrachromacy, fovea, no correction
            elseif subinds == 2 && numMech == 4 ...
                    && fovflag == 1 && corflag == 0 && coneflag == 0
                
                path     = cm_defaultPathforSavefigure;
                Datapath = fullfile(path,'BstSeeds.mat');
                Data     = load(Datapath);
                params   = Data.BstSeeds.p4f2;
                
                %% no correction for figure 6B
                %% Dichromacy periphery
                % S1 Dichromacy, periphery, no correction
            elseif subinds == 1 && numMech == 2 ...
                    && fovflag == 0 && corflag == 0 && coneflag == 0
                
                % get data path
                path     = cm_defaultPathforSavefigure;
                Datapath = fullfile(path,'BstSeeds.mat');
                Data     = load(Datapath);
                params   = Data.BstSeeds.p2p1;
                
                % S2, Dichromacy, periphery, no correction
            elseif subinds == 2 && numMech == 2 ...
                    && fovflag == 0 && corflag == 0 && coneflag == 0
                
                path     = cm_defaultPathforSavefigure;
                Datapath = fullfile(path,'BstSeeds.mat');
                Data     = load(Datapath);
                params   = Data.BstSeeds.p2p2;
                
                % S3, Dichromacy, periphery, no correction
            elseif subinds == 3 && numMech == 2 ...
                    && fovflag == 0 && corflag == 0 && coneflag == 0
                
                path     = cm_defaultPathforSavefigure;
                Datapath = fullfile(path,'BstSeeds.mat');
                Data     = load(Datapath);
                params   = Data.BstSeeds.p2p3;
                
                %% Trichromacy periphery
                % S1, Trichromacy, periphery, no correction
            elseif subinds == 1 && numMech == 3 ...
                    && fovflag == 0 && corflag == 0 && coneflag == 0
                
                Figname = 'S4A.fig';
                Data    = cm_loadResultSub(Figname);
                params  = Data.params3;
                
                % S2, Trichromacy, periphery, no correction
            elseif subinds == 2 && numMech == 3 ...
                    && fovflag == 0 && corflag == 0 && coneflag == 0
                
                Figname = 'S4B.fig';
                Data    = cm_loadResultSub(Figname);
                params  = Data.params3;
                
                % S3, Trichromacy, periphery, no correction
            elseif subinds == 3 && numMech == 3 ...
                    && fovflag == 0 && corflag == 0 && coneflag == 0
                
                Figname = 'S5.fig';
                Data    = cm_loadResultSub(Figname);
                params  = Data.params3n;
                
                %% Tetrachromacy periphery
                % S1, Tetrachromacy, periphery, no correction
            elseif subinds == 1 && numMech == 4 ...
                    && fovflag == 0 && corflag == 0 && coneflag == 0
                
                Figname = 'S4A.fig';
                Data    = cm_loadResultSub(Figname);
                params  = Data.params4;
                
                
                % S2, Tetrachromacy, periphery, no correction
            elseif subinds == 2 && numMech == 4 ...
                    && fovflag == 0 && corflag == 0 && coneflag == 0
                
                Figname = 'S4B.fig';
                Data    = cm_loadResultSub(Figname);
                params  = Data.params4;
                
                % S3, Tetrachromacy, periphery, no correction
            elseif subinds == 3 && numMech == 4 ...
                    && fovflag == 0 && corflag == 0 && coneflag == 0
                
                path     = cm_defaultPathforSavefigure;
                Datapath = fullfile(path,'BstSeeds.mat');
                Data     = load(Datapath);
                params   = Data.BstSeeds.p4p3;
                
                %% correction for figure 5ABC
                
                % S1, Trichromacy, periphery, with correction
            elseif subinds == 1 && numMech == 3 ...
                    && fovflag == 0 && corflag == 1 && coneflag == 0
                
                Figname = '4A.fig';
                Data    = cm_loadResultSub(Figname);
                params  = Data.params3;
                
                %% correction for figure S6                
                % S2, Trichromacy, periphery, with correction
            elseif subinds == 2 && numMech == 3 ...
                    && fovflag == 0 && corflag == 1 && coneflag == 0
                
                Figname = '4B.fig';
                Data    = cm_loadResultSub(Figname);
                params  = Data.params3;
                                              
                % S3, Trichromacy, periphery, with correction
            elseif subinds == 3 && numMech == 3 ...
                    && fovflag == 0 && corflag == 1 && coneflag == 0
                
                Figname = 'S5.fig';
                Data    = cm_loadResultSub(Figname);
                params  = Data.params3;
                
                %% correction for figure 5D
                % S1, Trichromatic theory, fovea, with correction
            elseif subinds == 1 && numMech == 3 ...
                    && fovflag == 1 && corflag == 1 && coneflag == 1
                
                path     = cm_defaultPathforSavefigure;
                Datapath = fullfile(path,'BstSeeds.mat');
                Data     = load(Datapath);
                params   = Data.BstSeeds.pcf1;
                
                % S2, Trichromatic theory, fovea, with correction
            elseif subinds == 2 && numMech == 3 ...
                    && fovflag == 1 && corflag == 1 && coneflag == 1
                
                path     = cm_defaultPathforSavefigure;
                Datapath = fullfile(path,'BstSeeds.mat');
                Data     = load(Datapath);
                params   = Data.BstSeeds.pcf2;
                
                % S1, Trichromatic theory, periphery, with correction
            elseif subinds == 1 && numMech == 3 ...
                    && fovflag == 0 && corflag == 1 && coneflag == 1
                
                path     = cm_defaultPathforSavefigure;
                Datapath = fullfile(path,'BstSeeds.mat');
                Data     = load(Datapath);
                params   = Data.BstSeeds.pcp1;
                
                
                % S2, Trichromatic theory, periphery, with correction
            elseif subinds == 2 && numMech == 3 ...
                    && fovflag == 0 && corflag == 1 && coneflag == 1
                
                path     = cm_defaultPathforSavefigure;
                Datapath = fullfile(path,'BstSeeds.mat');
                Data     = load(Datapath);
                params   = Data.BstSeeds.pcp2;
                
                % S3, Trichromatic theory, periphery, with correction
            elseif subinds == 3 && numMech == 3 ...
                    && fovflag == 0 && corflag == 1 && coneflag == 1
                
                path     = cm_defaultPathforSavefigure;
                Datapath = fullfile(path,'BstSeeds.mat');
                Data     = load(Datapath);
                params   = Data.BstSeeds.pcp3;
                
            end
            
            % check the condition by eye
            disp   ('******************************')
            fprintf('\n Subject %d, Foveafla g%d  --  %s\n', subinds, fovflag, params.subtag);
            fprintf('\n NumMech %d OnlyConeflag %d  --  %s\n', numMech, coneflag, params.methodTag);
            fprintf('\n CorrectPigment %d -- StimDirFirst %1.3f %1.3f %1.3f %1.3f\n\n', corflag, params.StimDir(1,1), params.StimDir(2,1), params.StimDir(3,1), params.StimDir(4,1));
            disp   ('******************************')
             
            % seeds from Search fitting
            results = cm_findBestcandidate(params.sSumL, params.sVectors, params.calcDistMethod);            
            
        catch
            
            disp('Seed data does not exist. Run scripts before sge procedure. s_PNAS_figure***.m')
            disp('2A, 2B, S4A, S4B and S5, that includes Trichromacy model fits to threshold data without axis correction')
            disp('output is blank')
            results = [];
            
            return
        end
        
end