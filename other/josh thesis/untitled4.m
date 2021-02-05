load('/Users/jericBriones/Downloads/mat/F_A3a.mat')
untitled3
cell = diff_Matrix;
load('/Users/jericBriones/Downloads/F_B4a.mat')
untitled3
null = diff_Matrix;

close all
%histogram(null(:), 'EdgeAlpha', 0, 'Normalization','pdf')
%hold on
%histogram(cell(:), 'EdgeAlpha' , 0, 'Normalization','pdf')
%legend({'null (signal+noise)', 'cell (signal+noise)'})

bin = min(min(cell(:)), min(null(:))):5:max(max(cell(:)), max(null(:)));
cell_hist = histogram(cell, bin, 'EdgeAlpha', 0, 'Normalization','pdf');
cell_pdf = cell_hist.Values;
hold on
null_hist = histogram(null, bin, 'EdgeAlpha', 0, 'Normalization','pdf');
null_pdf = null_hist.Values;
sqrt(sum((sqrt(null_pdf/sum(null_pdf)) - sqrt(cell_pdf/sum(cell_pdf))).^2)) ./ sqrt(2)
legend({'cell (signal+noise)', 'null (signal+noise)'})