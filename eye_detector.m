function [skin_map] = eye_detector(soggetto,frame_start,frame_finish)

    i = 1;
    figure(2);
    start = frame_start - 1500;
    finish = frame_finish;
    nframe = finish-start;
    path = strcat('Frames/',soggetto,'_cut/',soggetto,'_cut_frame_00001.jpg');
    img = imread(path);
    EyeDetect = vision.CascadeObjectDetector('EyePairBig');
    %img = imcrop(img,face);
    %skin_map = zeros(576,720,nframe,'uint8');
%     [x,y,z] = size(img);
%     skin_map = zeros(x,y,nframe,'uint8');
    figure(2);
    
    
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
        path = strcat('Frames/',soggetto,'_cut/',soggetto,'_cut_frame_',number,'.jpg');
        img = imread(path);
        BB=step(EyeDetect,img);
        BB=int32(BB)
        if isempty(BB)
            BB = [172,266,212,52];
            img2 = imcrop(img,BB(1,:));
            skin2 = img2(:,:,2);
            [x,y]=size(skin2);
            skin_map(1:x,1:y,i) = skin2;
        else
            img2 = imcrop(img,BB(1,:));
            skin2 = img2(:,:,2);
            [x,y]=size(skin2);
            skin_map(1:x,1:y,i) = skin2;
            imshow(skin2);
        end
        %face = face_detection(img);
        %skin1 = skin_detector_otsu(img,face);
        %skin_map(:,:,i) = skin1;
        %imshow(skin1);
        number
        %% 
        i = i+5;
        if j == start
            saveas(gcf,soggetto,'jpeg');
        end
    end
end


