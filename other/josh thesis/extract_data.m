pixelx = 25; pixely = 27;

aMatrix = all_normal_matrix;
aMatrix(:,96:99,:) = [];
aMatrix(41:end,:,:) = [];
aMatrix(1:8,:,:) = [];
aMatrix(:,1:3,:) = [];
aMatrix(:,end-1:end,:) = [];

wofilter_aMatrix = aMatrix;
wofilter_aMatrix(:,3:4:end,:) = [];
wofilter_aMatrix(:,3:3:end,:) = [];

wfilter_aMatrix = aMatrix;
wfilter_aMatrix(:,1:4:end,:) = [];
wfilter_aMatrix(:,1:3:end,:) = [];

%select matrix to use here
useMatrix = aMatrix;
wfilter_matrix = wfilter_aMatrix;
wofilter_matrix = wofilter_aMatrix;

%Get difference, min, max
num_col = min(size(wofilter_matrix, 2), size(wfilter_matrix, 2));
diff_Matrix = (wofilter_matrix(:,1:num_col,:) - wfilter_matrix(:,1:num_col,:));
normalized_Matrix = diff_Matrix./wfilter_matrix(:,1:num_col,:);