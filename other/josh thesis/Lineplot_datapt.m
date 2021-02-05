CMV = [];
NegCtrl = [];
f1 = figure();
f2 = figure();

ptx = 17;
pty = 35;

for i  = 1:7
    load(['mat/F_A', num2str(i), '.mat'])
    extract_data
    mean_of_mat3 = squeeze(diff_Matrix(ptx,pty,:));
    mean_of_mat4 = squeeze(normalized_Matrix(ptx,pty,:));
        
    figure(f1)
    pl = plot(mean_of_mat3, 'd');%, 'LineWidth', 3,'Color',[0.96 0.71 0.15]);
    hold on
    
    figure(f2)
    pl = plot(mean_of_mat4, 'x');%,'LineWidth', 3, 'Color', [0.96 0.71 0.15]);
    hold on
    end

for i  = 1:6
    load(['mat/F_B', num2str(i), '.mat'])
    extract_data
    mean_of_mat3 = squeeze(diff_Matrix(ptx,pty,:));
    mean_of_mat4 = squeeze(normalized_Matrix(ptx,pty,:));
    
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