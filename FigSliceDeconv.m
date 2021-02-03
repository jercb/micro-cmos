clearvars
% close all

loadList = {'3T-APS-CMV-Luc.mat', '3T-APS-CMV-Luc.mat',...
    '4T-APS-CMV-Luc.mat','4T-APS-CMV-Luc.mat'};

plot_title1 = {'Previous device no cell', 'Previous device with cell', ...
    'New device no cell',  'Previous device with cell'};

f1 = figure( 'Units', 'normalized', 'Position', [0.1 0.25 1 0.6] );

for i = 1:4
    subplot(1,4,i)
    curMat = load(loadList{i}, 'diff_Matrix', 'F0_id');
    F0 = curMat.F0_id(2) - 1;
    
    data_adj1 = curMat.diff_Matrix;
    data_adj1(:, 39:40,:) = [];
    data_adj1(32, :,:) = [];
    
    if mod(i,2) == 1
        image1 = mean(data_adj1(:,:,1:F0), 3);
    else
        image1 = mean(data_adj1(:,:,F0+1:end), 3);
    end

    
    INITPSF = ones(5,5);
    [J ~] = deconvblind(image1,INITPSF,50);%,10*sqrt(V),WT);
    
    
    minVal1 = prctile(data_adj1(:), 2.5);
%     minVal1 = min(data_adj1(:));
    
    maxVal1 = prctile(data_adj1(:), 97.5);
%     maxVal1 = max(data_adj1(:));
    
    J = J./(maxVal1-minVal1);
    
    image_plot = flipud(rot90(J));
    imagesc(image_plot, [-1,4]);
    colorbar
    set(gca,'XDir','reverse','YDir','normal')
    title([plot_title1{i}])
    colormap (jet);
    %colorbar
    axis off
    set(gca,'FontSize', 14)
    %     set(gca, 'Position', [0.01+0.5*(1-mod(i,2)) 0.52-0.48*(i>2) 0.44 0.405])
end