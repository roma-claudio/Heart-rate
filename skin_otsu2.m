function [skin_map] = skin_otsu2(soggetto,frame_start,frame_finish)

    i = 1;
    figure(2);
    start = frame_start - 1500;
    finish = frame_finish;
    nframe = finish-start;
    path = strcat('Frames/',soggetto,'_cut/',soggetto,'_cut_frame_00001.jpg');
    img = imread(path);
    face = face_detection(img);
    %img = imcrop(img,face);
    %skin_map = zeros(face(4)+1,face(3)+1,nframe,'uint8');
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
%         img2 = imcrop(img,face);
%         skin2 = img2(:,:,:);
%         skin_map(:,:,:,i) = skin2;
%         imshow(skin2);
        face = face_detection(img);
        skin1 = skin_detector_otsu2(img,face);
        [x,y]=size(skin1);
        skin_map(1:x,1:y,1:3,i) = skin1
        imshow(skin1);
        number
        %% 
        i = i+5;
        if j == start
            saveas(gcf,soggetto,'jpeg');
        end
    end
end


