function H = hDistance(mat1, mat2)

nbin = 200;

min_bin = min( min(mat1(~isinf(mat1))), min(mat2(~isinf(mat2))) );
max_bin = max( max(mat1(~isinf(mat1))), max(mat2(~isinf(mat2))) );
bin_step = (max_bin - min_bin) / nbin;

bin = min_bin:bin_step:max_bin;

mat1_pdf = histcounts(mat1, bin);
mat2_pdf = histcounts(mat2, bin);

H = sqrt(sum( ( sqrt(mat2_pdf/sum(mat2_pdf)) ...
    - sqrt(mat1_pdf/sum(mat1_pdf)) ).^2) ) ./ sqrt(2);
end