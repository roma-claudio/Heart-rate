clc;
clear all;
close all;

[imgName, path] = uigetfile('Frames/*.jpg*', 'Seleziona un frame');
i = imread([path imgName]);
img=rgb2gray(i);

Sobel = edge(img, 'sobel', 0.023);
Canny = edge(img, 'canny', 0.13,1);
figure;
imshow(Canny);

imgNumber = imgName(1:end-20);
landmarksNumber = imgName(23:end-4);
n = str2num(landmarksNumber);
pathLandmarks = strcat('landmarks/',imgNumber);
M = load(pathLandmarks);
M = M.landmarks;  

x1 = M(n,18,1)
y1 = M(n,18,2)-20
x2 = M(n,23,1)
x3 = M(n,20,1)
x4 = M(n,21,1)
y3 = M(n,20,2)-20
y4 = y3*0.5

A = Canny([y4:y3],[x1:x2]);
figure;
imshow(A);
figure;
plot(sum(A));
[Value,Index]=max(sum(A));
x3 = Index+x1;

for j = y3:-1:1
    if Canny(j,x3) == 1
        y2=j;
        break
    end
end

figure;
plot(sum(A,2));
[Value,Index]=max(sum(A,2));
y3 = Index+y4;

for z = x2:+1:720
    if Canny(y3,z) == 1
       x2=z;
       break
    end
end

x2 = x2-((x4-x3)*0.5); 

c = [x1 x2 x2 x3];
r = [y1 y1 y2 y2];
ROI = roipoly(i,c,r);
figure;
imshow(i);
hold on;
visboundaries(ROI,'LineWidth',1,'Color','b')

x = double(c);
y = double(r);
BW = poly2mask(x,y,576,720);

green = i(:,:,2);
imshow(green)
ROI = double(green).*double(BW);

% sum = 0;
% n = 0;
% for i = 1:1:576 
%     for j = 1:1:720 
%         if product(i,j) ~= 0
%             sum = sum + product(i,j);
%             n = n+1;
%         end
%     end
% end
% 
% mean = sum/n
