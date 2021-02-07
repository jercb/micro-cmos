clearvars
close all
load('Sensitivity.mat')

f1 = figure( 'Units', 'normalized', 'Position', [0.1 0.25 1 0.6] );

x1 = olddev(:,1);
x1 = [x1,x1];
y1 = olddev(:,2:3);
err1 = olddev(:, 4:5);

x2 = newdev(:,1);
x2 = [x2,x2];
y2 = newdev(:,2:3);
err2 = newdev(:, 4:5);

x = [x1, x2];
y = [y1, y2];
err = [err1, err2];

y_diff = [olddev_diff(:, 2), newdev_diff(:, 2)];
err_diff = [olddev_diff(:, 3), newdev_diff(:, 3)];

dash_l1a = plot(newdev(:,1), newdev(:,2), 's-' ,...
    'Color', [0 0.4470 0.7410],...
    'MarkerSize', 15, 'MarkerFaceColor', [0 0.4470 0.7410]);
hold on
dash_l2a = plot(newdev(:,1), newdev(:,3), '^-' ,...
    'Color', [0 0.4470 0.7410],...
    'MarkerSize', 15, 'MarkerFaceColor', [0 0.4470 0.7410]);

eb_l = errorbar(x2,y2, err2, 's', 'LineWidth', 5,...
    'Marker', 'none','Color', [0.6 0.6 0.6]);
uistack(eb_l, 'bottom')

set(get(get(eb_l(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
set(get(get(eb_l(2),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

lgd = legend({'4T-APS w/o filter', '4T-APS w/ filter'});
lgd.Location = 'best';

xlim([-0.25, 12.25])
xlabel('Power Density (\muW / cm^2)')

ylim([-500, 16000])
ylabel('Device pixel value (DN)')

set(gca,'FontSize', 20)
%set(gca,'LineWidth', 3)
title('Sensitivity : 4T-APS ')
legend boxoff
set(gca, 'Position', [0.0750 0.1263 0.9000 0.7987])
f1Pos = get(gca, 'Position');

f2 = figure( 'Units', 'normalized', 'Position', [0.1 0.25 1 0.6] );

dash_l1b = plot(newdev_diff(:,1), newdev_diff(:,2), 'd-' ,...
    'Color', [0 0.4470 0.7410],...
    'MarkerSize', 15, 'MarkerFaceColor', [0 0.4470 0.7410]);
hold on

eb_l = errorbar(newdev_diff(:,1),newdev_diff(:, 2), newdev_diff(:, 3), 's', 'LineWidth', 5,...
    'Marker', 'none','Color', [0.6 0.6 0.6]);
uistack(eb_l, 'bottom')


set(get(get(eb_l(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

lgd = legend({'4T-APS (difference)'});
lgd.Location = 'best';

xlim([-0.25, 4.25])
xlabel('Power Density (\muW / cm^2)')

ylim([-500, 12000])
ylabel('Device pixel value (DN)')

set(gca,'FontSize', 20)
%set(gca,'LineWidth', 2)
title('Sensitivity : 4T-APS (Difference) [zoomed in]')
legend boxoff
set(gca, 'Position', f1Pos)