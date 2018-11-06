clc;
clear all;
close all;
soggetto = uigetfile('Frames/Video/');
soggetto = soggetto(1:end-4);
path = strcat('E:\Video\',soggetto,'.avi');
vid = VideoReader(path);
n = vid.NumberOfFrames;
mkdir(soggetto);
for i=1:1:7000
   frames = read(vid,i);
   FixedFrameNumber = sprintf('%05d',i);
   path = strcat('E:\Frames\',soggetto,'\',soggetto,'_frame_',FixedFrameNumber,'.jpg')
   imwrite(frames,path);
end
