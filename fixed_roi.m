function [skin_map] = fixed_roi(soggetto,frame_start,frame_finish)
 soggetto1 = '2m110511_1a';
% frame_start = 65*25;
% frame_finish = 65*25;
i = 1;
figure(2);
start = frame_start - 1500;
finish = frame_finish;
%% Carico Landmarks
path = strcat('landmarks/',soggetto1,'.mat');
M = load(path);
M = M.landmarks;   
%% Ciclo  
for j=start:5:finish %%start e finish definiscono l'ampiezza della finestra
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
    %close all;
    path = strcat('Frames/',soggetto,'_cut/',soggetto,'_cut_frame_',number,'.jpg');
    %[imgName, path] = uigetfile('Frames/*.jpg*', 'pick up 1 RGB image');
    img = imread(path);
    [nrows,ncols, ~] = size(img);
    
    %% Determino Viso
%     faceDetector = vision.CascadeObjectDetector;
%     ROI = faceDetector(img);
    
    %% Calcolo ROI
    y1 = M(i,37,2);
    y2 = M(i,21,2);
    d = y1-y2;
    x = M(i,28,1);
    y = M(i,28,2)-d;

    e1 = x;
    e2 = y;
    a1 = e1 - (5/2)*d;
    a2 = y;
    b1 = a1;
    b2 = a2 - 3 * (d/2);
    c1 = e1;
    c2 = b2;

    c = [a1 b1 c1 e1];
    r = [a2 b2 c2 e2];
    
    img = img(:,:,2);
    BW = roipoly(img,c,r);
    ROI = uint8(BW).*uint8(img);
    

    %% Output
    
    c = [a1 b1 c1 e1 a1];
    r = [a2 b2 c2 e2 a2];
    imshow(img);
    hold on
    plot(c,r);
    
    skin_map(:,:,:,i) = ROI;
    number
    %% 
    i = i+5;
end
end










