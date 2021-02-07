clearvars
close all
load('Temporal noise.mat')

f1 = figure( 'Units', 'normalized', 'Position', [0.1 0.25 1 0.6] );

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

line_l1 = plot(newdev(:,1), f_old, '--' ,...
    'LineWidth', 2, 'Color', [0 0.4470 0.7410]);

eb_l = errorbar(newdev(:,1),newdev(:,2), newdev(:,3), 's', 'LineWidth', 5,...
    'Marker', 'none','Color', [0.6 0.6 0.6]);
uistack(eb_l, 'bottom')

title('Temporal noise : 4T-APS')
%lgd = legend({'','','4T-APS', '3T-APS'});
%lgd.Location = 'best';

xlim([-15, 1040])
xlabel('Settling Time (Clocks)')

ylim([0, 8])
ylabel('Temporal Noise (DN)')
set(gca,'YTickLabel',sprintf('%d\n',0:8))

set(gca,'FontSize', 20)
%set(gca,'LineWidth', 3)

set(gca, 'Position', [0.0650 0.1100 0.9100 0.8150])