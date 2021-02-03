clearvars
close all
load('Trim Process.mat')

%%%%%
frame_select1 = 582;
FSize = 14;
figure( 'Units', 'normalized', 'Position', [0 0.5 0.7 1] );
h1 = subplot(5,4,1:4);
imagesc(all_normal_matrix(:,:,frame_select1));
caxis ([minVal maxVal])
colorbar
title('Before trimming');
set(gca,'FontSize', FSize)
set(h1, 'Position', [0.0200    0.8207    0.8654    0.1543])
axis off

h1 = subplot(5,4,5:8);
imagesc(aMatrix(:,:,frame_select1));
caxis ([minVal maxVal])
colorbar
title('After trimming');
set(gca,'FontSize', FSize)
set(h1, 'Position', [0.0200    0.6280    0.8654    0.1543])
axis off

h1 = subplot(5,4,9:10);
imagesc(wofilter_matrix(:,:,frame_select1));
caxis ([minVal maxVal])
colorbar
title('Without filter pixels')
set(gca,'FontSize', FSize)
set(h1, 'Position', [0.0200    0.4353    0.3832    0.1543])
axis off

h1 = subplot(5,4,11:12);
imagesc(wfilter_matrix(:,:,frame_select1));
caxis ([minVal maxVal])
colorbar
title('With filter pixels')
set(gca,'FontSize', FSize)
set(h1, 'Position', [0.5022    0.4353    0.3832    0.1543])
axis off

h1 = subplot(5,4,[14,15]);
imagesc(diff_Matrix(:,:,frame_select1));
caxis ([minVal3 maxVal3])
colorbar
title('Difference Matrix');
set(gca,'FontSize', FSize)
set(h1, 'Position', [0.2661    0.2350    0.3832    0.1543])
axis off

h1 = subplot(5,4,[18,19]);
imagesc(normalized_Matrix(:,:,frame_select1));
caxis ([minVal4 maxVal4])
colorbar
title('Normalized Matrix');
set(gca,'FontSize', FSize)
set(h1, 'Position', [0.2661    0.0200    0.3832    0.1543])
axis off