function skin = skin_detector3(img)

    %Detection of Face on the basis of skin color
    %clear all;
    %close all;
    %clc

    %colorimage = uigetfile('Frames/');
    %path = strcat('Frames/',colorimage(1:end-16),'/',colorimage)
    %I = imread(path);
    
    %% Skin detection 1
    img = I;
    imshow(I)
    I = grayworld(I);
    imshow(I)
    %% Trasformo in lab
    cform = makecform('srgb2lab');
    J = applycform(I,cform);
    figure;imshow(J);
    K=J(:,:,2);
    figure;imshow(K);
    %% Sogliatura su a
    L=graythresh(J(:,:,2)); %otsu
    BW1=im2bw(J(:,:,2),L);
    figure;imshow(BW1);
    %% Sogliatura su b
    M=graythresh(J(:,:,3)); %otsu
    figure;imshow(J(:,:,3));
    BW2=im2bw(J(:,:,3),M);
    figure;imshow(BW2);
    %% Unisco a e b
    O=BW1.*BW2;

    %% Bounding box
    P=bwlabel(O,8);
    BB=regionprops(P,'Boundingbox');
    BB1=struct2cell(BB);
    BB2=cell2mat(BB1);

    [s1 s2]=size(BB2);
    mx=0;
    % cerco l'area maggiore
    for k=3:4:s2-1
        p=BB2(1,k)*BB2(1,k+1);
        if p>mx & (BB2(1,k)/BB2(1,k+1))<1.8
            mx=p; %aggiorno valore area maggiore
            j=k; %aggiorno indice area maggiore
        end
    end
    figure,imshow(I);
    hold on;
    rectangle('Position',[BB2(1,j-2),BB2(1,j-1),BB2(1,j),BB2(1,j+1)],'EdgeColor','r' )

    img = imcrop(I,[BB2(1,j-2),BB2(1,j-1),BB2(1,j),BB2(1,j+1)]);
    figure;
    imshow(img);

    %% Skin Detection 2
    cform = makecform('srgb2lab');
    J = applycform(img,cform);
    figure;imshow(J);
    K=J(:,:,2);
    figure;imshow(K);
    %% Sogliatura su a
    L=graythresh(J(:,:,2)); %otsu
    BW1=im2bw(J(:,:,2),L);
    figure;imshow(BW1);
    %% Sogliatura su b
    M=graythresh(J(:,:,3)); %otsu
    figure;imshow(J(:,:,3));
    BW2=im2bw(J(:,:,3),M);
    figure;imshow(BW2);
    %% Unisco a e b
    O=BW1.*BW2;
    figure;imshow(O);
    skin = O;
    
end