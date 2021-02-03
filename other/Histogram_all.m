CMV = [];
NegCtrl = [];

for i  = 1:7
    load(['mat/F_A', num2str(i), '.mat'])
    extract_data
    cell = diff_Matrix(:);
    CMV = [CMV; cell];
end

for i  = 1:6
    load(['mat/F_B', num2str(i), '.mat'])
    untitled3
    null = diff_Matrix(:);
    NegCtrl = [NegCtrl; null];
end

close all

bin = min(min(CMV(:)), min(NegCtrl(:))):5:max(max(CMV(:)), max(NegCtrl(:)));
cell_hist = histogram(CMV, bin, 'EdgeAlpha', 0, 'Normalization','pdf');
cell_pdf = cell_hist.Values;
hold on
null_hist = histogram(NegCtrl, bin, 'EdgeAlpha', 0, 'Normalization','pdf');
null_pdf = null_hist.Values;
sqrt(sum((sqrt(null_pdf/sum(null_pdf)) - sqrt(cell_pdf/sum(cell_pdf))).^2)) ./ sqrt(2)
legend({'cell', 'null'})