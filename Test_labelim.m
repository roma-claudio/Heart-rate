clc;
clear all;
img = uigetfile('*.jpg');
img = strcat('Frames/',img(1:end-16),'/',img);
img = imread(img);
imshow(img);
skin = jrmogskin(img);
imshow(skin);