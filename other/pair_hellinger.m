close all
clearvars
olddev = load('3T-APS CMV-Luc.mat');
newdev = load('4T-APS CMV-Luc.mat');
nFile = 4;

data_list = {'3T-APS\newlineCMV-Luc\newline(no cell)',...
    '3T-APS\newlineCMV-Luc\newline(with cells)',...
    '4T-APS\newlineCMV-Luc\newline(no cell)',...
    '4T-APS\newlineCMV-Luc\newline(with cells)'};

newF0 = newdev.F0_id(2) - 1;
oldF0 = olddev.F0_id(2) - 1;
f1 = figure( 'Units', 'normalized', 'Position', [0.1 0.25 1 0.6] );
custCMap = colorGradient([0.8500 0.3250 0.0980], [0 0.4470 0.7410], 100);

for ij = 1:2
    if ij == 1
        data{1} = olddev.diff_Matrix(:,:,1:oldF0);
        data{2} = olddev.diff_Matrix(:,:,oldF0+1:end);
        data{3} = newdev.diff_Matrix(:,:, 1:newF0);
        data{4} = newdev.diff_Matrix(:,:, newF0+1:end);
        ptitle = 'Difference';
    else
        data{1} = olddev.normalized_Matrix(:,:,1:oldF0);
        data{2} = olddev.normalized_Matrix(:,:,oldF0+1:end);
        data{3} = newdev.normalized_Matrix(:,:, 1:newF0);
        data{4} = newdev.normalized_Matrix(:,:, newF0+1:end);
        ptitle = 'Normalized';
    end
    
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
                temp_hellinger(file_i, file_j) = sqrt(sum((sqrt(null_pdf/sum(null_pdf)) ...
                    - sqrt(cell_pdf/sum(cell_pdf))).^2)) ./ sqrt(2);
            end
        end
    end
    
    data_hellinger = temp_hellinger + temp_hellinger';
    all_hellinger = data_hellinger + data_hellinger';
    
    subplot(1,2,ij)
    imagesc(data_hellinger, [0 1])
    
    textStrings = num2str(data_hellinger(:), '%0.4f');
    textStrings = strtrim(cellstr(textStrings));
    [x, y] = meshgrid(1:nFile, 1:nFile);
    hStrings = text(x(:), y(:), textStrings(:),...
        'HorizontalAlignment', 'center', 'FontSize', 24);
    title(ptitle);
    
    set(gca, 'xtick', 1:nFile);
    set(gca, 'xticklabel', data_list);
    set(gca, 'ytick', 1:nFile);
    set(gca, 'yticklabel', data_list);
    set(gca,'FontSize', 20)
    colormap(custCMap)
    
end