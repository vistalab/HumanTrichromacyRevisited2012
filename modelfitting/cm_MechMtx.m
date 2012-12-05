function M = cm_MechMtx(V, params)
%
% This is a subfunction of cm_VisMtxMultiFreq.m
%
M = ones(4,4);

switch  lower(params.methodTag)
    
    %% Trichromatic Theory (only cone pigment)
    
    % for periphery data (three different freq)
    case '3x3x3'  % M -6 D -3        
        M(1,:)   = 0; M(:,4) = 0;
        M(2,1:2) = V(10:11);
        M(3,2:3) = V(12:13);       
        M(4,2:3) = V(14:15);

    % for foveal data (two different freq)        
    case '3x3x2' 
        M(1,:)   = 0; M(:,4) = 0;
        M(2,1:2) = V(7:8);
        M(3,2:3) = V(9:10);       
        M(4,2:3) = V(11:12);
        
    %% Trichromacy
    
    % for periphery data (three different freq)
    case '3x4x3'        
        M(1,:)       = 0;
        M(2,[1 2 4]) = V(10:12); M(2,:) = M(2,:) ./ norm(M(2,:));       
        M(3,2:4) = V(13:15);     M(3,:) = M(3,:) ./ norm(M(3,:));
        M(4,2:4) = V(16:18);     M(4,:) = M(4,:) ./ norm(M(4,:));
    
    % for foveal data (two different freq)
    case '3x4x2'
        M(1,:)       = 0;
        M(2,[1 2 4]) = V(7:9);   M(2,:) = M(2,:) ./ norm(M(2,:)) * -1;       
        M(3,2:4) = V(10:12);     M(3,:) = M(3,:) ./ norm(M(3,:));
        M(4,2:4) = V(13:15);     M(4,:) = M(4,:) ./ norm(M(4,:));

    %% Tetrachromacy
    
    % for peripheral data (three different freq)
    case '4x4x3' 
        M(1,1:3) = V(13:15);        M(1,:) = M(1,:) ./ norm(M(1,:));
        M(2,[1 2 4]) = V(16:18);    M(2,:) = M(2,:) ./ norm(M(2,:));                                  
        M(3,2:4) = V(19:21);        M(3,:) = M(3,:) ./ norm(M(3,:));
        M(4,2:4) = V(22:24);        M(4,:) = M(4,:) ./ norm(M(4,:));

    % for foveal data (two different freq)
    case '4x4x2'
        M(1,1:3) = V(9:11);         M(1,:) = M(1,:) ./ norm(M(1,:));
        M(2,[1 2 4]) = V(12:14);    M(2,:) = M(2,:) ./ norm(M(2,:));                                  
        M(3,2:4) = V(15:17);        M(3,:) = M(3,:) ./ norm(M(3,:));
        M(4,2:4) = V(18:20);        M(4,:) = M(4,:) ./ norm(M(4,:));
    %% Dichromacy
    
    % for peripheral data (three different freq)
    case '2x4x3' 
        M(1:2,:)       = 0;
        M(3,2:4) = V(7:9);          M(3,:) = M(3,:) ./ norm(M(3,:));
        M(4,2:4) = V(10:12);        M(4,:) = M(4,:) ./ norm(M(4,:));
        
    % Dichromacy
    % for foveal data (three different freq)
    case '2x4x2'
        M(1:2,:)       = 0;
        M(3,2:4) = V(5:7);         M(3,:) = M(3,:) ./ norm(M(3,:));
        M(4,2:4) = V(8:10);        M(4,:) = M(4,:) ./ norm(M(4,:));
        
    otherwise
end

% for ii = 1:4
%     if any(M(ii,:))
%         M(ii,:) = M(ii,:) ./ norm(M(ii,:));
%     end
% end

end

