function [skin_map] = skin_detection3(soggetto,frame_start,frame_finish)

    i = 1;
    figure(2);
    start = frame_start - 1500;
    finish = frame_finish;
    
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
        skin = skin_detector3(img);
        skin_map(:,:,:,i) = skin;
        number
        %% 
        i = i+5;

    end
end


