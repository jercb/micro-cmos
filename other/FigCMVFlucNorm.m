close all
clearvars
olddev = load('3T-APS CMV-Luc.mat');
newdev = load('4T-APS CMV-Luc.mat');

newF0 = newdev.F0_id(2) - 1;
oldF0 = olddev.F0_id(2) - 1;

f1 = figure( 'Units', 'normalized', 'Position', [0.1 0.25 1 0.45] );

cell{1} = olddev.mean_of_mat4(oldF0+1:end);
cell{2} = newdev.mean_of_mat4(newF0+1:end);
sdcell{1} = olddev.std_of_mat4(oldF0+1:end);
sdcell{2} = newdev.std_of_mat4(newF0+1:end);

null{1} = olddev.mean_of_mat4(1:oldF0);
null{2} = newdev.mean_of_mat4(1:newF0);
sdnull{1} = olddev.std_of_mat4(1:oldF0);
sdnull{2} = newdev.std_of_mat4(1:newF0);

hTitle{1} = '3T-APS CMV-Luc average reading (Normalized)';
hTitle{2} = '4T-APS CMV-Luc average reading (Normalized)';

for ij = 1:2
    p2 = subplot(1,2,ij);
    
    withcell = cell{ij};
    nocell = null{ij};
    
    sdwithcell = sdcell{ij};
    sdnocell = sdnull{ij};
    
    withcell(isinf(withcell)) = [];
    nocell(isinf(nocell)) = [];
    
    plot(withcell, 'LineWidth', 3);
    hold on
    plot(nocell, 'LineWidth', 3);
    
    eb1 = errorbar(withcell, sdwithcell, 'Color', [0.7020 0.8784 1.0000]);
    eb2 = errorbar(nocell, sdnocell, 'Color', [0.9686 0.8039 0.7333]);
    uistack(eb1,'bottom')
    uistack(eb2,'bottom')
    set(get(get(eb1,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    set(get(get(eb2,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    
    legend({'with cells', 'no cell'})
    title(hTitle{ij})
    xlabel('Minutes')
    ylabel('Pixel Value (DN)')
    if ij == 1
        xlim([0 60])
        set(gca, 'XTick', 0:20:60)
        set(gca, 'XTickLabel', {'0', '1', '2', '3'})
    else
        xlim([0 80])
        set(gca, 'XTick', 0:20:80)
        set(gca, 'XTickLabel', {'0', '1', '2', '3', '4'})
    end
    
    set(gca,'FontSize', 24)
    set(gca,'LineWidth', 2)
    legend boxoff
    
    %set(p2, 'Position', [0.045+0.5*(1-mod(ij,2)) 0.6 0.42 0.35])
    set(p2, 'Position', [0.06+0.5*(1-mod(ij,2)) 0.6-0.44 0.42 0.745])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear cell null

f2 = figure( 'Units', 'normalized', 'Position', [0.1 0.25 1 0.45] );
cell{1} = olddev.normalized_Matrix(:,:,oldF0+1:end);
cell{2} = newdev.normalized_Matrix(:,:, newF0+1:end);

null{1} = olddev.normalized_Matrix(:,:,1:oldF0);
null{2} = newdev.normalized_Matrix(:,:, 1:newF0);

hTitle{1} = '3T-APS CMV-Luc Histogram (Normalized)';
hTitle{2} = '4T-APS CMV-Luc Histogram (Normalized)';

for ij = 1:2
    p3 = subplot(1,2,ij);
    
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
    
    xlim([-20 20])
    
    xlabel('Pixel Value (DN)')
    set(gca,'ytick',[])
    set(gca,'FontSize', 24)
    set(gca,'LineWidth', 2)
    legend boxoff
    
    %set(p3, 'Position', [0.045+0.5*(1-mod(ij,2)) 0.6-0.52 0.42 0.35])
    set(p3, 'Position', [0.06+0.5*(1-mod(ij,2)) 0.6-0.44 0.42 0.745])
    
    distText = sprintf(' Hellinger \n Distance \n = %0.4f', hellDist);
    annotation(f2,'textbox',...
        [0.3749+0.5043*(1-mod(ij,2)) 0.7305-0.03 0.0701 0.03889],...
        'String',{distText} , 'EdgeColor','none',...
        'FitBoxToText','on', 'FontSize', 24);
    %[0.3749+0.5043*(1-mod(ij,2)) 0.7305-0.43 0.0701 0.03889],...
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nFile = 4;
data_list = {'3T-APS\newlineCMV-Luc\newline(no cell)',...
    '3T-APS\newlineCMV-Luc\newline(with cells)',...
    '4T-APS\newlineCMV-Luc\newline(no cell)',...
    '4T-APS\newlineCMV-Luc\newline(with cells)'};

f3 = figure( 'Units', 'normalized', 'Position', [0.1 0.25 0.4 0.6] );
custCMap = colorGradient([0.8500 0.3250 0.0980], [0 0.4470 0.7410], 100);

data{1} = olddev.normalized_Matrix(:,:,1:oldF0);
data{2} = olddev.normalized_Matrix(:,:,oldF0+1:end);
data{3} = newdev.normalized_Matrix(:,:, 1:newF0);
data{4} = newdev.normalized_Matrix(:,:, newF0+1:end);

temp_hellinger = zeros(nFile, nFile);
for file_i = 1:nFile
    for file_j = 1:nFile
        if file_i < file_j
            cell = data{file_i};
            null = data{file_j};
            
            min_bin = min( min(cell(~isinf(cell))), min(null(~isinf(null))) );
            max_bin = max( max(cell(~isinf(cell))), max(null(~isinf(null))) );
            bin_step = (max_bin - min_bin) / 1000;
            
            bin = min_bin:bin_step:max_bin;
            cell_pdf = histcounts(cell, bin);
            null_pdf = histcounts(null, bin);
            temp_hellinger(file_i, file_j) = ...
                sqrt(sum((sqrt(null_pdf/sum(null_pdf)) ...
                - sqrt(cell_pdf/sum(cell_pdf))).^2)) ./ sqrt(2);
        end
    end
end

data_hellinger = temp_hellinger + temp_hellinger';
all_hellinger = data_hellinger + data_hellinger';

imagesc(data_hellinger, [0 1])

textStrings = num2str(data_hellinger(:), '%0.4f');
textStrings = strtrim(cellstr(textStrings));
[x, y] = meshgrid(1:nFile, 1:nFile);
hStrings = text(x(:), y(:), textStrings(:),...
    'HorizontalAlignment', 'center', 'FontSize', 20);
title('Pairwise Hellinger Distances (Normalized)');

set(gca, 'xtick', 1:nFile);
set(gca, 'xticklabel', data_list);
set(gca, 'ytick', 1:nFile);
set(gca, 'yticklabel', data_list);
set(gca, 'FontSize', 20)
colormap(custCMap)
set(gca, 'Position', [0.2051    0.1544    0.7299    0.7706])

%blue [0 0.4470 0.7410]
%orange [0.8500 0.3250 0.0980]

