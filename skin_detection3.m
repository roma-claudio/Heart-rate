function [skin_map1, skin_map2] = skin_otsu(soggetto,frame_start,frame_finish)

    i = 1;
    figure(2);
    start = frame_start - 1500;
    finish = frame_finish;
    nframe = finish-start;
    path = strcat('Frames/',soggetto,'_cut/',soggetto,'_cut_frame_00001.jpg');
    img = imread(path);
    face = face_detection(img);
    img = imcrop(img,face);
    [x,y,z] = size(img);
    skin_map2 = zeros(x,y,nframe,'uint8');
    skin_map1 = zeros(face(4),face(3),nframe,'uint8');
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
        %close all;
        path = strcat('Frames/',soggetto,'_cut/',soggetto,'_cut_frame_',number,'.jpg');
        %[imgName, path] = uigetfile('Frames/*.jpg*', 'pick up 1 RGB image');
        img = imread(path);
        img2 = imcrop(img,face);
        skin2 = img2(:,:,2);
        
        skin_map2(:,:,i) = skin2;
        imshow(skin2);
        %face = face_detection(img);
        %skin1 = skin_detector3(img,face);
        %skin_map1(:,:,i) = skin1;
        %subplot(1,2,1);
        %imshow(skin1)
        %subplot(1,2,2);
        %imshow(skin2);
        number
        %% 
        i = i+5;
        if j == start
            saveas(gcf,soggetto,'jpeg');
        end
    end
end


