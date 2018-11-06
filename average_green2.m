function [green_mean] = average_green2(skin_map)
[m,n,s]=size(skin_map);
for f=1:1:s
    skin_A = double(skin_map(:,:,f));
    skin_A(skin_A == 0) = NaN;
    skin_A = filloutliers(skin_A,'next');
    M = nanmedian(skin_A);
    green_mean(f) = nanmean(M,2);
end
end