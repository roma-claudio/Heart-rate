function [indices] = arbib_indices(pixels,centroids)

pixNb = size(pixels,1);
indices = zeros(size(pixels,1),1);

for p = 1:pixNb
    distances = zeros(numel(centroids),1);
    for c = 1:numel(centroids)
        distances(c) = norm(centroids(c).value-pixels(p,:));
    end
    [~,idx] = min(distances);

    indices(p) = idx;
end

centroids = cat(1,centroids(:).value);

end % function
