close all
colorimage = uigetfile('Frames/');
path = strcat('Frames/',colorimage(1:end-16),'/',colorimage)
img = imread(path);
imshow(img);
EyeDetect = vision.CascadeObjectDetector('EyePairBig');
BB=step(EyeDetect,img);
hold on
rectangle('Position',BB,'LineWidth',2,'LineStyle','-','EdgeColor','b');