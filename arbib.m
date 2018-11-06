function [indices,centroids] = arbib(pixels,clusNb,nu)

if nargin<1;error('Input the linearized image pixels!');end
if nargin<2;clusNb=2;end
if nargin<3;nu=0.15;end

% parameters
theta = round(400 * sqrt(clusNb));                     % maximum cluster cardinality
N = (2 * clusNb - 3) * theta * (clusNb + 7);    % max iterations (see Uchiyama, Arbib, '94 article)

% initialization
pixNb = size(pixels,1);

centroids = struct('value',{},'counts',{});
centroids(1).value = mean(pixels,1);
centroids(1).counts = 0;

% estimate clusters
for i = 1:N
    % pick a random pixel
    pixel = pixels(round(1+rand()*(pixNb-1)),:);
    
    % assign it to a cluster
    distances = zeros(numel(centroids),1);
    for c = 1:numel(centroids)
        distances(c) = norm(centroids(c).value-pixel);
    end
    [~,idx] = min(distances);
    
    % update the cluster
    centroids(idx).value = centroids(idx).value + nu*(pixel-centroids(idx).value);
    centroids(idx).counts = centroids(idx).counts + 1;
    
    % check for cluster splitting
    if centroids(idx).counts == theta && numel(centroids)<clusNb
        centroids(end+1).value = centroids(idx).value;
        centroids(end).counts = 0;
        centroids(idx).counts = 0;
    end
end

% actual image clustering
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







