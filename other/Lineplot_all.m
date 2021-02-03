CMV = [];
NegCtrl = [];
f1 = figure();
f2 = figure();

for i  = 1:7
    load(['mat/F_A', num2str(i), '.mat'])
    extract_data
    mean_of_mat3 = squeeze(mean(diff_Matrix, [1 2]));
    std_of_mat3 = squeeze(std(diff_Matrix, 0, [1 2])) ./ sqrt(size(diff_Matrix, 1) * size(diff_Matrix,2));
    
    mean_of_mat4 = [];
    std_of_mat4 = [];
    for fileInd = 1:size(normalized_Matrix, 3)
        %get matrix to plot
        curMat4 = normalized_Matrix(:,:, fileInd); %curMat gets the x,y of each frame
        mean_of_mat4(fileInd) = mean(curMat4(isfinite(curMat4)), 'all'); %sum of Mat gets the total sum of x and y per curMat
        std_of_mat4(fileInd) = nanstd(curMat4(isfinite(curMat4)), 0, 'all')./sqrt(numel(curMat4(isfinite(curMat4))));
    end
    
    figure(f1)
    pl = plot(mean_of_mat3, 'd');%, 'LineWidth', 3,'Color',[0.96 0.71 0.15]);
    hold on
    %errorbar(mean_of_mat3, std_of_mat3, 'Color', [0.96, 0.88, 0.70]);
    %uistack(pl,'top')
    
    figure(f2)
    pl = plot(mean_of_mat4, 'x');%,'LineWidth', 3, 'Color', [0.96 0.71 0.15]);
    hold on
    %errorbar(mean_of_mat4, std_of_mat4, 'Color', [0.96, 0.88, 0.70]);
    %uistack(pl,'top')
end

for i  = 1:6
    load(['mat/F_B', num2str(i), '.mat'])
    extract_data
    mean_of_mat3 = squeeze(mean(diff_Matrix, [1 2]));
    std_of_mat3 = squeeze(std(diff_Matrix, 0, [1 2])) ./ sqrt(size(diff_Matrix, 1) * size(diff_Matrix,2));
    
    mean_of_mat4 = [];
    std_of_mat4 = [];
    for fileInd = 1:size(normalized_Matrix, 3)
        %get matrix to plot
        curMat4 = normalized_Matrix(:,:, fileInd); %curMat gets the x,y of each frame
        mean_of_mat4(fileInd) = mean(curMat4(isfinite(curMat4)), 'all'); %sum of Mat gets the total sum of x and y per curMat
        std_of_mat4(fileInd) = nanstd(curMat4(isfinite(curMat4)), 0, 'all')./sqrt(numel(curMat4(isfinite(curMat4))));
    end
    
    figure(f1)
    pl = plot(mean_of_mat3, '+');%, 'LineWidth', 3,'Color',[0.64 0.26 0.70]);
    hold on
    %errorbar(mean_of_mat3, std_of_mat3, 'Color', [0.7, 0.57, 0.72]);
    %uistack(pl,'top')
    
    figure(f2)
    pl = plot(mean_of_mat4', 'o');%,'LineWidth', 3, 'Color', [0.64 0.26 0.70]);
    hold on
    %errorbar(mean_of_mat4, std_of_mat4, 'Color', [0.7, 0.57, 0.72]);
    %uistack(pl,'top')
end

figure(f1)
title('Difference')
figure(f2)
title('Normalized Difference')