function [green_mean] = average_green(skin_map)
[m,n,s]=size(skin_map);
for f=1:1:s
    skin_A = double(skin_map(:,:,f));
    skin_A(skin_A == 0) = NaN;
    M = nanmean(skin_A);
    green_mean(f) = nanmean(M,2);
end
end