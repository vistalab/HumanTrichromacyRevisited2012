function cm_plotModelErrorAlongZlength_Raw(zlength, medianModelError)
%
%
%
%
%
%
%%
FovInds  = [2 4];
PeriInds = [1 3 5];

C = [1 0 0; 1 0 0; 0 1 0; 0 1 0 ; 0 0 1];


%% Fovea 
subplot(1,2,1)

for ii = FovInds    
    x = zlength{ii};
    y = medianModelError{ii};    
    h = plot(x, y,'o');
    set(h,'Color',C(ii,:),'MarkerFace',C(ii,:));
    hold on    
end
ylim([-1 6]);
legend({'S1','S2'},'Location','NorthWest')
xlabel('length of z-direction')
ylabel('model error index')
title('Fovea')

%% Periphery
subplot(1,2,2)

for ii = PeriInds    
    x = zlength{ii};
    y = medianModelError{ii};    
    h = plot(x, y,'o');
    set(h,'Color',C(ii,:),'MarkerFace',C(ii,:));
    hold on    
end 
ylim([-1 6]);
legend({'S1','S2','S2'},'Location','NorthWest')
xlabel('length of z-direction')
ylabel('model error index')
title('Periphery')

