%% Seleziono soggetto
soggetto = uigetdir('Frames/');
soggetto = soggetto(53:end-4)
%% 
bpm = bpm_reader(soggetto)
skin = skin_detector(soggetto);
%green = average_green(skin);