%% Seleziono soggetto
soggetto = uigetdir('Frames/');
soggetto = soggetto(39:end-4)
%% 
bpm = bpm_reader(soggetto);
skin = skin_detector(soggetto);
%green = average_green(skin);