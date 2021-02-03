clearvars
close all

loadList = {'3T-APS CMV-Luc.mat', '4T-APS CMV-Luc.mat',...
    '3T-APS CMV-Luc.mat', '4T-APS CMV-Luc.mat'};

smp = [25, 25, 130, 130];

plot_title1 = {'3T-APS w/o cell', '4T-APS w/o cell', ...
    '3T-APS w/ cell',  '4T-APS w/ cell'};

f1 = figure( 'Units', 'normalized', 'Position', [0.1 0.25 1 0.6] );

for i = 1:4
    subplot(2,2,i)
    curMat = load(loadList{i}, 'diff_Matrix');
  
    data_adj1 = curMat.diff_Matrix;
    data_adj1(:, 39:40,:) = [];
    sample_frame = smp(i);
    
    %minVal1 = prctile(data_adj1(:), 2.5)
    %minVal1 = min(data_adj1(:))
    
    %maxVal1 = prctile(data_adj1(:), 97.5)
    %maxVal1 = max(data_adj1(:))
    
    image1 = data_adj1(:,:,sample_frame);
    image1 = rot90(image1);
    imagesc(image1, [-50,130]);
    set(gca,'XDir','reverse')
    title([plot_title1{i}])
    colormap (jet);
    %colorbar
    axis off
    set(gca,'FontSize', 20)
    set(gca, 'Position', [0.01+0.5*(1-mod(i,2)) 0.52-0.48*(i>2) 0.48 0.405])
end