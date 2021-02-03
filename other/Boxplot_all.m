plot_data = [];
plot_group = [];

cur_grp = 0;

for i  = 1:7
    cur_grp = cur_grp + 1;
    load(['mat/F_A', num2str(i), '.mat'])
    extract_data
    cell = diff_Matrix(:);
    plot_data = [plot_data; cell];
    plot_group = [plot_group; repmat(cur_grp, size(cell))];
end

for i  = 1:6
    cur_grp = cur_grp + 1;
    load(['mat/F_B', num2str(i), '.mat'])
    untitled3
    null = diff_Matrix(:);
    plot_data = [plot_data; null];
    plot_group = [plot_group; repmat(cur_grp, size(null))];
end

boxplot(plot_data, plot_group)