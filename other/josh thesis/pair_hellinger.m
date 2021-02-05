mat2plot = {'all\_normal\_matrix', 'wofilter\_matrix',...
    'wfilter\_matrix', 'normalized\_Matrix', 'diff\_Matrix'};
data_list = {'F\_A1', 'F\_A2a', 'F\_A2b', 'F\_A3a', 'F\_A3b', 'F\_A4a', 'F\_A4b',...
    'F\_B1', 'F\_B2', 'F\_B3', 'F\_B4a', 'F\_B4b', 'F\_B4c'};

data = {};

fileList = dir(fullfile('mat','*.mat'));
nFile = size(fileList, 1);

all_hellinger = zeros(nFile, nFile, 5);

for mati = 1:5
    for file_k = 1:nFile
        file2load1 = fileList(file_k).name;
        load(fullfile('mat', file2load1))
        extract_data
        switch mati
            case {1}
                data{file_k} = all_normal_matrix(:);
            case {2}
                data{file_k} = wofilter_matrix(:);
            case {3}
                data{file_k} = wfilter_matrix(:);
            case {4}
                data{file_k} = normalized_Matrix(:);
            case {5}
                data{file_k} = diff_Matrix(:);
        end
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
    all_hellinger(:, :, mati) = data_hellinger + data_hellinger';
    f1 = figure( 'Units', 'normalized', 'Position', [0.1 0.25 1 1] );
    imagesc(data_hellinger, [0 1])
    colorbar
    
    % Put numbers in confusion heatmap
    % https://stackoverflow.com/questions/3942892/
    % how-do-i-visualize-a-matrix-with-colors-and-values-displayed
    % Create strings from the matrix values, remove any space padding
    textStrings = num2str(data_hellinger(:), '%0.2f');
    textStrings = strtrim(cellstr(textStrings));
    % Create x and y coordinates for the strings
    [x, y] = meshgrid(1:nFile, 1:nFile);
    % Plot the strings
    hStrings = text(x(:), y(:), textStrings(:),...
        'HorizontalAlignment', 'center', 'FontSize', 14);
    title(mat2plot{mati});
    xticks(1:13);
    xticklabels(data_list);
    yticks(1:13);
    yticklabels(data_list);
    
    saveas(f1, [num2str(mati),'.png']);
end