close all
colorimage = uigetfile('Frames/');
path = strcat('Frames/',colorimage(1:end-16),'/',colorimage)
img = imread(path);
img2 = grayworld(img);
subplot(2,1,1)
imshow(img);
subplot(2,1,2);
imshow(img2);