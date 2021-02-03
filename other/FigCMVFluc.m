close all
clearvars

fig{1} = openfig('3T-APS-CMV-Luc-normalized-in.fig');
fig{2} = openfig('3T-APS-CMV-Luc-normalized-in-NO-CELLS.fig');

fig{3} = openfig('4T-APS-CMV-Luc-normalized-in.fig');
fig{4} = openfig('4T-APS-CMV-Luc-normalized-in-NO-CELLS.fig');

f1 = figure( 'Units', 'normalized', 'Position', [0.1 0.25 1 1] );
for i = 1:2
    axObjs1 = fig{(2*i)-1}.Children;
    axObjs2 = fig{2*i}.Children;
    
    dataObjs1 = axObjs1(1).Children;
    dataObjs2 = axObjs2(1).Children;
    dataA1 = dataObjs1.YData;
    dataA2 = dataObjs2.YData;
    titleA = axObjs1(1).Title.String;
    
    dataObjs1 = axObjs1(2).Children;
    dataObjs2 = axObjs2(2).Children;
    dataB1 = dataObjs1.YData;
    dataB2 = dataObjs2.YData;
    titleB = axObjs1(2).Title.String;
    
    figure(f1)
    p1 = subplot(2,2,i);
    plot(dataB1, 'LineWidth', 3);
    hold on
    plot(dataB2, 'LineWidth', 3);
    lgd = legend({'with cells', 'no cell'});
    lgd.Location = 'best';
    legend boxoff
    title(titleB)
    xlabel('Minutes')
    ylabel('Pixel Value (DN)')
    if i == 1
        xlim([0 60])
        set(gca, 'XTick', 0:20:60)
        set(gca, 'XTickLabel', {'0', '1', '2', '3'})
    else
        xlim([0 80])
        set(gca, 'XTick', 0:20:80)
        set(gca, 'XTickLabel', {'0', '1', '2', '3', '4'})
    end
    %ylim([-1 1])
    set(p1, 'Position', [0.07+0.5*(i-1) 0.6 0.4 0.35])
    
    set(gca,'FontSize', 24)
    set(gca,'LineWidth', 2)
    
    figure(f1)
    p2 = subplot(2,2,i+2);
    plot(dataA1, 'LineWidth', 3);
    hold on
    plot(dataA2, 'LineWidth', 3);
    lgd = legend({'with cells', 'no cell'});
    lgd.Location = 'best';
    legend boxoff
    title(titleA)
    xlabel('Minutes')
    ylabel('Pixel Value (DN)')
    if i == 1
        xlim([0 60])
        set(gca, 'XTick', 0:20:60)
        set(gca, 'XTickLabel', {'0', '1', '2', '3'})
    else
        xlim([0 80])
        set(gca, 'XTick', 0:20:80)
        set(gca, 'XTickLabel', {'0', '1', '2', '3', '4'})
    end
    %ylim([-0.1 0.1])
    set(p2, 'Position', [0.07+0.5*(i-1) 0.6-0.52 0.4 0.35])
    
    set(gca,'FontSize', 24)
    set(gca,'LineWidth', 2)
end

clearvars
load('CMV Fluc.mat')
f1 = figure( 'Units', 'normalized', 'Position', [0.1 0.25 1 1] );

cell{1} = olddev_cell;
cell{2} = newdev_cell;
cell{3} = olddev_cell_norm;
cell{4} = newdev_cell_norm;

null{1} = olddev_nocell;
null{2} = newdev_nocell;
null{3} = olddev_nocell_norm;
null{4} = newdev_nocell_norm;

hTitle{1} = '3T-APS CMV-Luc Histogram (Difference)';
hTitle{2} = '4T-APS CMV-Luc Histogram (Difference)';
hTitle{3} = '3T-APS CMV-Luc Histogram (Normalized)';
hTitle{4} = '4T-APS CMV-Luc Histogram (Normalized)';

for ij = 1:4
    p2 = subplot(2,2,ij);
    
    withcell = cell{ij};
    nocell = null{ij};
    
    withcell(isinf(withcell)) = [];
    nocell(isinf(nocell)) = [];
    
    bin = min(min(withcell(:)), min(nocell(:))):5:max(max(withcell(:)),...
        max(nocell(:)));
    cell_hist = histogram(withcell, bin, 'EdgeColor', 'none', 'Normalization','pdf');
    cell_pdf = cell_hist.Values;
    hold on
    null_hist = histogram(nocell, bin, 'EdgeColor', 'none', 'Normalization','pdf');
    null_pdf = null_hist.Values;
    hellDist = sqrt(sum((sqrt(null_pdf/sum(null_pdf))...
        - sqrt(cell_pdf/sum(cell_pdf))).^2)) ./ sqrt(2);
    legend({'with cells', 'no cell'})
    title(hTitle{ij})
    
    if ij <=2 
        xlim([-100 100])
    else
        xlim([-20 20])
    end
    xlabel('Pixel Value (DN)')
    set(gca,'ytick',[])
    set(gca,'FontSize', 24)
    set(gca,'LineWidth', 2)
    legend boxoff
    
    set(p2, 'Position', [0.03+0.5*(1-mod(ij,2)) 0.6-0.52*(ij>2) 0.45 0.35])
    
    distText = sprintf(' Hellinger \n Distance \n = %0.4f', hellDist);
    annotation(f1,'textbox',...
        [0.3749+0.5043*(1-mod(ij,2)) 0.7305-0.5*(ij>2) 0.0701 0.03889],...
        'String',{distText} , 'EdgeColor','none',...
        'FitBoxToText','on', 'FontSize', 24);
end
%blue [0 0.4470 0.7410]
%orange [0.8500 0.3250 0.0980]

% load('4T-APS-CMV-Luc-Raw.mat')
% extract_data
% newdev_diffMat = diff_Matrix;
% newdev_wfilter = wfilter_matrix;
% newdev_wofilter = wofilter_matrix;
% newdev_normMat = normalized_Matrix;
% newdev_cell = diff_Matrix(:,:, 85:end);
% newdev_nocell = diff_Matrix(:,:, 1:84);
%
% clearvars -except newdev_diffMat newdev_wfilter newdev_wofilter...
%     newdev_normMat newdev_cell newdev_nocell
%
% load('3T-APS-CMV-Luc-Raw.mat')
% extract_data
% olddev_diffMat = diff_Matrix;
% olddev_wfilter = wfilter_matrix;
% olddev_wofilter = wofilter_matrix;
% olddev_normMat = normalized_Matrix;
% olddev_cell = olddev_diffMat(:,:,113:end);
% olddev_nocell = olddev_diffMat(:,:,1:112);
%
% clearvars -except newdev_diffMat newdev_wfilter newdev_wofilter...
%     newdev_normMat newdev_cell newdev_nocell...
%     olddev_diffMat olddev_wfilter olddev_wofilter...
%     olddev_normMat olddev_cell olddev_nocell
