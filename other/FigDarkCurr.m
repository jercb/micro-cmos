clearvars
close all

load('Dark current.mat')

f1 = figure( 'Units', 'normalized', 'Position', [0.1 0.25 1 0.6] );
hAx = plot(newdev(:,1), newdev(:,2));

hAx.LineWidth = 3;
hAx.Marker = 's';
hAx.MarkerSize = 10;
hAx.MarkerFaceColor = [0 0.4470 0.7410];

set(gca, 'FontSize', 20);
xlabel('Settling Time (Clocks)');
ylabel('Dark Pixel Value (DN)');

hold on;
eb_l = errorbar(newdev(:,1), newdev(:,2), newdev(:,3),...
    'x', 'LineWidth', 3,...
    'Marker', 'none','Color', [0.6 0.6 0.6]);
uistack(eb_l, 'bottom')
set(get(get(eb_l,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

xlim([0, 1000]);
set(gca, 'XTick', 0:200:1000);
ylim([2300, 2500]);
set(gca, 'YTick', 2300:100:2500);
%hAx(1).YTickLabel = num2cell(hAx(1).YTick);
title('Dark current : 4T-APS')
%lgd = legend({'4T-APS', '3T-APS'});
%lgd.Location = 'best';

annotation(f1,'textbox', [0.669 0.521 0.0764 0.0333],...
    'String',{'rate of increase = 0.1187'}, 'EdgeColor','none',...
    'FitBoxToText','on', 'FontSize', 24, 'Color', [0 0.4470 0.7410]);

set(gca, 'Position', [0.0700 0.1100 0.8550 0.8150]);