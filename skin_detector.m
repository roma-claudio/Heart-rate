function [skin_map] = skin_detector(soggetto,frame_start,frame_finish,metodo)
% soggetto = '2m110511_1a';
% frame_start = 1625;
% frame_finish = 2125;
% metodo = 'arbib';
i = 1;
figure(1);
start = frame_start - 1500;
finish = frame_finish;
length_skin_map = frame_finish - frame_start;
skin_map = zeros(576,720,length_skin_map,'uint8');
%% Setting parametri
    method = metodo; % IN ALTERNATIVA PROVA: 'arbib''jrmogskin''kmeans'
    featType = 5; % QUESTO INDICE TI PERMETTE DI SELEZIONARE IL FEATURE TYPE TRA 1:6
    nClusters = 5; %NUMERO DI CLUSTERS

    display = 1; %FLAG PER ATTIVARE/DISATTIVARE LA VISUALIZZAZIONE 
%% Ciclo
for j=start:5:finish
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

    x = num2str(j)
    number = strcat(nFrame,x)
    %close all;
    path = strcat('Frames/',soggetto,'_cut/',soggetto,'_cut_frame_',number,'.jpg')
    %[imgName, path] = uigetfile('Frames/*.jpg*', 'pick up 1 RGB image');
    img = imread(path);
    img = grayworld(img);
    [nrows,ncols, ~] = size(img);

    %% Step 2: Converto spazio colore in base a featType
    typeFeat = [{'gray'}, {'gray+XY'}, {'RGB'}, {'RGB+XY'}, {'Lab'}, {'Lab+XY'}];
    features = computeFeatures(img, typeFeat{featType});

    %% Eseguo clustering
    switch method
        case{'kmeans'}
            [cluster_idx,centroids] = kmeans(features, nClusters); 
        case{'arbib'}
            if i==1
                centroids = arbib_centroids(features,nClusters);
                cluster_idx = arbib_indices(features,centroids);
                
                pixel_labels = reshape( cluster_idx, nrows, ncols ); %IMMAGINE DELLE ETICHETTE ( DA 1 A "nClusters")
                %% COSTRUZIONE DI UN ARRAY DI CELLE (UNA PER OGNI CLUSTER) 
                segmented_images = cell( 1, nClusters);
                rgb_label = repmat( pixel_labels, [1 1 3] );

                for k = 1:nClusters
                    color = img;
                    color( rgb_label ~= k ) = 0;
                    segmented_images{k} = color; 
                end
                
                %% Show Image
                n = 4; % colonne subplot
                m = 3 %ceil( ( 2+1 ) / n ); % righe subplot
                % fig = figure( 'name', [method ' clustering in ' typeFeat{featType} ' feature space']);
                hold on;
                figure(1);
                subplot( m, n, i );
                imshow( img );
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
                %% Cluster choice
                
                prompt = 'Quale classe scelgo? ';
                cluster_scelto = input(prompt)
                
                %% Salvo immagine
                close all
                imshow( segmented_images{cluster_scelto} );
                saveas(gcf,soggetto,'jpeg');
                
            else
                cluster_idx = arbib_indices(features,centroids);
                
                pixel_labels = reshape( cluster_idx, nrows, ncols ); %IMMAGINE DELLE ETICHETTE ( DA 1 A "nClusters")
                %% COSTRUZIONE DI UN ARRAY DI CELLE (UNA PER OGNI CLUSTER) 
                segmented_images = cell( 1, nClusters);
                rgb_label = repmat( pixel_labels, [1 1 3] );

                for k = 1:nClusters
                    color = img;
                    color( rgb_label ~= k ) = 0;
                    segmented_images{k} = color; 
                end
               
            end
            skin = imbinarize(segmented_images{cluster_scelto}(:,:,2));
        case {'jrmogskin'}
            skin = jrmogskin(img);
            
        otherwise
            error('Input a valid clustering method');
    end
    
    %% Region_props
    BW = imbinarize(segmented_images{cluster_scelto}(:,:,2));
    BW = skin;
    L = bwlabel(BW);
    area = regionprops(BW,'boundingbox', 'area');
    [m_area, i_area]=max([area.Area]);
    imcropped = ismember(L,i_area);
%     figure(4);
%     imshow(imcropped)
    
    %% Morfologia
    
    SE = strel('sphere',2);
    morph = imopen(imcropped,SE);
    %figure(5);
    morph = uint8(morph);
    ROI = morph.*img(:,:,2);
    %ROI = uint8(imcropped).*uint8(img(:,:,2));
    imshow(ROI);
    
    %% Output
    skin_map(:,:,i)=ROI;
    number
    
    %% 
    i = i+5;
end
imshow(ROI);
end










