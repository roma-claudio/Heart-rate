function skin = skin_detector3(img,face,skin)

    %% Load image
    img2 = img; 
    img = imcrop(img,face);
    I = img;

    %% Skin Detection 2
    cform = makecform('srgb2lab');
    J = applycform(I,cform);
    %figure;imshow(J);
    K=J(:,:,2);
    %figure;imshow(K);
    %% Sogliatura su a
    L=graythresh(J(:,:,2)); %otsu
    BW1=imbinarize(J(:,:,2),L);
    %figure;imshow(BW1);
    %% Sogliatura su b
    M=graythresh(J(:,:,3)); %otsu
    %figure;imshow(J(:,:,3));
    BW2=imbinarize(J(:,:,3),M);
    %figure;imshow(BW2);
    %% Unisco a e b
    O=BW1.*BW2;
    %O=BW1;
    %SE = strel('sphere',3);
    %O = imopen(O,SE);
    img2 = img2(:,:,2);
    skin = img(:,:,2).*uint8(O);
    
    %figure;
    %imshow(skin);
    %imshow(img2);
    
    %% Ridimensiono array
%     vert = size(img2,1)-size(skin,1);
%     zero_1 = zeros(vert,size(skin,2),'uint8');
%     horiz = size(img2,2)-size(skin,2);
%     zero_2 = zeros(size(img2,1),horiz,'uint8');
%     skin = cat(1,skin,zero_1);
%     skin = cat(2,skin,zero_2);
    
end