%% Seleziono soggetto
clc;
close all;
clear all;
soggetto = uigetdir('Frames/');
soggetto = soggetto(59:end-4)
%% Ciclo su tutti i soggetti
%   for h=10:1:39
%     frames = dir('Frames');
%     soggetto = frames(h).name;
%     soggetto = soggetto(1:end-4);
    %% Definisco secondi da analizzare
    start = 65;
    finish = 250;
    j = 1;
    %% Calcolo bpm tramite bvp
%     size_bpm = ((finish-start)/5)+1;
%     bpm = zeros(1,size_bpm);
%     for i=start:5:finish
%         bpm(j) = bpm_reader(soggetto(1:end-1),i);
%         j = j+1;
%     end
    
    %% Skin detection
    %Ridimensiono la finestra
    start = start*25;
    finish = finish*25;
    metodo = ''; %in alternativa usare kmeans o arbib o jrmogskin o skin_detector3
    %green = zeros(j,60);
%   skin = skin_otsu(soggetto,start,finish);
%   skin = skin_detector(soggetto,start,finish,metodo);
    skin = fixed_roi(soggetto,start,finish);
%   skin = eye_detector(soggetto,start,finish);
    green = average_green(skin);
    %% Interpolazione skin2
    green(isnan(green))=0;
    [col,index,value]=find(green);
    j=1; %indice dei valori reali
    for i=1:5:max(index)-1
        i
        z= i+1:i+4 %indice dei valori interpolati
        ind=[index(j),index(j+1)]
        val=[value(j),value(j+1)];
        green(z)=interp1(ind,val,z);
        j=j+1
    end

    %% Creo struttura
    bpm_metodo =  zeros(1,length(bpm));

    %% Dominio delle frequenze
    bpFilt = designfilt('bandpassfir','FilterOrder',32, ...
         'CutoffFrequency1',0.65,'CutoffFrequency2',3, ...
         'SampleRate',25,'Window','hamming');
    k = finish - start;
    i=1;
    for j=1:125:k+1
        green_local = green(j:j+1500);
        green_local = filtfilt(bpFilt,green_local);
        green_local = filtfilt(bpFilt,green_local);
%         green_local = filtfilt(bpFilt,green_local);
        mean_green = mean(green_local);
        green_local = green_local - mean_green;
        
        %% Trasformata green_1
        L = length(green_local); %lunghezza del segnale
        Fs = 25; %frequenza di campionamento
        G = fft(green_local);
        P2 = abs(G/L);
        P1 = P2(1:floor(L/2+1));
        P1(2:end-1) = 2*P1(2:end-1);
        f = Fs*(0:(L/2))/L;
        plot(f,P1)
        
        %% cerco il massimo locale green_1
        indx = find(f>=0.85 & f<=2);
        [P1_max_value,P1_max_index] = max(G(indx(1):indx(end)));
        P1_max = f(indx(1)+P1_max_index-1);
        %diff = P1_max-0.7;
        bpm_metodo1(i)= 51+60*(P1_max-0.85);
        bpm;
        i=i+1;
        
    end
%     figure(3);
%     hold on
%     path = strcat('Frames/',soggetto,'_cut/',soggetto,'_cut_frame_00001.jpg');
%     img = imread(path);
%     face = face_detection(img);
%     h = 1;
%     j = 1;
%     for i=start:5:(finish-start)
%         green_local = green(i-1500:i);
%         green_local = filtfilt(bpFilt,green_local);
%         mean_green = mean(green_local);
%         green_local = green_local - mean_green;
%         subplot(3,2,1);
%         plot(green_local)
%         subplot(3,2,2);
%         L = length(green_local); %lunghezza del segnale
%         Fs = 25; %frequenza di campionamento
%         G = fft(green_local);
%         P2 = abs(G/L);
%         P1 = P2(1:floor(L/2+1));
%         P1(2:end-1) = 2*P1(2:end-1);
%         f = Fs*(0:(L/2))/L;
%         plot(f,P1)
%         xlim([0.75 4]);
%         ylim([0 0.1]);
%         subplot(2,2,3);
%         nFrame = '';
%         if i<10
%             nFrame = '0000';
%         else if i<100
%                 nFrame = '000';
%             else if i<1000
%                     nFrame = '00';
%                 else if i<10000
%                         nFrame = '0';
%                     end
%                 end
%             end
%         end
%         x = num2str(i);
%         number = strcat(nFrame,x);
%         path = strcat('Frames/',soggetto,'_cut/',soggetto,'_cut_frame_',number,'.jpg');
%         img = imread(path);
%         img = imcrop(img,face);
%         imshow(img(:,:,2))
%         subplot(3,2,4);
%         diff = abs(bpm_metodo1(j) - bpm(j));
%         chr = int2str(diff);
%         if diff>6
%             hText=text(0.5,0.5,chr,'Color','red'); axis off
%         else
%             hText=text(0.5,0.5,chr); axis off
%         end
%         pause(0.05)
%         delete(hText);
%         if h > 25 
%             j = j+1;
%             h = 1;
%         end    
%         h = h+1;
%         subplot(3,2,5)
%         plot(bpm(1:j));
%         subplot(3,2,6)
%         plot(bpm_metodo1(1:j));
%     end
    
    figure(4);
    subplot(1,2,1);
    plot(bpm)
    subplot(1,2,2);
    plot(bpm_metodo1)

    %% Salvataggio dati
    
    bpm_all = [bpm.' bpm_metodo1.'];
    soggetto_str = strcat(soggetto,'_',metodo,'.csv');
    csvwrite(soggetto_str, bpm_all);

    %% Libero GUI
    close all
 %end