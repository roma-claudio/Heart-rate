
function [bpm2] = bpm_reader(soggetto,secondi)

% soggetto = uigetdir('Frames/');
% soggetto = soggetto(59:end-5)
% secondi = 250;

path = strcat('Physio/HCI_per_',soggetto,'.csv');
Physio = csvread(path);
j = secondi*512;
i = j-30720;
%plot(Physio(:,5));
bvp = Physio(i:j,5);
fs = 512;
fd = fdesign.highpass('N,Fc',2000,1/fs);
H = design(fd);
BVP = filtfilt(H.Numerator,1,bvp);
% subplot(2,1,1);
% plot(bvp);
% subplot(2,1,2);
% plot(BVP);
m = mean(bvp);
maximum = max(bvp);
v = (maximum-m)/4;
%subplot(2,1,1);
%plot(bvp);
%hold on;
%[pks,index] = findpeaks(bvp,'MinPeakProminence',9,'MinPeakHeight',m+v);
%plot(index,pks,'o');
%subplot(2,1,2);
% plot(BVP);
% hold on;
[pks2,index2] = findpeaks(BVP,'MinPeakProminence',8,'MinPeakDistance',round(fs/2));
% plot(index2,pks2,'o');
%intervall = mean(diff(index))*1.953125
intervall2 = mean(diff(index2))*1.953125;
%bpm = 60000 / intervall
bpm2 = 60000 / intervall2
end

