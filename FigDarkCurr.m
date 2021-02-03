clearvars
close all

load('Dark current.mat')

f1 = figure( 'Units', 'normalized', 'Position', [0.1 0.25 1 0.6] );
[hAx, hline1, hline2] = plotyy(newdev(:,1), newdev(:,2), olddev(:,1), olddev(:,2));

for li = 1:2
    hAx(li).LineWidth = 2;
    hAx(li).FontSize = 24;
    hAx(li).XLabel.String = 'Settling Time (Clocks)';
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

hAx(1).XLim = [0, 1000];
hAx(1).XTick = 0:200:1000;
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

hAx(2).XLim = [0, 1000];
hAx(2).XTick = 0:200:1000;
hAx(2).YLim = [13000, 15000];
hAx(2).YTick = 13000:400:15000;
hAx(2).YTickLabel = num2cell(hAx(2).YTick);

hline2.LineWidth = 3;
hline2.Marker = 's';
hline2.MarkerSize = 10;
hline2.MarkerFaceColor = hline2.Color;

title('Comparison of dark current between 4T-APS and 3T-APS')
lgd = legend({'4T-APS', '3T-APS'});
lgd.Location = 'best';

annotation(f1,'textbox', [0.425 0.532 0.0847 0.033],...
    'String',{'rate of increase = 0.5599'}, 'EdgeColor','none',...
    'FitBoxToText','on', 'FontSize', 24, 'Color', hline2.Color);

annotation(f1,'textbox', [0.669 0.221 0.0764 0.0333],...
    'String',{'rate of increase = 0.1187'}, 'EdgeColor','none',...
    'FitBoxToText','on', 'FontSize', 24, 'Color', hline1.Color);

legend boxoff

hAx(1).Position = [0.0700 0.1100 0.8550 0.8150];
hAx(2).Position = hAx(1).Position;