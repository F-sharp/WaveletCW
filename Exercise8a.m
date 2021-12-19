close all
clear all
clc
limit_set = (0:0.05:1);
PSNR_set = zeros(1,length(limit_set))
for index = 1:length(limit_set)
    [Tx_RGB, Ty_RGB]= ImageRegistration(limit_set(index));
    % Compute super-resolved image
    [SR_image, PSNR_set(index)]= ImageFusion(Tx_RGB, Ty_RGB);
    % figure()
    % imagesc(SR_image)
    % axis image
    % axis off
end
figure()
plot(limit_set, PSNR_set)
xlabel('threshold')
ylabel('PSNR')
title('PSNR for different threshold')
