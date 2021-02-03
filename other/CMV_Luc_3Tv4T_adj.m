close all
clearvars
% Define files and lists
folList = {'4T-APS CMV-Luc','3T-APS CMV-Luc'};
titleList = {'4T-APS CMV-FLuc','3T-APS CMV-Luc'};
matFldr = 'mat files';
figFldr = 'fig files';
nTrial = 2;

% Create figure windows, one for each type of plot across trials/folders
fig_mean1 = figure( 'Units', 'normalized', 'Position', [0 0.5 1 1] );
fig_mean2 = figure( 'Units', 'normalized', 'Position', [0 0.5 1 1] );
fig_mean3 = figure( 'Units', 'normalized', 'Position', [0 0.5 1 1] );

if ~exist(matFldr, 'dir')
    mkdir(matFldr)
end

if ~exist(figFldr, 'dir')
    mkdir(figFldr)
end

for fileI = 1:nTrial
    clearvars -except folList titleList fileI matFldr figFldr nTrial fig_mean1 fig_mean2 fig_mean3 fig_mean4
    F0_id = [];
    curFol = folList{fileI};
    fprintf('Processing %s\n', curFol)
    
    fileName = fullfile('mat files', [curFol, '.mat']); %%fileName of .mat file - fullfile generates/goes to the path
    
    %if mat files are already available
    
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
        %mean_backgroundImage = mean(backgroundImage, 'all');
        all_image_matrix(:,:,frame_start:frame_end) = imageData;
        all_normal_matrix(:,:,frame_start:frame_end) = normalImage;
        
        
        
        if strfind(currentFile,'Frame0-')
            F0_id = [F0_id,frame_start];
        end
        
        % counter for all frames in file (start of next file)
        frame_start = frame_end + 1;
        
    end
    %fileName = fullfile(matFldr, [curFol, '.mat']);
    %save(fileName, 'all_normal_matrix', 'fps', 'all_image_matrix', 'backgroundImage','F0_id')
    
    fprintf('Trimming Matrices for %s\n', curFol)
    
    aMatrix = all_normal_matrix;
    aMatrix(:,95:98,:) = [];
    aMatrix(41:end,:,:) = [];
    aMatrix(1:8,:,:) = [];
    aMatrix(:,1:3,:) = [];
    aMatrix(:,end-1:end,:) = [];
    
    fprintf('Separating Matrices for %s\n', curFol)
    
    switch fileI
        case {2}
            
            wfilter_aMatrix = aMatrix;
            wfilter_aMatrix(:,3:4:end,:) = [];
            wfilter_aMatrix(:,3:3:end,:) = [];
            wfilter_aMatrix = wfilter_aMatrix(:,:,1:172);
            
            wofilter_aMatrix = aMatrix;
            wofilter_aMatrix(:,1:4:end,:) = [];
            wofilter_aMatrix(:,1:3:end,:) = [];
            wofilter_aMatrix = wofilter_aMatrix(:,:,1:172);
            
        case {1}
            
            wofilter_aMatrix = aMatrix;
            wofilter_aMatrix(:,3:4:end,:) = [];
            wofilter_aMatrix(:,3:3:end,:) = [];
            
            wfilter_aMatrix = aMatrix;
            wfilter_aMatrix(:,1:4:end,:) = [];
            wfilter_aMatrix(:,1:3:end,:) = [];
            
    end
    
    
    %select matrix to use here
    useMatrix = aMatrix;
    wfilter_matrix = -(wfilter_aMatrix);
    wofilter_matrix = -(wofilter_aMatrix);
    
    %%  PARAMETER COMPUTATION CODES
    fprintf('Getting parameters for %s\n', curFol)
    
    %Get difference, min, max
    num_col = min(size(wofilter_matrix, 2), size(wfilter_matrix, 2));
    diff_Matrix = (wofilter_matrix(:,1:num_col,:) - wfilter_matrix(:,1:num_col,:));
    normalized_Matrix = diff_Matrix./wfilter_matrix(:,1:num_col,:);
    
    %minVal = prctile(useMatrix(:), 2.5);
    %maxVal = prctile(useMatrix(:), 97.5);
    
    %Get mean and stdev
    mean_of_mat1 = [];
    for fileInd = 1:size(wofilter_matrix, 3)
        %get matrix to plot
        curMat1 = wofilter_matrix(:,:, fileInd); %curMat gets the x,y of each frame
        mean_of_mat1(fileInd) = mean(curMat1(:)); %sum of Mat gets the total sum of x and y per curMat
        std_of_mat1(fileInd) = std(curMat1(:))./sqrt(size(curMat1(:),1));
    end
    
    mean_of_mat2 = [];
    for fileInd = 1:size(wfilter_matrix, 3)
        %get matrix to plot
        curMat2 = wfilter_matrix(:,:, fileInd); %curMat gets the x,y of each frame
        mean_of_mat2(fileInd) = mean(curMat2(:)); %sum of Mat gets the total sum of x and y per curMat
        std_of_mat2(fileInd) = std(curMat2(:))./sqrt(size(curMat2(:),1));
    end
    
    mean_of_mat3 = [];
    for fileInd = 1:size(diff_Matrix, 3)
        %get matrix to plot
        curMat3 = diff_Matrix(:,:, fileInd); %curMat gets the x,y of each frame
        mean_of_mat3(fileInd) = mean(curMat3(:)); %sum of Mat gets the total sum of x and y per curMat
        std_of_mat3(fileInd) = std(curMat3(:))./sqrt(size(curMat3(:),1));
    end
    
    mean_of_mat4 = [];
    for fileInd = 1:size(normalized_Matrix, 3)
        %get matrix to plot
        curMat4 = normalized_Matrix(:,:, fileInd); %curMat gets the x,y of each frame
        tCM4 = curMat4(isfinite(curMat4));
        tCM4 = tCM4(:);
        mean_of_mat4(fileInd) = mean(tCM4); %sum of Mat gets the total sum of x and y per curMat
        std_of_mat4(fileInd) = nanstd(tCM4)./sqrt(numel(tCM4));
    end
    %minVal4 = prctile(mean_of_mat4(:), 2.5);
    %maxVal4 = prctile(mean_of_mat4(:), 97.5);
    
    
    %get time markers
    convX = 60; %how many seconds to one interval?
    everyTick = 1; %1 intervals of convX is one tick
    tkmarkers = [1:size(all_normal_matrix,3)]; %gets number of frames into a 1D sequence
    tkmarker_mins = tkmarkers./fps/convX; %equation for converting frames to desired time interval (convX)
    [~,timepos] = min(abs(tkmarker_mins-1)); %gets the frame closest to one interval/ gets the number of frames for one interval
    tMarkers = [1:timepos*everyTick:size(all_normal_matrix,3)]; %multiplies to number of intervals for each tick
    tMarker_ticks = tMarkers./fps/convX; %equation for converting frames to ticks
    
    
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
    
    
    xlabel('Minutes','FontSize', 14);
    xlim([0 222])
    title(titleList{fileI});
    legend1 = legend({'with filter', 'without filter'});
    set(legend1, 'Location', 'best');
    set(gca, 'FontSize', 24);
    ylabel('Pixel Value (D.N.)','FontSize', 20);
    
    set(gca, 'xtick', tMarkers);
    tklabels = num2cell(tMarker_ticks);
    fun = @(x) sprintf('%0.0f', x);
    tklabels = cellfun(fun, tklabels, 'UniformOutput',0);
    set(gca, 'xticklabels', tklabels);
    %xtickangle(90);
    
    % Plot for Line 2 - Difference of mean
    figure(fig_mean2) %%%% call appropriate figure where line 1 will be plotted
    subplot(nTrial,1,fileI) %%%% fileI to indicate the index for subplot
    
    pl = plot(mean_of_mat3, 'LineWidth', 3,'Color',[0.96 0.71 0.15]);
    hold on
    errorbar(mean_of_mat3, std_of_mat3, 'Color', [0.96, 0.88, 0.70]);
    uistack(pl,'top')
    
    
    %     ylim([0 100])
    xlabel('Minutes','FontSize', 14);
    xlim([0 222])
    
    title([titleList{fileI}, ' (Difference)']);
    set(gca, 'xtick', tMarkers);
    set(gca, 'xticklabels', tklabels);
    %     ylim ([-1 50]);
    %yticks ([0:10:40])
    %xtickangle(90);
    set(gca, 'FontSize', 24);
    ylabel('Pixel Value (D.N.)','FontSize', 20);
    
    % Plot for Line 3 - Normalized difference
    figure(fig_mean3) %%%% call appropriate figure where line 1 will be plotted
    subplot(nTrial,1,fileI) %%%% fileI to indicate the index for subplot
    
    pl = plot(mean_of_mat4,'LineWidth', 3, 'Color', [0.64 0.26 0.70]);
    hold on
    errorbar(mean_of_mat4, std_of_mat4, 'Color', [0.7, 0.57, 0.72]);
    uistack(pl,'top')
    
    
    xlabel('Minutes','FontSize', 14);
    xlim([0 222])
    title([titleList{fileI}, ' (Normalized)']);
    set(gca, 'xtick', tMarkers);
    set(gca, 'xticklabels', tklabels);
    %xtickangle(90);
    set(gca, 'FontSize', 24);
    ylabel('Pixel Value (D.N.)','FontSize', 20);
    
    fprintf('\n')
    
    fileName = fullfile(matFldr, [curFol, '.mat']);
    save(fileName, 'all_normal_matrix', 'fps', 'all_image_matrix', 'backgroundImage','F0_id',...
        'wfilter_matrix', 'wofilter_matrix', 'diff_Matrix', 'normalized_Matrix',...
        'mean_of_mat1', 'mean_of_mat2', 'mean_of_mat3', 'mean_of_mat4',...
        'std_of_mat1', 'std_of_mat2', 'std_of_mat3', 'std_of_mat4', ...
        'tMarkers', 'tklabels' )
end
