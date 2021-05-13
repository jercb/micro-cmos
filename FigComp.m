clearvars
close all

f1 = figure( 'Units', 'normalized', 'Position', [0.1 0.25 0.5 0.45] );

load('Dark current.mat')
[hAx, hline1, hline2] = plotyy(newdev(:,1), newdev(:,2), olddev(:,1), olddev(:,2));

for li = 1:2
    hAx(li).LineWidth = 2;
    hAx(li).FontSize = 24;
    hAx(li).XLabel.String = 'Frame Time (ms)';
    hAx(li).YLabel.String = 'Dark Pixel Value (DN)';
    hAx(li).XLabel.FontSize = 24;
    hAx(li).YLabel.FontSize = 24;
end

hold(hAx(1), 'on');
eb_l = errorbar(hAx(1), newdev(:,1), newdev(:,2), newdev(:,3),...
    'x', 'LineWidth', 5,...
    'Marker', 'none','Color', [0.6 0.6 0.6]);
uistack(eb_l, 'bottom')
set(get(get(eb_l,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

hAx(1).XLim = [0, 425];
hAx(1).XTick = 0:200:425;
hAx(1).YLim = [2000, 4000];
hAx(1).YTick = 2000:400:4000;
hAx(1).YTickLabel = num2cell(hAx(1).YTick);

hline1.LineWidth = 3;
hline1.Marker = 's';
hline1.MarkerSize = 10;
hline1.MarkerFaceColor = hline1.Color;

hold(hAx(2), 'on');
eb_l = errorbar(hAx(2), olddev(:,1), olddev(:,2), olddev(:,3),...
    'x', 'LineWidth', 5,...
    'Marker', 'none','Color', [0.6 0.6 0.6]);
uistack(eb_l, 'bottom')
set(get(get(eb_l,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

hAx(2).XLim = [0, 425];
hAx(2).XTick = 0:200:425;
hAx(2).YLim = [13000, 15000];
hAx(2).YTick = 13000:400:15000;
hAx(2).YTickLabel = num2cell(hAx(2).YTick);

hline2.LineWidth = 3;
hline2.Marker = 's';
hline2.MarkerSize = 10;
hline2.MarkerFaceColor = hline2.Color;

title('Comparison of Dark Current')
lgd = legend({'New Device', 'Previous Device'});
lgd.Location = 'best';

annotation(f1,'textbox', [0.25 0.532 0.0847 0.033],...
    'String',{'rate of increase = 1.4400'}, 'EdgeColor','none',...
    'FitBoxToText','on', 'FontSize', 24, 'Color', hline2.Color);
%0.5599
annotation(f1,'textbox', [0.25 0.25 0.0764 0.0333],...
    'String',{'rate of increase = 0.3054'}, 'EdgeColor','none',...
    'FitBoxToText','on', 'FontSize', 24, 'Color', hline1.Color);
%0.1187
legend boxoff

%hAx(1).Position = [0.0700 0.1100 0.8550 0.8150];
hAx(1).Position = [0.13 0.6-0.44 0.72 0.745];
hAx(2).Position = hAx(1).Position;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars
load('Temporal noise.mat')

f2 = figure( 'Units', 'normalized', 'Position', [0.1 0.25 0.5 0.45] );
x = [olddev(:,1), newdev(:,1)];
y = [olddev(:,2), newdev(:,2)];
err = [olddev(:,3), newdev(:,3)];

p_old = polyfit(newdev(:,1),newdev(:,2),1); 
p_new = polyfit(olddev(:,1),olddev(:,2),1); 

f_old = polyval(p_old, newdev(:,1));
f_new = polyval(p_new, olddev(:,1));
%blue [0 0.4470 0.7410]
%orange [0.8500 0.3250 0.0980]
dash_l1 = plot(newdev(:,1), newdev(:,2), 's' ,...
    'MarkerSize', 15, 'MarkerFaceColor', [0 0.4470 0.7410]);
hold on

dash_l2 = plot(olddev(:,1), olddev(:,2), 's' ,...
    'MarkerSize', 15, 'MarkerFaceColor', [0.8500 0.3250 0.0980]);

line_l1 = plot(newdev(:,1), f_old, '--' ,...
    'LineWidth', 2, 'Color', [0 0.4470 0.7410]);
line_l2 = plot(olddev(:,1), f_new, '--' ,...
    'LineWidth', 2, 'Color', [0.8500 0.3250 0.0980]);

eb_l = errorbar(x,y, err, 's', 'LineWidth', 5,...
    'Marker', 'none','Color', [0.6 0.6 0.6]);
uistack(eb_l, 'bottom')

title('Comparison of Temporal Noise')
lgd = legend([dash_l1, dash_l2], {'New Device', 'Previous Device'});
lgd.Location = 'best';

xlim([-15, 425])
xlabel('Frame Time (ms)')

ylim([0, 8])
ylabel('Temporal Noise (DN)')
set(gca,'YTickLabel',sprintf('%d\n',0:8))

set(gca,'FontSize', 24)
set(gca,'LineWidth', 2)

legend boxoff

set(gca, 'Position', [0.08 0.6-0.44 0.88 0.745])