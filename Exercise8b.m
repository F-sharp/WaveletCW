close all
clear all
clc
limit_set = (0:0.2:1);
PSNR_set = zeros(1,length(limit_set));
t = Tiff('HR_Tiger_01.tif','r');
imageData = read(t);
figure(7)
subplot(1,7,1)
imshow(imageData)
title('Original image')

for index = 1:length(limit_set)

    [SR_image]= Main_SR(limit_set(index));
    figure(7)
    subplot(1,7,index+1)
    imagesc(SR_image)
    title(sprintf('Threshold = %d',limit_set(index)))
    axis image
    axis off
end
