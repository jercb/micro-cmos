close all
clearvars
olddev = load('3T-APS CMV-Luc.mat');
newdev = load('4T-APS CMV-Luc.mat');

newF0 = newdev.F0_id(2) - 1;
oldF0 = olddev.F0_id(2) - 1;

f1 = figure( 'Units', 'normalized', 'Position', [0.1 0.25 1 0.45] );

cell{1} = olddev.mean_of_mat3(oldF0+1:end);
cell{2} = newdev.mean_of_mat3(newF0+1:end);
sdcell{1} = olddev.std_of_mat3(oldF0+1:end);
sdcell{2} = newdev.std_of_mat3(newF0+1:end);

null{1} = olddev.mean_of_mat3(1:oldF0);
null{2} = newdev.mean_of_mat3(1:newF0);
sdnull{1} = olddev.std_of_mat3(1:oldF0);
sdnull{2} = newdev.std_of_mat3(1:newF0);

hTitle{1} = '3T-APS CMV-Luc average reading (Difference)';
hTitle{2} = '4T-APS CMV-Luc average reading (Difference)';

ij = 1;

withcell = cell{ij};
nocell = null{ij};

sdwithcell = sdcell{ij};
sdnocell = sdnull{ij};

withcell(isinf(withcell)) = [];
nocell(isinf(nocell)) = [];

convFact = 20;
x_withcell = 0:size(withcell, 2)-1;
x_nocell = 0:size(nocell, 2)-1;

x_withcell = x_withcell ./ convFact;
x_nocell = x_nocell ./ convFact;

plot(x_withcell, withcell, 'LineWidth', 3);
hold on
plot(x_nocell, nocell, 'LineWidth', 3);

eb1 = errorbar(x_withcell, withcell, sdwithcell, 'Color', [0.7020 0.8784 1.0000],...
    'LineWidth', 3);
eb2 = errorbar(x_nocell, nocell, sdnocell, 'Color', [0.9686 0.8039 0.7333],...
    'LineWidth', 3);
uistack(eb1,'bottom')
uistack(eb2,'bottom')
set(get(get(eb1,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
set(get(get(eb2,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

legend({'with cells', 'no cell'})
title(hTitle{ij})
xlabel('Minutes')
ylabel('Pixel Value (DN)')


%xlim([0 60])
ylim([-1 5])
%set(gca, 'XTick', 0:20:60)
%set(gca, 'XTickLabel', {'0', '1', '2', '3'})

set(gca,'FontSize', 24)
set(gca,'LineWidth', 2)
legend boxoff