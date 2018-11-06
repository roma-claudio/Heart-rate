colorimage = uigetfile('Frames/');
path = strcat('Frames/',colorimage(1:end-16),'/',colorimage)
img = imread(path);
