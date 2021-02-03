%% Define files, lists and figures
folList = {'3T-APS CMV-Luc Raw','4T-APS CMV-Luc Raw'};
titleList = {'3T-APS CMV-Luc Raw','4T-APS CMV-Luc Raw'};
matFldr = 'mat files';
figFldr = 'fig files';
% nTrial = numel(folList); %%%% how many folders are there
nTrial = 2;

% Create figure windows, one for each type of plot across trials/folders
fig_mean1 = figure( 'Units', 'normalized', 'Position', [0 0.5 1 1] );
fig_mean2 = figure( 'Units', 'normalized', 'Position', [0 0.5 1 1] );
fig_mean3 = figure( 'Units', 'normalized', 'Position', [0 0.5 1 1] );
% fig_mean4 = figure( 'Units', 'normalized', 'Position', [0 0.5 1 1] );

if ~exist(matFldr, 'dir')
    mkdir(matFldr)
end

if ~exist(figFldr, 'dir')
    mkdir(figFldr)
end

%% START OF ANALYSIS

for fileI = 1:nTrial
    clearvars -except folList titleList fileI matFldr figFldr nTrial fig_mean1 fig_mean2 fig_mean3 fig_mean4
    F0_id = [];
    curFol = folList{fileI};
    fprintf('Processing %s\n', curFol)
    
    fileName = fullfile('mat files', [curFol, '.mat']); %%fileName of .mat file - fullfile generates/goes to the path
    
    %if mat files are already available
    if exist(fileName)
        workingMat = load(fileName);
        all_normal_matrix = workingMat.all_normal_matrix;
        fps = workingMat.fps;
        all_image_matrix = workingMat.all_image_matrix;
        mean_backgroundImage = workingMat.mean_backgroundImage;
        backgroundImage = workingMat.backgroundImage;
        F0_id = workingMat.F0_id;
    else
        fileList = dir(fullfile(curFol,'*.raw')); % lists the files that follow .raw format
        [~,index] = sortrows([fileList.datenum].');
        fileList = fileList(index);
        clear index
        numFile = size(fileList, 1); % numFile is the number of raw files
        
        % counter for all frames in file (start of current file)
        frame_start = 1;
        
        for fileInd = 1:numFile %to execute this command from file 1 up to the end
            
            currentFile = fileList(fileInd).name; %assigns 'currentFile' as the name and extension of each file
            fid = fopen(fullfile(curFol,currentFile)); %opens each file
            f=dir(fullfile(curFol,currentFile)); %gets properties of each file
            
            %assigned variables
            ii = 0;
            d = [0 0 1024];
            
            %size of pixel array
            x_size = 44;
            y_size = 121;
            
            %% Read image data---------------------------
            while(ii==0 || d(3) == 1024)
                
                if(ii ~= 0) % for the next file (~= means NOT)
                    clear imageData normalImage pixdata normalImageAVG range_sel %clears the ff variables to make room for the next one
                    fid = fopen(deblank(transpose(nextFileName))); % Please replace with your raw data filename.
                    f = dir(deblank(transpose(nextFileName)));
                end
                %%Read header & background image data-------------------
                softwareVersion  = fread(fid, 32, '*char');
                currentFileName  = fread(fid, 128, '*char');
                previousFileName = fread(fid, 128, '*char');
                nextFileName     = fread(fid, 128, '*char');
                chipNo           = fread(fid, 1, '*int32');
                clockMulti       = fread(fid, 1, '*int32');
                settlingClocks   = fread(fid, 1, '*int32');
                startFrameNo     = fread(fid, 1, '*int32');
                FrameTime        = fread(fid, 1, '*float', 27*4); %skip 27*4 bytes after reading
                backgroundImage  = fread(fid, [x_size, y_size], 'ushort'); % Background (dark) image for fixed pattern noise (FPN) reduction
                
                framesInFile = (f.bytes-17824)/(x_size*y_size*2+97); % 17824 is the length of header & bgimage data.
                
                for i=1:framesInFile %Readable data size at once depends on your PC
                    FrameNo     = fread(fid, 1, '*uint32', 15*4); %!!In the data saved by old version, frame no is corrupted.
                    Triggers    = fread(fid, 1, '*uint8',  8*4);
                    imageData(:,:,i)   = fread(fid, [x_size, y_size], 'ushort');
                    normalImage(:,:,i) = backgroundImage - imageData(:,:,i); % Normal image  is  the difference between Raw image data and Background image.
                    %range_sel(:,:,i) = normalImage(xsel1: xsel2,ysel1:ysel2,i); % select only the pixel data from the region of interest
                end
                
                ii = ii+1;
                fclose(fid);
                
                d = size(imageData);
            end
            
            % counter for all frames in a file (end)
            frame_end = frame_start + size(normalImage, 3) - 1;
            
            %added variables
            frame_time(fileInd) = FrameTime;
            aveFrameTime = mean (frame_time);
            fps = 1/aveFrameTime ;
            mean_backgroundImage = mean(backgroundImage, 'all');
            all_image_matrix(:,:,frame_start:frame_end) = imageData;
            all_normal_matrix(:,:,frame_start:frame_end) = normalImage;
            
            %Prelim Figure 5 - imagesc for frames that have "Frame0" names
            %
            if strfind(currentFile,'Frame0-')
                %                 figure;
                %                 imagesc(normalImage(:,:,1));
                %                 title([curFol,' > ',fileInd])
                %
                %saves the frames that have "Frame0" names
                F0_id = [F0_id,frame_start];
                %
            end
            
            % counter for all frames in file (start of next file)
            frame_start = frame_end + 1;
            
        end
        fileName = fullfile(matFldr, [curFol, '.mat']);
        %save(fileName, 'all_normal_matrix', 'fps', 'all_image_matrix','mean_backgroundImage','backgroundImage','F0_id')
    end
    
    %Sample pixel
    pixelx = 25; pixely = 27;
    
    fprintf('Trimming Matrices for %s\n', curFol)
    
    aMatrix = all_normal_matrix;
    
%     switch fileI
%         case {3}
%             aMatrix(:,:,6000:end) = [];
%         case {4}
%             aMatrix(:,:,640:end) = [];
%     end

aMatrix(:,96:99,:) = [];
aMatrix(41:end,:,:) = [];
aMatrix(1:8,:,:) = [];
aMatrix(:,1:3,:) = [];
aMatrix(:,end-1:end,:) = [];


fprintf('Separating Matrices for %s\n', curFol)

wofilter_aMatrix = aMatrix;
wofilter_aMatrix(:,3:4:end,:) = [];
wofilter_aMatrix(:,3:3:end,:) = [];

wfilter_aMatrix = aMatrix;
wfilter_aMatrix(:,1:4:end,:) = [];
wfilter_aMatrix(:,1:3:end,:) = [];

%%   IF BINNING IS DONE BEFORE
%     % bin matrices
%     sqSize = 8;
%     bMatrix = binning(aMatrix, [sqSize sqSize]);
%     wofilter_bMatrix = binning(wofilter_aMatrix, [sqSize sqSize/2]);
%     wfilter_bMatrix = binning(wfilter_aMatrix, [sqSize sqSize/2]);

%select matrix to use here
useMatrix = aMatrix;
wofilter_matrix = wofilter_aMatrix;
wfilter_matrix = wfilter_aMatrix;
%     useMatrix = bMatrix;
%     wofilter_matrix = wofilter_bMatrix;
%     wfilter_matrix = wfilter_bMatrix;

minVal = prctile(useMatrix(:), 2.5);
maxVal = prctile(useMatrix(:), 97.5);

% %%Prelim Figure 6 - check difference between all normal, aMatrix, wfilter, wofilter
% frame_select1 = 582;
% figure
% subplot(3,2,[1,2])
% imagesc(all_normal_matrix(:,:,frame_select1));
% caxis ([minVal maxVal])
% colorbar
% title([titleList{fileI}, ' Matrix before trimming']);
% subplot(3,2,[3,4])
% imagesc(aMatrix(:,:,frame_select1));
% caxis ([minVal maxVal])
% colorbar
% title([titleList{fileI},' Matrix after trimming']);
% subplot(3,2,5)
% imagesc(wofilter_matrix(:,:,frame_select1));
% caxis ([minVal maxVal])
% colorbar
% title(['Without filter pixels'])
% subplot(3,2,6)
% imagesc(wfilter_matrix(:,:,frame_select1));
% caxis ([minVal maxVal])
% colorbar
% title(['With filter pixels'])


%     %%Prelim Figure 7
%     figure;
%
%     subplot (2,1,1) %check difference between all normal and all image mat
%     plot(squeeze(all_image_matrix(pixelx,pixely,:)));
%     hold on;
%     plot(squeeze(all_normal_matrix(pixelx,pixely,:)));
%     yline(mean_backgroundImage);
%     yline(backgroundImage(pixelx,pixely),'--');
%     legend ({'all image matrix','all normal matrix', 'average background image','single pixel background image'});
%     title([curFol, ' - Pre-processed pixel ', num2str(pixelx),', ', num2str(pixely)]);
%
%     subplot(2,1,2) %check difference between w and wo filter
%     plot(squeeze(wfilter_aMatrix(pixelx,pixely,:)),'b');
%     hold on;
%     plot(squeeze(wofilter_aMatrix(pixelx,pixely,:)),'r');
%     legend ({'single pixel with filter','single pixel without filter'})
%     title([curFol, ' Single pixel ', num2str(pixelx),', ', num2str(pixely)]);
%     %normal matrix: without filter > wo filter

%%  PARAMETER COMPUTATION CODES
fprintf('Getting parameters for %s\n', curFol)

%Get difference, normalized and their mins and max
num_col = min(size(wofilter_matrix, 2), size(wfilter_matrix, 2));
diff_Matrix = (wofilter_matrix(:,1:num_col,:) - wfilter_matrix(:,1:num_col,:));
normalized_Matrix = diff_Matrix./wfilter_matrix(:,1:num_col,:);

%Get mean and stdev
mean_of_mat1 = squeeze(mean(wofilter_matrix, [1 2]));
mean_of_mat2 = squeeze(mean(wfilter_matrix, [1 2]));
mean_of_mat3 = squeeze(mean(diff_Matrix, [1 2]));
%mean_of_mat4 = squeeze(mean(normalized_Matrix, [1 2]));
mean_of_mat4 = [];

for fileInd = 1:size(normalized_Matrix, 3)
    %get matrix to plot
    curMat4 = normalized_Matrix(:,:, fileInd); %curMat gets the x,y of each frame
    mean_of_mat4(fileInd) = mean(curMat4(isfinite(curMat4)), 'all'); %sum of Mat gets the total sum of x and y per curMat
    std_of_mat4(fileInd) = nanstd(curMat4(isfinite(curMat4)), 0, 'all')./sqrt(numel(curMat4(isfinite(curMat4))));
end

std_of_mat1 = squeeze(std(wofilter_matrix, 0, [1 2])) ./ sqrt(size(wofilter_matrix, 1) * size(wofilter_matrix,2));
std_of_mat2 = squeeze(std(wfilter_matrix, 0, [1 2])) ./ sqrt(size(wfilter_matrix, 1) * size(wfilter_matrix,2));
std_of_mat3 = squeeze(std(diff_Matrix, 0, [1 2])) ./ sqrt(size(diff_Matrix, 1) * size(diff_Matrix,2));
%std_of_mat4 = squeeze(std(normalized_Matrix, 0, [1 2])) ./ sqrt(size(normalized_Matrix, 1) * size(normalized_Matrix,2));

%for fileInd = 1:size(wofilter_aMatrix, 3)
%    %get matrix to plot
%    curMat1 = wofilter_aMatrix(:,:, fileInd); %curMat gets the x,y of each frame
%    mean_of_mat1(fileInd) = mean(curMat1(:)); %sum of Mat gets the total sum of x and y per curMat
%    std_of_mat1(fileInd) = std(curMat1(:))./sqrt(size(curMat1(:),1));
%end


%for fileInd = 1:size(wfilter_aMatrix, 3)
%    %get matrix to plot
%    curMat2 = wfilter_aMatrix(:,:, fileInd); %curMat gets the x,y of each frame
%    mean_of_mat2(fileInd) = mean(curMat2(:)); %sum of Mat gets the total sum of x and y per curMat
%    std_of_mat2(fileInd) = std(curMat2(:))./sqrt(size(curMat2(:),1));
%end

%for fileInd = 1:size(diff_filter_aMatrix, 3)
%    %get matrix to plot
%    curMat3 = diff_filter_aMatrix(:,:, fileInd); %curMat gets the x,y of each frame
%    mean_of_mat3(fileInd) = mean(curMat3(:)); %sum of Mat gets the total sum of x and y per curMat
%    std_of_mat3(fileInd) = std(curMat3(:))./sqrt(size(curMat3(:),1));
%end


minVal3 = prctile(mean_of_mat3(:), 2.5);
maxVal3 = prctile(mean_of_mat3(:), 97.5);
minVal4 = prctile(mean_of_mat4(:), 2.5);
maxVal4 = prctile(mean_of_mat4(:), 97.5);

% %%Prelim Figure 8 - check difference between wfilter, wofilter, diff and normalized matrix
% frame_select2 = 582;
% figure
% subplot(3,2,1)
% imagesc(wofilter_matrix(:,:,frame_select2));
% caxis ([minVal maxVal])
% colorbar
% title(['Without filter pixels'])
% subplot(3,2,2)
% imagesc(wfilter_matrix(:,:,frame_select2));
% caxis ([minVal maxVal])
% colorbar
% title(['With filter pixels'])
% subplot(3,2,[3,4])
% imagesc(diff_Matrix(:,:,frame_select2));
% caxis ([minVal3 maxVal3])
% colorbar
% title([titleList{fileI}, ' Difference Matrix']);
% subplot(3,2,[5,6])
% imagesc(normalized_Matrix(:,:,frame_select2));
% caxis ([minVal4 maxVal4])
% colorbar
% title([titleList{fileI}, ' Normalized Matrix']);


%Get time markers
switch fileI
    
    case {1,2,3,4}
        convX = 60; %how many seconds to one interval?
        everyTick = 5; %1 intervals of convX is one tick
        tkmarkers = [1:size(all_normal_matrix,3)]; %gets number of frames into a 1D sequence
        tkmarker_mins = tkmarkers./fps/convX; %equation for converting frames to desired time interval (convX)
        [~,timepos] = min(abs(tkmarker_mins-1)); %gets the frame closest to one interval/ gets the number of frames for one interval
        tMarkers = [1:timepos*everyTick:size(all_normal_matrix,3)]; %multiplies to number of intervals for each tick
        tMarker_ticks = tMarkers./fps/convX; %equation for converting frames to ticks
        
        %         case {3}
        %             convX = 3600; %how many seconds to one interval?
        %             everyTick = 2; %1 intervals of convX is one tick
        %             tkmarkers = [1:size(all_normal_matrix,3)]; %gets number of frames into a 1D sequence
        %             tkmarker_mins = tkmarkers./fps/convX; %equation for converting frames to desired time interval (convX)
        %             [~,timepos] = min(abs(tkmarker_mins-1)); %gets the frame closest to one interval/ gets the number of frames for one interval
        %             tMarkers = [1:timepos*everyTick:size(all_normal_matrix,3)]; %multiplies to number of intervals for each tick
        %             tMarker_ticks = tMarkers./fps/convX; %equation for converting frames to ticks
end


%     %Get moving average filter
%     winSize = 24; %how many time-units in one window
%     winSize_f = round(fps * convX * winSize);
%     coefMA = ones(1, winSize_f)/winSize_f;

%     mean_of_mat4_f = filter(coefMA, 1, mean_of_mat4');

%     MA_start = winSize_f/2;
%     MA_end = length(mean_of_mat3) - MA_start;

%%  PLOTTING CODES
fprintf('Doing Figures for %s\n', curFol)

% Plot for Line 1 - Mean of with and without filter
figure(fig_mean1) %%%% call appropriate figure where line 1 will be plotted
subplot(nTrial,1,fileI) %%%% fileI to indicate the index for subplot

pl1 = plot(mean_of_mat1,'Color', 'r', 'LineWidth', 3);
hold on
pl2 = plot(mean_of_mat2, 'Color', 'b', 'LineWidth', 3);
errorbar(mean_of_mat1, std_of_mat1, 'Color', [0.95, 0.75, 0.75], 'HandleVisibility','off');
errorbar(mean_of_mat2, std_of_mat2, 'Color', [0.75, 0.75, 0.95], 'HandleVisibility','off');
uistack(pl2,'top')
uistack(pl1,'top')
%ylim([-100 100])

for ijk = 1:size(F0_id,2)
    xline(F0_id(ijk),'LineWidth',3); %%Label raw Frame0s
end

switch fileI
    case {1}
        xlabel('Minutes','FontSize', 14);
        xlim([0 1900])
    case {2, 3}
        xlabel('Minutes','FontSize', 14);
        xlim([0 1900])
    case {4}
        xlabel('Minutes','FontSize', 14);
        xlim([0 1900])
        %             xlim([0 950])
        
end
title(titleList{fileI});
legend1 = legend({'with filter', 'without filter'});
set(legend1, 'Location', 'best');
set(gca, 'FontSize', 24);
ylabel('Pixel Value (D.N.)','FontSize', 20);

xticks(tMarkers);
tklabels = num2cell(tMarker_ticks);
fun = @(x) sprintf('%0.0f', x);
tklabels = cellfun(fun, tklabels, 'UniformOutput',0);
xticklabels(tklabels);
%xtickangle(90);
%     saveas(gcf,[pwd '/Positive control figures/Original positive cntrl- limits adjusted.fig']);
%     saveas(gcf,[pwd '/Positive control figures/Original positive cntrl- limits adjusted.png']);

% Plot for Line 2 - Difference of mean
figure(fig_mean2) %%%% call appropriate figure where line 1 will be plotted
subplot(nTrial,1,fileI) %%%% fileI to indicate the index for subplot

pl = plot(mean_of_mat3, 'LineWidth', 3,'Color',[0.96 0.71 0.15]);
hold on
errorbar(mean_of_mat3, std_of_mat3, 'Color', [0.96, 0.88, 0.70]);
uistack(pl,'top')
%ylim([-50 50])

for ijk = 1:size(F0_id,2)
    xline(F0_id(ijk),'LineWidth',3); %%Label raw Frame0s
end

switch fileI
    case {1, 2}
        xlabel('Minutes','FontSize', 14);
        xlim([0 1900])
        %             ylim([0 2000])
    case {3}
        xlabel('Minutes','FontSize', 14);
        xlim([0 1900])
        %             ylim([1000 3000])
    case {4}
        xlabel('Minutes','FontSize', 14);
        xlim([0 1900])
        %             xlim([0 950])
        %             ylim([1000 3000])
end
title([titleList{fileI}, ' (Difference)']);
xticks(tMarkers);
xticklabels(tklabels);
%ylim ([-0.1 inf]);
%yticks ([0:10:40])
%xtickangle(90);
set(gca, 'FontSize', 24);
ylabel('Pixel Value (D.N.)','FontSize', 20);
%     saveas(gcf,[pwd '/Positive control figures/Difference positive cntrl- limits adjusted.fig']);
%     saveas(gcf,[pwd '/Positive control figures/Difference positive cntrl- limits adjusted.png']);

% Plot for Line 3 - Normalized difference
figure(fig_mean3) %%%% call appropriate figure where line 1 will be plotted
subplot(nTrial,1,fileI) %%%% fileI to indicate the index for subplot

pl = plot(mean_of_mat4,'LineWidth', 3, 'Color', [0.64 0.26 0.70]);
hold on
errorbar(mean_of_mat4, std_of_mat4, 'Color', [0.7, 0.57, 0.72]);
uistack(pl,'top')
%ylim([-0.5 0.5])

for ijk = 1:size(F0_id,2)
    xline(F0_id(ijk),'LineWidth',3); %%Label raw Frame0s
end


switch fileI
    case {1, 2}
        xlabel('Minutes','FontSize', 14);
        xlim([0 1900])
        %             ylim([0 2000])
    case {3}
        xlabel('Minutes','FontSize', 14);
        xlim([0 1900])
        %             ylim([1000 3000])
    case {4}
        xlabel('Minutes','FontSize', 14);
        xlim([0 1900])
        %             xlim([0 950])
        %             ylim([1000 3000])
end
title([titleList{fileI}, ' (Normalized)']);
xticks(tMarkers);
xticklabels(tklabels);
%xtickangle(90);
set(gca, 'FontSize', 24);
ylabel('Pixel Value (D.N.)','FontSize', 20);
% %     saveas(gcf,[pwd '/Positive control figures/Normalized positive cntrl- limits adjusted.fig']);
% %     saveas(gcf,[pwd '/Positive control figures/Normalized positive cntrl- limits adjusted.png']);


%     % Plot for Line 4 - Detrended
%     figure(fig_mean4) %%%% call appropriate figure where line 1 will be plotted
%     subplot(nTrial,1,fileI) %%%% fileI to indicate the index for subplot
%     plot(tkmarkers(MA_start:MA_end),mean_of_mat4_f(winSize_f:end), 'LineWidth', 3)
%     ylabel('Pixel Value (D.N.)','FontSize', 14);
%     xlabel('Hours','FontSize', 14);
%     title('Detrended');
%     xticks(tMarkers);
%     xticklabels(tklabels);

% %%  IF BINNING IS DONE AFTER
% %   bin matrices
%     sqSize = 8;
%     bMatrix = binning(normalized_Matrix, [sqSize sqSize/2]);
%     %bMatrix = binning(aMatrix, [sqSize sqSize]);
%     %wofilter_bMatrix = binning(wofilter_aMatrix, [sqSize sqSize/2]);
%     %wfilter_bMatrix = binning(wfilter_aMatrix, [sqSize sqSize/2]);
%
% %   Plot for bins
%     mat2plot = bMatrix;
%     plotMin = min(mat2plot(isfinite(mat2plot)),[],'all');
%     plotMax = max(mat2plot(isfinite(mat2plot)),[],'all');
%
%     dim_x = size(mat2plot, 1);
%     dim_y = size(mat2plot, 2);
%
%     figure ('Units', 'normalized', 'Position', [0 0.5 1 1] );
%     plot_count = 1;
%
%     for im = 1:dim_x
%         for jm = 1:dim_y
%             curMat2Plot = squeeze(mat2plot(im, jm, :));
%             subplot(dim_x, dim_y, plot_count)
%             try
%                 plot(curMat2Plot,'LineWidth', 3, 'Color', [0.64 0.26 0.70])
%                 ylim([plotMin plotMax])
%                 xticks(tMarkers);
%                 xticklabels(tklabels);
%             catch
%             end
%             sgtitle ([titleList{fileI}, ' Normalized averages of 8x8 pixel bins'],'FontWeight', 'bold')
%             plot_count = plot_count + 1;
%         end
%     end
%
% %     %For selecting a specific bin
% %     figure
% %     plot_count = 1;
% %
% %     for imn = 1
% %         for jmn = 1
% %             curMat3Plot = squeeze(mat2plot(imn, jmn, :));
% %             %subplot(dim_x, dim_y, plot_count)
% %             try
% %                 plot(curMat3Plot)
% %                 ylim([0 1])
% %                 xticks(tMarkers);
% %                 xticklabels(tklabels);
% %             catch
% %             end
% %             plot_count = plot_count + 1;
% %         end
% %     end
%

%     %%FIGURE 9 - Compare heatmaps
%     figure('units','normalized','outerposition',[0 0 1 1])
%     nhmap = size(tMarkers,2);
%     for mi = 1:nhmap
%         subplot(1,nhmap,mi)
%         curimagesc = aMatrix(:,:,tMarkers(mi));
%         imagesc(curimagesc');
%         colorbar
%         title(['Heatmap hour ',num2str(round(tMarkers(mi)./fps/convX))] )
%     end

%     figName = fullfile(figFldr, [curFol, '.fig']);
%     savefig(figName)

%     matName = fullfile(figFldr, [curFol, '.mat']);
%     save(matName)

fprintf('\n')
end