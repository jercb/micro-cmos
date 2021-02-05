mat2plot = {'all_normal_matrix', 'wofilter_matrix',...
    'wfilter_matrix', 'normalized_Matrix', 'diff_Matrix'};
data_list = {'F_A1', 'F_A2a', 'F_A2b', 'F_A3a', 'F_A3b', 'F_A4a', 'F_A4b',...
    'F_B1', 'F_B2', 'F_B3', 'F_B4a', 'F_B4b', 'F_B4c'};

for mati = 5
    CMV = [];
    NegCtrl = [];
    plot_data = [];
    plot_group = [];
    cur_grp = 0;
    f1 = figure( 'Units', 'normalized', 'Position', [0.1 0.25 1 1] );
    
    for i  = 1:7
        cur_grp = cur_grp + 1;
        clearvars cell
        load(['mat/F_A', num2str(i), '.mat'])
        extract_data
        
        switch mati
            case {1}
                cell = all_normal_matrix(:);
            case {2}
                cell = wofilter_matrix(:);
            case {3}
                cell = wfilter_matrix(:);
            case {4}
                cell = normalized_Matrix(:);
            case {5}
                cell = diff_Matrix(:);
        end
        
        CMV = [CMV; cell];
        plot_data = [plot_data; cell];
        plot_group = [plot_group; repmat(cur_grp, size(cell))];
    end
    
    for i  = 1:6
        cur_grp = cur_grp + 1;
        clearvars null
        load(['mat/F_B', num2str(i), '.mat'])
        extract_data
        
        switch mati
            case {1}
                null = all_normal_matrix(:);
            case {2}
                null = wofilter_matrix(:);
            case {3}
                null = wfilter_matrix(:);
            case {4}
                null = normalized_Matrix(:);
            case {5}
                null = diff_Matrix(:);
        end
        
        NegCtrl = [NegCtrl; null];
        plot_data = [plot_data; null];
        plot_group = [plot_group; repmat(cur_grp, size(null))];
    end
    
    bin = min( min(CMV(~isinf(CMV))), min(NegCtrl(~isinf(NegCtrl))) )...
        :5: max( max(CMV(~isinf(CMV))), max(NegCtrl(~isinf(NegCtrl))) );
        
    subplot(1,2,1)
    cell_hist = histogram(CMV, bin, 'EdgeAlpha', 0, 'Normalization','pdf');
    cell_pdf = cell_hist.Values;
    hold on
    null_hist = histogram(NegCtrl, bin, 'EdgeAlpha', 0, 'Normalization','pdf');
    null_pdf = null_hist.Values;
    dist = sqrt(sum((sqrt(null_pdf/sum(null_pdf)) - sqrt(cell_pdf/sum(cell_pdf))).^2)) ./ sqrt(2);
    title({mat2plot{mati}, ['Hellinger Dist = ', num2str(dist)]});
    legend({'cell', 'null'})
    subplot(1,2,2)
    boxplot(plot_data, plot_group)
    xticks(1:13);
    xticklabels(data_list);
    title(mat2plot{mati});
    saveas(f1, [num2str(mati), mat2plot{mati}, '.png']);
end