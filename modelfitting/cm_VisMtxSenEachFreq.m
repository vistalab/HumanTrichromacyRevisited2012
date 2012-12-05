function D = cm_VisMtxSenEachFreq(V, params)
% D = cm_VisMtxSenEachFreq(V, params)
% This is a subfunction of cm_VisMtxMultiFreq.m
%
%
%
%
%% 
switch  lower(params.methodTag)
    
    %% Trichromcy
    % for periphery data (three different freq)
    case {'3x3x3','3x4x3'} 
        D = zeros(4,4,3);
        T(:,:,1) = diag(V(1:3));
        T(:,:,2) = diag(V(4:6));
        T(:,:,3) = diag(V(7:9));
        D(2:4,2:4,:) = T;

    % for foveal data (two different freq)        
    case {'3x3x2','3x4x2'}
        D = zeros(4,4,2);
        D(:,:,1) = diag([0 V(1:3)]);
        D(:,:,2) = diag([0 V(4:6)]);
        
    %% Tetrachromacy         
    % for peripheral data (three different freq)
    case '4x4x3' 
        D = zeros(4,4,3);
        D(:,:,1) = diag(V(1:4));
        D(:,:,2) = diag(V(5:8));
        D(:,:,3) = diag(V(9:12));
        
    % for foveal data (two different freq)
    case '4x4x2'
        D = zeros(4,4,2);
        D(:,:,1) = diag(V(1:4));
        D(:,:,2) = diag(V(5:8));
        
    %% Dichromacy    
    % for peripheral data (three different freq)
    case '2x4x3' 
        D = zeros(4,4,3);
        T(:,:,1) = diag(V(1:2));
        T(:,:,2) = diag(V(3:4));
        T(:,:,3) = diag(V(5:6));
        D(3:4,3:4,:) = T;

    % for foveal data (three different freq)
    case '2x4x2' 
        D = zeros(4,4,2);
        T(:,:,1) = diag(V(1:2));
        T(:,:,2) = diag(V(3:4));
        D(3:4,3:4,:) = T;
        
    otherwise
end

end
