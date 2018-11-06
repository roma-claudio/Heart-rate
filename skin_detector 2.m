function [skin_map] = skin_detector(soggetto)
for j=125:1:127
%% Setting parametri
method = 'arbib'; % IN ALTERNATIVA PROVA: 'kmeans'
featType = 5; % QUESTO INDICE TI PERMETTE DI SELEZIONARE IL FEATURE TYPE TRA 1:6
nClusters = 4; %NUMERO DI CLUSTERS

display = 1; %FLAG PER ATTIVARE/DISATTIVARE LA VISUALIZZAZIONE 

%% Step 1: Leggo immagine
nFrame = '';
if j<10
    nFrame = '0000';
else if j<100
        nFrame = '000';
    else if j<1000
            nFrame = '00';
        else if j<10000
                nFrame = '0';
            end
        end
    end
end
            
x = num2str(j);
number = strcat(nFrame,x);
close all;
path = strcat('Frames/',soggetto,'_cut/',soggetto,'_cut_frame_',number,'.jpg')
%[imgName, path] = uigetfile('Frames/*.jpg*', 'pick up 1 RGB image');
img = imread(path);
[nrows,ncols, ~] = size(img);

%% Step 2: Converto spazio colore in base a featType
typeFeat = [{'gray'}, {'gray+XY'}, {'RGB'}, {'RGB+XY'}, {'Lab'}, {'Lab+XY'}];
features = computeFeatures(img, typeFeat{featType});

%% Eseguo clustering
switch method
    case{'kmeans'}
        [cluster_idx,centroids] = kmeans(features, nClusters); 
    case{'arbib'}
        [cluster_idx,centroids] = arbib(features,nClusters);
    otherwise
        error('Input a valid clustering method');
end

pixel_labels = reshape( cluster_idx, nrows, ncols ); %IMMAGINE DELLE ETICHETTE ( DA 1 A "nClusters")

%% COSTRUZIONE DI UN ARRAY DI CELLE (UNA PER OGNI CLUSTER) 
segmented_images = cell( 1, nClusters);
rgb_label = repmat( pixel_labels, [1 1 3] );

for k = 1:nClusters
    color = img;
    color( rgb_label ~= k ) = 0;
    segmented_images{k} = color; 
end
 

% Display
n = 3; % colonne subplot
m = ceil( ( nClusters + 2 ) / n ); % righe subplot
fig = figure( 'name', [method ' clustering in ' typeFeat{featType} ' feature space']);
hold on
subplot( m, n, 1 )
imshow( img )
text(size( img,2), size(img,1)+15,...
     'originale', ...
     'FontSize',7,'HorizontalAlignment','right');
subplot( m, n, 2 );
imshow( pixel_labels,[] )
text(size( pixel_labels,2), size(pixel_labels,1)+15,...
     'etichette', ...
     'FontSize',7,'HorizontalAlignment','right');
for k = 1:nClusters
    subplot( m, n, 2+k )
    imshow( segmented_images{k} );
    text(size( segmented_images{k},2), size(segmented_images{k},1)+15,...
     [ 'cluster ' num2str(k) ], ...
     'FontSize',7,'HorizontalAlignment','right');
end
hold off


%% Analisi statistica
figure;
[m,n]=size(segmented_images{4}(:,:,3));

for i=1:1:m
    for j=1:1:n
        if segmented_images{4}(i,j,3) > 125
            segmented_images{4}(i,j,:)= 0;
        end
    end
end
imshow(segmented_images{4});
%% Output
skin_map(:,:,:,j)=segmented_images{4};
number
end
end










